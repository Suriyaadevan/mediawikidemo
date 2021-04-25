#! /bin/bash
sudo yum -y install httpd php php-mysql php-gd mariadb-server php-xml php-intl mysql wget
sudo systemctl restart httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo wget https://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.2.tar.gz
sudo tar -zxpvf mediawiki-1.24.2.tar.gz
sudo mv mediawiki-1.24.2 /var/www/html/mediawiki
sudo chown -R apache:apache /var/www/html/mediawiki/
sudo chmod 755 /var/www/html/mediawiki/
sudo getenforce
sudo restorecon -FR /var/www/html/mediawiki/
echo "********Connecting MYSQL********"
mysql -u root -e "create database mediawiki_db"; 
mysql -u root -e "CREATE DATABASE mediawiki_db"; 
mysql -u root -e "GRANT ALL PRIVILEGES ON mediawiki_db.* TO 'wiki_user'@'localhost' IDENTIFIED BY 'P@ssWord@123#' WITH GRANT OPTION;
"; 
mysql -u root -e "FLUSH PRIVILEGES;"; 
exit;


echo "********END**************" 