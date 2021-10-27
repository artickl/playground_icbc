# playground_icbc
icbc driving test scheduler optimization

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
