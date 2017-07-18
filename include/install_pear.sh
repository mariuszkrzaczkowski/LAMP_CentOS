echo ""
echo "#########################################################################"
echo "######   Installing librerias de PEAR"
echo "#########################################################################"
echo "procesing..."

sudo pear upgrade-all
sudo pear install --alldeps Auth_SASL-1.1.0
sudo pear install --alldeps Net_SMTP-1.8.0
sudo pear install --alldeps Net_IDNA2-0.2.0
sudo pear install --alldeps Mail_Mime-1.10.1

sudo systemctl stop httpd.service
sudo systemctl start httpd.service
