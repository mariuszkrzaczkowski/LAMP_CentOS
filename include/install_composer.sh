echo ""
echo "#########################################################################"
echo "######   Installing COMPOSER"
echo "#########################################################################"
echo "procesing..."

EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ];then
  >&2 echo 'ERROR: Invalid installer signature'
  sudo rm composer-setup.php
  exit 1
fi
sudo php composer-setup.php --quiet
sudo rm -f composer-setup.php
sudo cp -f composer.phar /var/www/html/composer.phar
sudo rm -f /usr/local/bin/composer
sudo mv -f composer.phar /usr/local/bin/composer

cd /var/www/html/
php composer.phar update
#composer update #not work in script

sudo chown -hR apache:apache /var/www/html/
