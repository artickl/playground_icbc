import pytest
from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import configparser
from time import sleep

config = configparser.ConfigParser()
config.read('./tests/test_icbc.ini')

@pytest.fixture
def browser():
  driver = Chrome()
  driver.implicitly_wait(10)
  yield driver
  driver.quit()

def test_icbc(browser):
  URL = "https://onlinebusiness.icbc.com/webdeas-ui/login;type=driver"
  F_DRIVER = config['DEFAULT']['driver1']
  F_LICENSE = config['DEFAULT']['license2']
  F_KEYWORD = config['DEFAULT']['keyword3']

  browser.maximize_window()
  browser.get(URL)  
  
  search_input = browser.find_element_by_id('mat-input-0')
  search_input.send_keys(F_DRIVER)
  
  search_input = browser.find_element_by_id('mat-input-1')
  search_input.send_keys(F_LICENSE)

  search_input = browser.find_element_by_id('mat-input-2')
  search_input.send_keys(F_KEYWORD)
  
  search_input = browser.find_element_by_id('mat-checkbox-1-input')
  search_input.send_keys(" ")

  button = browser.find_elements_by_xpath("//button[@class='mat-raised-button mat-button-base mat-accent']")
  button[0].click()
  
  sleep(2)

  search_input = browser.find_element_by_id('mat-input-3')
  search_input.send_keys(config['DEFAULT']['location1'].strip("'"))
  sleep(3)
  try:
    WebDriverWait(browser, 3).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]'))) 
  except:
    search_input.send_keys(Keys.BACKSPACE + Keys.BACKSPACE)
    try:
      WebDriverWait(browser, 3).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
    except:
      search_input.send_keys("BC")
      try:
        WebDriverWait(browser, 3).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
      except:
        search_input.send_keys(Keys.BACKSPACE + Keys.BACKSPACE)
        WebDriverWait(browser, 3).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
        
  search_input.find_elements(By.XPATH,'//*[@class="mat-option-text"]')[0].click()

  #search_input = browser.find_element_by_xpath("//span[@class='mat-option-text']")
  #search_input[1].click()
  #sleep(1)
  #search_input.send_keys(Keys.BACKSPACE)
  #sleep(1)  
  #search_input.send_keys(Keys.ENTER)
  #search_input = browser.find_elements_by_xpath("//div[@class='mat-autocomplete-panel mat-autocomplete-visible ng-star-inserted']")
  #search_input[0].click()

  #sleep(10)

  button = browser.find_elements_by_xpath('//*[@id="search-dialog"]/app-search-modal/div/div/form/div[2]/button/span')
  sleep(1)

  button[0].click()

  locations = browser.find_elements(By.XPATH,'//*[@class="background-highlight"]')
  locations[0].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date,place))

  locations[1].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date,place))

  locations[2].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date,place))

  locations[3].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date, place))

  locations[4].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date, place))

  locations[5].click()
  sleep(1)
  place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
  try:
    date = browser.find_elements(By.XPATH,'//*[@class="date-title"]')[0].text
  except:
    date = browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text
  print("%s %s" % (date, place))

  sleep(5)
  #sign in
 # /html/body/app-root/app-login/mat-card/mat-card-content/form/div[3]/button[2]
  
  #link_divs = browser.find_elements_by_css_selector('#links > div')
  #assert len(link_divs) > 0
  
  #xpath = f"//div[@id='links']//*[contains(text(), '{PHRASE}')]"
  #results = browser.find_elements_by_xpath(xpath)
  #assert len(results) > 0
  
  #search_input = browser.find_element_by_id('search_form_input')
  #assert search_input.get_attribute('value') == PHRASE