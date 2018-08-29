
require 'bundler/setup'
require 'kimurai'
require 'kimurai/all'


puts "coucou"


=begin
browser = Watir::Browser.new :chrome , headless: true
browser.driver.manage.timeouts.implicit_wait = 5

quot_search  = File.open("URL", "r")

quot_search.each_with_index do | line,index |
  browser.goto 'duckduckgo.com'
  search_bar = browser.text_field(class: 'js-search-input')
  sleep 2
  test = " accident -pieton collision train " + "site:" + line.split("!")[1]
  search_bar.set(test)
  
  p browser
  break
end

browser.close
=end
