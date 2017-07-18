echo ""
echo "#########################################################################"
echo "######   Installing IUS, EPEL, REPEL"
echo "#########################################################################"
echo "procesing..."

sudo yum -y --skip-broken install epel-release
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo rpm -Uvh https://centos7.iuscommunity.org/ius-release.rpm
sudo yum clean all
sudo yum -y --skip-broken update
sudo yum -y --skip-broken install pwgen iftop libzip unzip bind-utils
