Process.spawn('java -Dwebdriver.chrome.driver=chromedriver -jar selenium-server-standalone-2.48.2.jar -role hub')
Process.spawn('java -Dwebdriver.chrome.driver=chromedriver -jar selenium-server-standalone-2.48.2.jar -role node -hub http://127.0.0.1:4444/grid/register -port 5555')
