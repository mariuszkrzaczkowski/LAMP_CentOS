echo ""
echo "#########################################################################"
echo "######   Installing/Changing MariaDB"
echo "#########################################################################"

sudo systemctl stop mariadb.service
sudo yum -y --skip-broken remove mariadb* mysql*

usuarioActual=$(whoami)
sudo sh include/install_mariadb.sh $usuarioActual

echo ""
echo "/////////////////////////////////////////////////////////////////////////"
echo "/////////////////// The script completed successfully ///////////////////"
echo "/////////////////////////////////////////////////////////////////////////"
echo ""
