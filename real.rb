require 'bundler/setup'
require 'kimurai'
require 'kimurai/all'
require 'pry'

class Hebdo
  def self.next
    parser = File.open('URL').read
    parser = parser.split("\n")
    nb = parser.map {|a| a.split("!")[0].to_i}.each_with_index.min
    tmp = parser[nb[1]].split("!")
    tmp[0] = tmp[0].to_i + 1
    tmp =  tmp.join("!")
    parser[nb[1]] = tmp
    File.write('URL', parser.join("\n"))
    return (tmp)
  end
end

class InfiniteScrollCrawler < Kimurai::Base
  @name = "infinite_scroll_crawler"
  @driver = :selenium_chrome
  @start_urls = ["https://www.google.com"]

  def parse(response, url:, data: {})
    url_result_path = "div div.rc h3.r a"
    next_path = "html body#gsr.srp.tbo.vasq div#main div#cnt.mdm div.mw div#rcnt div.col div#center_col div div#foot span#xjs div#navcnt table#nav tbody tr td.b.navend a#pnnext.pn"
    unless data[:boolean]
      hebdo = Hebdo.next.split("!")
      hebdo_path = hebdo[2].to_s
      hebdo_name = hebdo[1].to_s
      tmp = browser.first(:css, '.gsfi')
      tmp.set("site:#{hebdo_path}") ; sleep 2
      logger.info "checking for #{hebdo_name}"  
      tmp.send_keys(:enter) ; sleep 2
    end
    response = browser.current_response
    if (result = response.css(url_result_path).map{|c| c[:href]}) != []
=begin
            result.each do |url_result|
        request_to :parse_result_page, url: url_result, data: {
          name: hebdo_name
        }
        end
=end
      logger.info result
      if (btn_next = response.css(next_path)).first != nil  && ( data[:nbr] == nil || data[:nbr] < 2)
        request_to :parse, url: absolute_url(btn_next.first[:href], base: url), data: {boolean: true, nbr: (data[:nbr] || 0) + 1} 
      end
    elsif data[:nbr] == nil
      request_to :parse, url: url, data: {boolean: false, nbr: (data[:nbr] || 0) + 1}
    end
  end


  def parse_hebdo_page(response, url:, data: {})
    item = {}
    text = ""
    response.css('p').each_with_index do |para, index|
      if index < 10
        text += para.text
      else
        break   
      end
    end
    item[:date] = CommonRegex.new(text).get_dates[0]
    item[:title] = response.title
    item[:url] = url
    item[:description] = text.split("\n").max_by(&:length)
    binding.pry
    puts response.css("img")
    #       save_to "results.json", item, format: :pretty_json
  end
end

a =  GoogleCrawler.new
a.parse_hebdo_page(Nokogiri::HTML(open('http://www.lavoixdunord.fr/archive/recup/region/accident-ferroviaire-a-arneke-deux-cents-passagers-bloques-le-trafic-des-trains-interrompu-ia37b0n267583#')), url: "http://www.lavoixdunord.fr/archive/recup/region/accident-ferroviaire-a-arneke-deux-cents-passagers-bloques-le-trafic-des-trains-interrompu-ia37b0n267583#")



