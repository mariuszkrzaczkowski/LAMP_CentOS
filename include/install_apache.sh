echo ""
echo "#########################################################################"
echo "######   Installing APACHE"
echo "#########################################################################"

select yn in "httpd_STABLE" "httpd24u_DEV";do
  case $yn in
    httpd_STABLE)
    echo "procesing..."

    sudo rm -Rf /var/log/httpd/
    sudo touch /var/log/httpd/access_log
    sudo touch /var/log/httpd/ssl_access_log
    sudo touch /var/log/httpd/error_log
    sudo touch /var/log/httpd/ssl_error_log

    sudo rm -Rf /etc/httpd/*
    sudo rm -Rf /etc/httpd/.*
    sudo yum -y --skip-broken install httpd httpd-tools
    apacheVersion="httpd"
    break;;
    httpd24u_DEV)
    echo "procesing..."

    sudo rm -Rf /var/log/httpd/
    sudo touch /var/log/httpd/access_log
    sudo touch /var/log/httpd/ssl_access_log
    sudo touch /var/log/httpd/error_log
    sudo touch /var/log/httpd/ssl_error_log

    sudo rm -Rf /etc/httpd/*
    sudo rm -Rf /etc/httpd/.*
    sudo yum -y --skip-broken install httpd24u httpd24u-tools
    apacheVersion="httpd24u"
    break;;
  esac
done

miip=$(curl -s ifconfig.co)
mihostname=$(nslookup $miip | grep name | awk '{print $4 }' | sed -e 's/.$//')

sudo systemctl enable httpd.service
sudo echo "#" > /etc/httpd/conf.d/welcome.conf

sudo sed -i "s/Listen 8.*/Listen 80/g" '/etc/httpd/conf/httpd.conf'
sudo sed -i 's/AllowOverride None/AllowOverride all/g' '/etc/httpd/conf/httpd.conf'
sudo sed -i 's/DocumentRoot.*/DocumentRoot "\/var\/www\/html\/public_html"/g' '/etc/httpd/conf/httpd.conf'
sudo sed -i 's/LogLevel .*/LogLevel crit/g' '/etc/httpd/conf/httpd.conf'
sudo sed -i "s/#ServerName .*/ServerName $mihostname/g" '/etc/httpd/conf/httpd.conf'
sudo sed -i 's/ServerAdmin root.*/ServerAdmin info@itop.es/g' '/etc/httpd/conf/httpd.conf'

sudo mkdir /var/www/html/public_html/

sudo systemctl start httpd.service

sudo sh include/install_https.sh $apacheVersion $miip $mihostname
