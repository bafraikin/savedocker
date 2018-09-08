require 'bundler/setup'
require 'kimurai'
require 'kimurai/all'
require 'pry'

class InfiniteScrollCrawler < Kimurai::Base
  @name = "infinite_scroll_crawler"
  @driver = :selenium_chrome
  @start_urls = ["https://www.google.com"]
  @config = {headless_mode: :virtual_display}

  def parse(response, url:, data: {})
    posts_headers_path = "//article/h2"
    count = response.xpath(posts_headers_path).count
    binding.pry

    loop do
      a = browser.first(:css, '.gsfi')
      a.set("site:#{Hebdo.next.split("!")[2].to_s}") ; sleep 2
      a.send_keys(:enter)
      response = browser.current_response
      binding.pry

      new_count = response.xpath(posts_headers_path).count
      if count == new_count
        logger.info "> Pagination is done" and break
      else
        count = new_count
        logger.info "> Continue scrolling, current count is #{count}..."
      end
    end

    posts_headers = response.xpath(posts_headers_path).map(&:text)
    logger.info "> All posts from page: #{posts_headers.join('; ')}"
  end
end

class Hebdo
  def self.next
    parser = File.open('URL').read
    parser = parser.split("\n")
    nb = parser.map {| a | a.split("!")[0].to_i}.each_with_index.min
    tmp = parser[nb[1]].split("!")
    tmp[0] = tmp[0].to_i + 1
    tmp =  tmp.join("!")
    parser[nb[1]] = tmp
    File.write('URL', parser.join("\n"))
    return (tmp)
  end
end

InfiniteScrollCrawler.start!
