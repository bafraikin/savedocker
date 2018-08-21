require 'watir'
require 'headless'

=begin
def get_arguments
  browser_arguments = { }

  capabilities = Selenium::WebDriver::Remote::Capabilities.firefox()

  capabilities[:name] = 'Watir'
  browser_arguments[:opt] = capabilities

  browser_arguments
end
=end



headless = Headless.new
headless.start

browser = Watir::Browser.new(:firefox,
                             :prefs => {:password_manager_enable => false, :credentials_enable_service => false},
                             :switches => ["disable-infobars", "no-sandbox"])
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
headless.destroy
