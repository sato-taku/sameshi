Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('diable_gpu')
  options.add_argumrnt('window-size=1680,1050')
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENv['SELENIUM_DRIVER_URL'], capabilities: options)
end