echo ""
echo "#########################################################################"
echo "######   Installing Fail2ban"
echo "#########################################################################"
echo "procesing..."

sudo yum -y --skip-broken install fail2ban
sudo systemctl enable fail2ban.service

sudo systemctl stop fail2ban.service
sudo systemctl start fail2ban.service

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.bak

sudo sed -i 's/bantime .*/bantime = 86400/g' '/etc/fail2ban/jail.conf'
sudo sed -i 's/maxretry .*/maxretry = 5/g' '/etc/fail2ban/jail.conf'

sudo systemctl stop fail2ban.service
sudo systemctl start fail2ban.service
