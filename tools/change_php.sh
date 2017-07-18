echo ""
echo "#########################################################################"
echo "######   Installing/Changing PHP"
echo "#########################################################################"

sudo systemctl stop httpd.service
sudo yum -y --skip-broken remove php* mod_php*

sudo sh include/install_php.sh

sudo sh include/yetiforce.sh

echo ""
echo "/////////////////////////////////////////////////////////////////////////"
echo "/////////////////// The script completed successfully ///////////////////"
echo "/////////////////////////////////////////////////////////////////////////"
echo ""
