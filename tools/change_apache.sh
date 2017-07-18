echo ""
echo "#########################################################################"
echo "######   Installing/Changing Apache"
echo "#########################################################################"

sudo systemctl stop httpd.service
sudo yum -y --skip-broken remove httpd*

sudo sh include/install_apache.sh

echo ""
echo "/////////////////////////////////////////////////////////////////////////"
echo "/////////////////// The script completed successfully ///////////////////"
echo "/////////////////////////////////////////////////////////////////////////"
echo ""
