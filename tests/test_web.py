import pytest
from selenium.webdriver import Chrome
from selenium.webdriver.common.keys import Keys
import configparser

config = configparser.ConfigParser()
config.read('test_web.ini')

@pytest.fixture
def browser():
  driver = Chrome()
  driver.implicitly_wait(10)
  yield driver
  driver.quit()


def test_basic_duckduckgo_search(browser):
  URL = 'https://www.duckduckgo.com'
  PHRASE = 'panda'
  
  browser.get(URL)
  
  search_input = browser.find_element_by_id('search_form_input_homepage')
  search_input.send_keys(PHRASE + Keys.RETURN)
  
  link_divs = browser.find_elements_by_css_selector('#links > div')
  assert len(link_divs) > 0
  
  xpath = f"//div[@id='links']//*[contains(text(), '{PHRASE}')]"
  results = browser.find_elements_by_xpath(xpath)
  assert len(results) > 0
  
  search_input = browser.find_element_by_id('search_form_input')
  assert search_input.get_attribute('value') == PHRASE

#def check_icbc
#  URL = "https://onlinebusiness.icbc.com/webdeas-ui/login;type=driver"
#  driver = config['DEFAULT']['driver']
#  license = config['DEFAULT']['license']
#  keyword = config['DEFAULT']['keyword']

  #driver
 # //*[@id="mat-input-0"]
  #license
 # //*[@id="mat-input-1"]
  #keyword
 # //*[@id="mat-input-2"]
  #checkmark
 # //*[@id="mat-checkbox-1-input"]
  #sign in
 # /html/body/app-root/app-login/mat-card/mat-card-content/form/div[3]/button[2]
