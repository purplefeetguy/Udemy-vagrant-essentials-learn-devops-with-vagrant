# Update the repositories
sudo apt -y update
# Download the necessary prerequisites
sudo apt install -y apache2 php php-mbstring php-zip phpunit unzip libapache2-mod-php
# Set the root password for installing MySQL without prompting for password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
# Install MySQL server
sudo apt-get install -y mysql-server
# Start the service
sudo service mysql start
#Create a database, user and password for the application
mysql -u root -padmin < /vagrant/createUser.sql
#Download composer
curl -Ss https://getcomposer.org/installer | php
# Move the downloaded file to a place that is accessible by all users
sudo mv composer.phar /usr/bin/composer
# Chaneg the ownsership of the web directory to enable vagrant user to use it
sudo chown -R vagrant:vagrant /var/www
# Install Laravel 5 using componser
composer global require laravel/installer
# Create a new Laravel 5 project using composer
cd /var/www/
composer create-project --prefer-dist laravel/laravel myProject
# Change the ownsership of storage directory to be 777 (Laravel requirement)
sudo chmod -R 777 /var/www/myProject/storage
# Change the default web site in Apache2 configuration to point to the Laravel web directory
sudo sed -i 's/DocumentRoot.*/DocumentRoot \/var\/www\/myProject\/public/' /etc/apache2/sites-available/000-default.conf
# Restart Apache2 to reflect the changes
sudo apachectl restart
# Configure the database name, user and password in the Laravel configuration file to point to th newly cerated database
sed -i '/mysql/{n;n;n;n;s/'\''DB_DATABASE'\'', '\''.*'\''/'\''DB_DATABASE'\'', '\''myProject'\''/g}' /var/www/myProject/config/database.php 
sed -i '/mysql/{n;n;n;n;n;s/'\''DB_USERNAME'\'', '\''.*'\''/'\''DB_USERNAME'\'', '\''myProject'\''/g}' /var/www/myProject/config/database.php
sed -i '/mysql/{n;n;n;n;n;n;s/'\''DB_PASSWORD'\'', '\''.*'\''/'\''DB_PASSWORD'\'', '\''myPassword'\''/g}' /var/www/myProject/config/database.php
