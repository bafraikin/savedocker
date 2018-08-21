require 'watir'

browser = Watir::Browser.new :firefox
browser.driver.manage.timeouts.implicit_wait = 5

quot_search  = File.open("app/URL", "r")

quot_search.each_with_index do | line,index |
  browser.goto 'duckduckgo.com'
  search_bar = browser.text_field(class: 'js-search-input')
  search_bar.set("site:" + line.split("!")[1] + " -pieton accident collision train" )
  search_bar.send_keys(:enter)

  p browser.divs(class: "no-results")[0].text

end

browser.close
