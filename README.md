Users management test application
=====

Prerequisites
------
1. Web server with PHP support 
2. PHP Pear (sudo apt-get install php-pear)
3. Services_JSON PHP module (sudo pear install Services_JSON)

Running
------
1. Run npm install
2. Run grunt
3. Point your webserver to the 'public' folder

Unit tests
------
karma start client/test/karma.conf.js