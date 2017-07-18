echo ""
echo "#########################################################################"
echo "######   What version do you want to install from YetiForceCRM?"
echo "#########################################################################"

sudo systemctl stop httpd.service
sudo systemctl start httpd.service

select yn in "Stable" "Developer" "Nothing";do
  case $yn in
    Stable)
    echo "procesing..."
    sudo rm -Rf /var/www/html/
    sudo mkdir /var/www/html/
    sudo git clone -b stable https://github.com/YetiForceCompany/YetiForceCRM.git /var/www/html/
    sudo chown -hR apache:apache /var/www/html/
    sudo sh include/install_composer.sh
    break;;
    Developer)
    echo "procesing..."
    sudo rm -Rf /var/www/html/
    sudo mkdir /var/www/html/
    sudo git clone -b developer https://github.com/YetiForceCompany/YetiForceCRM.git /var/www/html/
    sudo chown -hR apache:apache /var/www/html/
    sudo sh include/install_composer.sh
    break;;
    Nothing) break;;
  esac
done

sudo systemctl stop httpd.service
sudo systemctl start httpd.service
