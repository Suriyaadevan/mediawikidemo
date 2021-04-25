#! /bin/bash
 sudo mv /home/username/LocalSettings.php   /var/www/html/mediawiki/ 
#provide access to the newly uploaded LocalSettings.Php
sudo chmod 755 /var/www/html/mediawiki/
sudo getenforce
sudo restorecon -FR /var/www/html/mediawiki/