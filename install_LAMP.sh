echo "/////////////////////////////////////////////////////////////////////////"
echo "/////////////////// Starting script, waiting please /////////////////////"
echo "/////////////////////////////////////////////////////////////////////////"
echo ""

usuarioActual=$(whoami)
sudo yum -y --skip-broken remove mariadb* httpd* php* mysql* mod_php*

# SELINUX
sudo sh include/check_selinux.sh

# REPO
sudo sh include/install_repo.sh

# APACHE
sudo sh include/install_apache.sh

# MariaDB
sudo sh include/install_mariadb.sh $usuarioActual

# PHP
sudo sh include/install_php.sh

# Firewall
sudo sh include/install_firewall.sh

echo ""
echo "#########################################################################"
echo "######   Completing installation..."
echo "#########################################################################"
echo "procesing..."

echo "Stopping and starting services to apply changes..."

sudo systemctl stop httpd.service
sudo systemctl stop mariadb.service
sudo systemctl start httpd.service
sudo systemctl start mariadb.service

sudo sh include/create_newuser.sh $usuarioActual

sudo sh include/install_fail2ban.sh

sudo sh include/yetiforce.sh

echo ""
echo "/////////////////////////////////////////////////////////////////////////"
echo "/////////////////// The script completed successfully ///////////////////"
echo "/////////////////////////////////////////////////////////////////////////"
echo ""

sudo sh include/delete_script.sh $usuarioActual
