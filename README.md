# ICBC
icbc driving test check of availability

## Install / Pre-Install
```
$ pip3 install pipenv
$ pipenv install pytest --dev
$ pipenv install selenium --dev
$ sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add
$ sudo bash -c "echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list" 
$ sudo apt -y update
$ sudo apt -y install google-chrome-stable 
$ google-chrome --version 
Google Chrome 95.0.4638.54

- find correct version here: https://sites.google.com/chromium.org/driver/downloads
$ wget https://chromedriver.storage.googleapis.com/95.0.4638.17/chromedriver_linux64.zip 
$ unzip chromedriver_linux64.zip
$ ./chromedriver 
Starting ChromeDriver 95.0.4638.17 (a9d0719444d4b035e284ed1fce73bf6ccd789df2-refs/branch-heads/4638@{#178}) on port 9515
Only local connections are allowed.
Please see https://chromedriver.chromium.org/security-considerations for suggestions on keeping ChromeDriver safe.
ChromeDriver was started successfully.

$ sudo cp -v chromedriver /usr/bin/
```

## Config
```
$ cp test_icbc.ini.example test_icbc.ini
$ cat 
```

## Run
```
$ pipenv run python -m pytest -s tests/test_icbc.py | tee test_icbc.log | grep '\[I\]:'
[I]: Friday, April 22nd, 2022 - Langley driver licensing (Willowbrook Center)
[I]: Monday, April 25th, 2022 - Langley driver licensing (Willowbrook Center)
[I]: Tuesday, March 8th, 2022 - Port Coquitlam driver licensing
[I]: Wednesday, April 13th, 2022 - Port Coquitlam driver licensing
[I]: Wednesday, April 20th, 2022 - Port Coquitlam driver licensing
[I]: Monday, April 25th, 2022 - Port Coquitlam driver licensing
```

# TELEGRAM

## Prerequirement
curl
jq - from https://stedolan.github.io/jq/download/
```
$ wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
$ chmod +x jq-linux64 
$ mv jq-linux64 jq
```

## Sending message
```
$ ./telegram.sh "a b c d - test"
```

## Full command
```
playground_icbc$ pipenv run python -m pytest -s tests/test_icbc.py | grep '\[I\]:' | grep -e "October" -e "November" -e "December" -e "January" | while read line; do tests/telegram.sh "$line"; done
```