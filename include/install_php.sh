sudo systemctl stop httpd.service
sudo systemctl start httpd.service

echo ""
echo "#########################################################################"
echo "######   Installing PHP [RECOMMENDED: 4]"
echo "#########################################################################"

select yn in "php56w" "php56u" "php71w" "php71u";do
  case $yn in
    php56w)
    echo "procesing..."
    sudo rm -Rf /etc/php*
    sudo yum -y --skip-broken install php56w-common
    sudo yum -y --skip-broken install php56w php56w-mysqlnd php56w-pdo php56w-gd php56w-imap php56w-ldap php56w-xml php56w-intl php56w-soap php56w-mbstring php56w-pear php56w-opcache php56w-mcrypt php56w-pecl-apcu php56w-tidy php56w-cli php56w-bcmath php56w-debuginfo php56w-embedded php56w-xmlrpc php56w-fpm
    break;;
    php56u)
    echo "procesing..."
    sudo rm -Rf /etc/php*
    sudo yum -y --skip-broken install php56u-common
    sudo yum -y --skip-broken install php56u php56u-mysqlnd php56u-pdo php56u-gd php56u-imap php56u-ldap php56u-xml php56u-intl php56u-soap php56u-mbstring php56u-pear php56u-opcache php56u-mcrypt php56u-pecl-apcu php56u-tidy php56u-cli php56u-bcmath php56u-debuginfo php56u-embedded php56u-xmlrpc php56u-fpm-httpd php56u-json
    break;;
    php71w)
    echo "procesing..."
    sudo rm -Rf /etc/php*
    sudo yum -y --skip-broken install php71w-common
    sudo yum -y --skip-broken install php71w php71w-mysqlnd php71w-pdo php71w-gd php71w-imap php71w-ldap php71w-xml php71w-intl php71w-soap php71w-mbstring php71w-pear php71w-opcache php71w-mcrypt php71w-pecl-apcu php71w-tidy php71w-cli php71w-bcmath php71w-debuginfo php71w-embedded php71w-xmlrpc php71w-fpm php71w-process
    break;;
    php71u)
    echo "procesing..."
    sudo rm -Rf /etc/php*
    sudo yum -y --skip-broken install php71u-common
    sudo yum -y --skip-broken install php71u php71u-mysqlnd php71u-pdo php71u-gd php71u-imap php71u-ldap php71u-xml php71u-intl php71u-soap php71u-mbstring php71u-pear php71u-opcache php71u-mcrypt php71u-pecl-apcu php71u-tidy php71u-cli php71u-bcmath php71u-debuginfo php71u-embedded php71u-xmlrpc php71u-fpm-httpd php71u-json php71u-pecl-apcu-bc php71u-pecl-apcu-bc-debuginfo php71u-pecl-apcu-debuginfo php71u-pecl-apcu-panel
    break;;
  esac
done

sudo systemctl stop httpd.service
sudo systemctl start httpd.service

