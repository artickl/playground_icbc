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
  
  browser.find_element(By.ID,'mat-input-0').send_keys(F_DRIVER)
  browser.find_element(By.ID,'mat-input-1').send_keys(F_LICENSE)
  browser.find_element(By.ID,'mat-input-2').send_keys(F_KEYWORD)
  browser.find_element(By.ID,'mat-checkbox-1-input').send_keys(" ")

  button = browser.find_elements(By.XPATH,"//button[@class='mat-raised-button mat-button-base mat-accent']")
  button[0].click()
  sleep(3)

  location_input = browser.find_element(By.ID,'mat-input-3')
  location_input.send_keys(config['DEFAULT']['location1'].strip("'"))
  sleep(2)
  try:
    WebDriverWait(browser, 2).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]'))) 
  except:
    location_input.send_keys(Keys.BACKSPACE + Keys.BACKSPACE)
    try:
      WebDriverWait(browser, 2).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
    except:
      location_input.send_keys("BC")
      try:
        WebDriverWait(browser, 2).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
      except:
        location_input.send_keys(Keys.BACKSPACE + Keys.BACKSPACE)
        WebDriverWait(browser, 2).until(EC.element_to_be_clickable((By.XPATH,'//*[@class="mat-option-text"]')))
        
  browser.find_elements(By.XPATH,'//*[@class="mat-option-text"]')[0].click()
  sleep(2)

  button = browser.find_elements(By.XPATH,'//*[@id="search-dialog"]/app-search-modal/div/div/form/div[2]/button/span')
  button[0].click()

  locations = browser.find_elements(By.XPATH,'//*[@class="background-highlight"]')
  for location in locations:
    location.click()
    sleep(2)
    place = browser.find_elements(By.XPATH,'//*[@class="location-title"]')[0].text
    try:
      dates = browser.find_elements(By.XPATH,'//*[@class="date-title"]')
      for date in dates:
        print("\n[I]: %s - %s" % (date.text, place))
    except:
      print("[W]: %s - %s" % (browser.find_elements(By.XPATH,'//*[@class="no-appts-msg"]')[0].text,place))
  
  sleep(5)