echo ""
echo "#########################################################################"
echo "######   Installing MariaDB"
echo "#########################################################################"

sudo rm -Rf /var/log/mariadb/
sudo touch /var/log/mariadb/mariadb.log

echo "CAUTION!!!"
echo "Do you want to delete all databases with your tables?"
select yn in "Remove" "No_Remove";
do
  case $yn in
    Remove)
    echo "procesing..."
    sudo rm -Rf /var/lib/mysql/
    break;;
    No_Remove) break;;
  esac
done

echo ""

select yn in "mariadb55" "mariadb101u";
do
  case $yn in
    mariadb55)
    echo "procesing..."
    sudo rm -Rf /etc/my.cnf*
    sudo yum -y --skip-broken mariadb-common
    sudo yum -y --skip-broken install mariadb mariadb-server mariadb-libs mysql-connector-odbc
    sudo systemctl enable mariadb.service
    sudo systemctl start mariadb.service
    sudo sed -i"my.cnf.bak" '5a sql-mode="NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" \nmax_allowed_packet=16M \ninnodb_lock_wait_timeout=600 \n' /etc/my.cnf
    break;;
    mariadb101u)
    echo "procesing..."
    sudo rm -Rf /etc/my.cnf*
    sudo yum -y --skip-broken install mariadb101u-common
    sudo yum -y --skip-broken install mariadb101u mariadb101u-server mariadb101u-libs mysql-connector-odbc
    sudo systemctl enable mariadb.service
    sudo systemctl start mariadb.service
    sudo sed -i"my.cnf.bak" '12a sql-mode="NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" \nmax_allowed_packet=16M \ninnodb_lock_wait_timeout=600 \n' /etc/my.cnf
    break;;
  esac
done

sudo sed -i".bak1" '/#.*/d' /etc/my.cnf
sudo sed -i".bak" '/^$/d' /etc/my.cnf
sudo sed -i".bak" '/./!d' /etc/my.cnf

sudo systemctl stop mariadb.service
sudo systemctl start mariadb.service

dbpass=$(pwgen -1cnys 24)

echo ""
echo "#########################################################################"
echo "######   "
echo "###   Password generada de 24bits opcional para password de mysql ->  "$dbpass
echo "######   "
echo "#########################################################################"

if [ ${1} == "root" ];then
  sudo touch /root/dbpass.conf
  sudo echo $dbpass >> /root/dbpass.conf
else
  sudo touch /home/$usuarioActual/dbpass.conf
  sudo echo $dbpass >> /home/$usuarioActual/dbpass.conf
fi

sudo mysql_secure_installation

sudo systemctl stop mariadb.service
sudo systemctl start mariadb.service