sudo sed -i 's/short_open_tag .*/short_open_tag = "On"/g' '/etc/php.ini'
sudo sed -i 's/output_buffering .*/output_buffering = "On"/g' '/etc/php.ini'
sudo sed -i 's/serialize_precision .*/serialize_precision = -1/g' '/etc/php.ini'
sudo sed -i 's/expose_php .*/expose_php = "Off"/g' '/etc/php.ini'
sudo sed -i 's/max_execution_time .*/max_execution_time = 3600/g' '/etc/php.ini'
sudo sed -i 's/max_input_time .*/max_input_time = 3600/g' '/etc/php.ini'
sudo sed -i 's/; max_input_vars .*/max_input_vars = 10000/g' '/etc/php.ini'
sudo sed -i 's/memory_limit .*/memory_limit = 768M/g' '/etc/php.ini'
sudo sed -i 's/error_reporting .*/error_reporting = 5111/g' '/etc/php.ini'
sudo sed -i 's/display_errors .*/display_errors = "On"/g' '/etc/php.ini'
sudo sed -i 's/display_startup_errors .*/display_startup_errors = "On"/g' '/etc/php.ini'
sudo sed -i 's/log_errors .*/log_errors = "On"/g' '/etc/php.ini'
sudo sed -i 's/log_errors_max_len .*/log_errors_max_len = 0/g' '/etc/php.ini'
sudo sed -i 's/report_memleaks .*/report_memleaks = "On"/g' '/etc/php.ini'
sudo sed -i 's/track_errors .*/track_errors = "On"/g' '/etc/php.ini'
sudo sed -i 's/html_errors .*/html_errors = "On"/g' '/etc/php.ini'
sudo sed -i "s/;error_prepend_string = .*/error_prepend_string = \"<pre style='color:#ff0000'>\"/g" '/etc/php.ini'
sudo sed -i "s/;error_append_string = .*/error_append_string = \"\<\/pre\>\"/g" '/etc/php.ini'
sudo sed -i 's/error_log = syslog/error_log = \"\/var\/log\/php-fpm\/php_error_log.log\"/g' '/etc/php.ini'
sudo sed -i 's/post_max_size .*/post_max_size = 128M/g' '/etc/php.ini'
sudo sed -i 's/always_populate_raw_post_data .*/always_populate_raw_post_data = -1/g' '/etc/php.ini'
sudo sed -i 's/upload_max_filesize .*/upload_max_filesize = 128M/g' '/etc/php.ini'
sudo sed -i 's/default_socket_timeout .*/default_socket_timeout = 600/g' '/etc/php.ini'
sudo sed -i 's/;date.timezone .*/date.timezone = Atlantic\/Canary/g' '/etc/php.ini'
sudo sed -i 's/;date.default_latitude .*/date.default_latitude = 28.4716/g' '/etc/php.ini'
sudo sed -i 's/;date.default_longitude .*/date.default_longitude = -16.2472/g' '/etc/php.ini'
sudo sed -i 's/mysql.connect_timeout .*/mysql.connect_timeout = 600/g' '/etc/php.ini'
sudo sed -i 's/session.cookie_httponly .*/session.cookie_httponly = "On"/g' '/etc/php.ini'
sudo sed -i 's/session.name = .*/session.name = ITOPID/g' '/etc/php.ini'
sudo sed -i 's/session.gc_divisor .*/session.gc_divisor = 500/g' '/etc/php.ini'
sudo sed -i 's/session.gc_maxlifetime .*/session.gc_maxlifetime = 86400/g' '/etc/php.ini'
sudo sed -i 's/mbstring.func_overload .*/mbstring.func_overload = 0/g' '/etc/php.ini'
#sudo sed -i 's/cgi.fix_pathinfo .*/cgi.fix_pathinfo=0/g' '/etc/php.ini'

if [[ $(rpm -qa mod_ssl) != "" ]] || [[ $(rpm -qa httpd24u-mod_ssl) != "" ]];
then
  sudo sed -i 's/session.cookie_secure .*/session.cookie_secure = 1/g' '/etc/php.ini'
fi

echo ""
echo "#########################################################################"
echo "######   Installing browscap"
echo "#########################################################################"

select yn in "Install_Browscap" "No_Install_Browscap";do
  case $yn in
    Install_Browscap)
    echo "procesing..."
    sudo yum -y --skip-broken install wget
    sudo wget https://browscap.org/stream?q=Full_PHP_BrowsCapINI -O full_php_browscap.ini
    sudo mkdir /etc/extra
    sudo rm -Rf /etc/extra/full_php_browscap.ini
    sudo mv -f full_php_browscap.ini /etc/extra
    sudo sed -i 's/;browscap.*/browscap = \/etc\/extra\/full_php_browscap.ini/g' '/etc/php.ini'
    sudo chown apache:apache /etc/extra/full_php_browscap.ini
    break;;
    No_Install_Browscap) break;;
  esac
done

sudo sed -i".bak1" '/;.*/d' /etc/php.ini
sudo sed -i".bak" '/^$/d' /etc/php.ini
sudo sed -i".bak" '/./!d' /etc/php.ini

sudo systemctl stop httpd.service
sudo systemctl start httpd.service

# PEAR
sudo sh include/install_pear.sh
