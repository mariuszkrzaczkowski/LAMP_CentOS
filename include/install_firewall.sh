echo ""
echo "#########################################################################"
echo "######   Desactivar Firewalld e instalar IPtables?"
echo "#########################################################################"

select yn in "IPtables" "Firewalld" "No_Install_Firewall";do
  case $yn in
    IPtables)
    echo "procesing..."
    sudo systemctl mask firewalld
    sudo service firewalld stop
    sudo systemctl disable firewalld
    sudo yum -y remove firewalld
    sudo yum -y --skip-broken install iptables-services
    sudo systemctl enable iptables
    sudo service iptables start
    sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp -m multiport --dports 80,443,22,10000 -j ACCEPT
    sudo service iptables save
    sudo service iptables stop
    sudo service iptables start
    break;;
    Firewalld)
    echo "procesing..."
    sudo service iptables stop
    sudo systemctl disable iptables
    sudo service ip6tables stop
    sudo systemctl disable ip6tables
    sudo systemctl start firewalld.service
    sudo firewall-cmd --permanent --add-port=80/tcp
    sudo firewall-cmd --permanent --add-service http
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --permanent --add-service https
    sudo firewall-cmd --permanent --add-port=22/tcp
    sudo firewall-cmd --permanent --add-port=10000/tcp
    sudo systemctl restart firewalld.service
    break;;
    No_Install_Firewall)
    echo "procesing..."
    sudo service iptables stop
    sudo systemctl disable iptables
    sudo service ip6tables stop
    sudo systemctl disable ip6tables
    sudo service firewalld stop
    sudo systemctl disable firewalld
    break;;
  esac
done
# ids -> OS: pfsese
