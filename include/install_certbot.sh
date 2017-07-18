echo ""
echo "#########################################################################"
echo "######  Installing CERTBOT"
echo "######  Important: If you do not have a valid domain name it is possible "
echo "######             for error and the Apache server does not start"
echo "######  "
echo "######  If you are not sure or do not start Apache, do not install certbot"
echo "#########################################################################"

select yn in "Install_Certbot" "No_Install_Certboot";do
  case $yn in
    Install_Certbot)
    echo "procesing..."

    miip=$(curl -s ifconfig.co)
    mihostname=$(nslookup $miip | grep name | awk '{print $4 }' | sed -e 's/.$//')

    sudo systemctl stop httpd.service

    #    if [[ -f /etc/letsencrypt/archive/${2}/dh4096.pem ]];then
    #      echo "EXIST"
    #      echo ${2}
    #      #sudo sed -i "s/SSLCertificateFile .*/SSLCertificateFile \/etc\/letsencrypt\/archive\/$mihostname\/dh4096.pem/g" '/etc/httpd/conf.d/ssl.conf'
    #    else
    #      echo "NO EXIST"
    #      echo ${2}
    #      #sudo mkdir /etc/letsencrypt/archive/$mihostname/
    #      #sudo openssl dhparam -out /etc/letsencrypt/archive/$mihostname/dh4096.pem 4096 # Invalid command 'SSLOpenSSLConfCmd'
    #      #SSLOpenSSLConfCmd DHParameters "/etc/ssl/private/dh4096.pem"#Only for openssl >= 1.0.2d
    #      #sudo cat /etc/letsencrypt/live/$mihostname/fullchain.pem /etc/ssl/private/dh4096.pem > /etc/letsencrypt/archive/$mihostname/fullchain_dh4096.pem
    #      #sudo sed -i "s/SSLCertificateFile .*/SSLCertificateFile \/etc\/letsencrypt\/archive\/$mihostname\/dh4096.pem/g" '/etc/httpd/conf.d/ssl.conf'
    #    fi

    sudo yum -y remove certbot*
    sudo find / -name certbot* -exec rm -rf {} \;
    sudo rm -Rf /usr/bin/letsencrypt*
    sudo rm -Rf /etc/letsencrypt*
    sudo yum -y remove *certbot*
    sudo mkdir /etc/letsencrypt
    sudo mkdir /var/lib/letsencrypt
    sudo yum -y --skip-broken install *certbot*
    sudo certbot certonly --standalone --non-interactive --register-unsafely-without-email --agree-tos --rsa-key-size 4096 -d $mihostname
    #sudo certbot certonly --standalone --non-interactive --register-unsafely-without-email --agree-tos --rsa-key-size 4096 --force-renew -d $mihostname

    sudo sed -i "s/SSLCertificateFile \/etc.*/SSLCertificateFile \/etc\/letsencrypt\/live\/$mihostname\/cert.pem/g" '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i "s/SSLCertificateKeyFile \/etc.*/SSLCertificateKeyFile \/etc\/letsencrypt\/live\/$mihostname\/privkey.pem/g" '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i "s/#SSLCertificateChainFile \/etc.*/SSLCertificateChainFile \/etc\/letsencrypt\/live\/$mihostname\/chain.pem/g" '/etc/httpd/conf.d/ssl.conf'

    pinCert=$(sudo openssl x509 -in /etc/letsencrypt/live/$mihostname/cert.pem -pubkey -noout | sudo openssl rsa -pubin -outform der | sudo openssl dgst -sha256 -binary | sudo openssl enc -base64)
    pinChain=$(sudo openssl x509 -in /etc/letsencrypt/live/$mihostname/chain.pem -pubkey -noout | sudo openssl rsa -pubin -outform der | sudo openssl dgst -sha256 -binary | sudo openssl enc -base64)
    pinPrivate=$(sudo openssl rsa -in /etc/letsencrypt/live/$mihostname/privkey.pem -outform der | sudo openssl dgst -sha256 -binary | sudo openssl enc -base64)

    sudo echo "Header always set Public-Key-Pins 'pin-sha256=\"$pinCert\"; pin-sha256=\"$pinChain\"; pin-sha256=\"$pinPrivate\"; max-age=15768000; includeSubDomains'" >> /etc/httpd/conf/httpd.conf

    #sudo echo "* 4 * * * root certbot renew --rsa-key-size 4096" >> /etc/crontab

    sudo sed -i".bak1" '/#.*/d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak" '/^$/d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak" '/./!d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak1" '/#.*/d' /etc/httpd/conf.d/ssl.conf
    sudo sed -i".bak" '/^$/d' /etc/httpd/conf.d/ssl.conf
    sudo sed -i".bak" '/./!d' /etc/httpd/conf.d/ssl.conf

    sudo systemctl start httpd.service
    break;;
    No_Install_Certboot)

    sudo sed -i".bak1" '/#.*/d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak" '/^$/d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak" '/./!d' /etc/httpd/conf/httpd.conf
    sudo sed -i".bak1" '/#.*/d' /etc/httpd/conf.d/ssl.conf
    sudo sed -i".bak" '/^$/d' /etc/httpd/conf.d/ssl.conf
    sudo sed -i".bak" '/./!d' /etc/httpd/conf.d/ssl.conf

    break;;
  esac
done
