### Opcional - pre-install for "VirtualBox Guest Additions"
    sudo yum -y groupinstall "Development Tools"

    sudo mkdir -p /media/cdrom/
    sudo mount /dev/cdrom /media/cdrom/
    sudo KERN_DIR=/usr/src/kernels/3.??.?-???.??.?.???.x86_64/ sh /media/cdrom/VBoxLinuxAdditions.run

### Install LAMP in CentOS 7.3.XXXX -> Apache 2.4.XX, MariaDB 10.1.XX, PHP 5.6.XX/7.1.XX
    sudo yum -y -q install git
    sudo rm -Rf LAMP_CentOS
    git clone -b master https://github.com/WalterLuis/LAMP_CentOS.git
    chown -hR root:root *
    cd LAMP_CentOS
    sudo chmod 0700 *
    sudo sh install_LAMP.sh

### Permission apache:apache
    sudo chown -hR apache:apache /var/www/html/

### RPM
    #Install
    sudo rpm -ivh --replacepkgs <url_from: https://www.rpmfind.net>
    #unistall
    rpm -qa | grep -i webmin
    rpm -e <package name>
