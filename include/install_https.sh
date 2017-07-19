echo ""
echo "#########################################################################"
echo "######   activate HTTPS?"
echo "#########################################################################"

select yn in "HTTPS" "HTTP";do
  case $yn in
    HTTPS)
    echo "procesing..."
    if [[ ${1} == "httpd" ]];then
      sudo yum -y --skip-broken install mod_ssl
    fi
    if [[ ${1} == "httpd24u" ]];then
      sudo yum -y --skip-broken install httpd24u-mod_security2 httpd24u-mod_ssl
    fi

    sudo sed -i 's/SecRequestBodyLimit 1.*/SecRequestBodyLimit 134217728/g' '/etc/httpd/conf.d/mod_security2.conf'

    #https://mozilla.github.io/server-side-tls/ssl-config-generator/
    sudo sed -i 's/Listen 44.*/Listen 443/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i "s/#ServerName .*/ServerName ${3}/g" '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLEngine .*/SSLEngine on/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLCompression	.*/SSLCompression	off/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLSessionTickets .*/SSLSessionTickets off/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/#SSLHonorCipherOrder .*/SSLHonorCipherOrder on/g' '/etc/httpd/conf.d/ssl.conf'

    sudo sed -i 's/SSLRandomSeed startup file:\/dev\/urandom.*/SSLRandomSeed startup file:\/dev\/urandom 512/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/LogLevel .*/LogLevel crit/g' '/etc/httpd/conf.d/ssl.conf'

    sudo sed -i 's/SSLProtocol .*/SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLProxyProtocol .*/SSLProxyProtocol all -SSLv3 -TLSv1 -TLSv1.1/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLCipherSuite .*/SSLCipherSuite "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA"/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/SSLProxyCipherSuite H.*/SSLProxyCipherSuite "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA"/g' '/etc/httpd/conf.d/ssl.conf'

    sudo sed -i 's/AllowOverride None/AllowOverride all/g' '/etc/httpd/conf.d/ssl.conf'
    sudo sed -i 's/DocumentRoot.*/DocumentRoot "\/var\/www\/html\/public_html"/g' '/etc/httpd/conf.d/ssl.conf'

    sudo sed -i 's/<\/VirtualHost>/#/g' '/etc/httpd/conf.d/ssl.conf'

    sudo echo '   <Directory "/var/www/html/public_html">' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '      RewriteEngine On' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '      Options +FollowSymLinks' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '      RewriteCond %{REQUEST_METHOD} ^(CONNECT|DELETE|HEAD|OPTIONS|PUT|CUSTOM|TRACE|TRACK)' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '      RewriteRule .* - [F]' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '   </Directory>' >> /etc/httpd/conf.d/ssl.conf
    sudo echo '</VirtualHost>' >> /etc/httpd/conf.d/ssl.conf

    sudo echo 'SSLUseStapling on' >> /etc/httpd/conf.d/ssl.conf
    sudo echo 'SSLStaplingResponderTimeout 5' >> /etc/httpd/conf.d/ssl.conf
    sudo echo 'SSLStaplingReturnResponderErrors off' >> /etc/httpd/conf.d/ssl.conf
    sudo echo 'SSLStaplingCache shmcb:/var/run/ocsp(128000)' >> /etc/httpd/conf.d/ssl.conf

    # Changes in '/etc/httpd/conf/httpd.conf'

    sudo sed -i 's/IncludeOptional conf.*/# IncludeOptional/g' '/etc/httpd/conf/httpd.conf'

    sudo echo '#### Rewrite Rules' >> /etc/httpd/conf/httpd.conf
    sudo echo '<VirtualHost _default_:80>' >> /etc/httpd/conf/httpd.conf
    sudo echo '   RewriteEngine On' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Options +FollowSymLinks' >> /etc/httpd/conf/httpd.conf
    sudo echo '   ReWriteCond %{SERVER_PORT} !^443$' >> /etc/httpd/conf/httpd.conf
    sudo echo '   ReWriteRule ^/(.*) https://%{HTTP_HOST}/$1 [NC,R,L]' >> /etc/httpd/conf/httpd.conf
    sudo echo '</VirtualHost>' >> /etc/httpd/conf/httpd.conf

    sudo echo 'IncludeOptional conf.d/*.conf' >> /etc/httpd/conf/httpd.conf

    sudo echo 'AddDefaultCharset utf-8' >> /etc/httpd/conf/httpd.conf
    sudo echo 'ServerSignature Off' >> /etc/httpd/conf/httpd.conf
    sudo echo 'ServerTokens Prod' >> /etc/httpd/conf/httpd.conf
    sudo echo 'FileETag None' >> /etc/httpd/conf/httpd.conf

    sudo echo 'Header edit Set-Cookie ^(.*)$ $1;Secure' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset Access-Control-Allow-Methods' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header always set Access-Control-Allow-Methods "GET, POST"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset Access-Control-Allow-Origin' >> /etc/httpd/conf/httpd.conf
    sudo echo '#Header always set Access-Control-Allow-Origin "https://localhost"' >> /etc/httpd/conf/httpd.conf

    sudo echo 'Header always set Accept-Charset "utf-8, iso-8859-1"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset Strict-Transport-Security' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header always set Strict-Transport-Security "max-age=15768000; includeSubDomains; preload"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset X-Frame-Options' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header set X-Frame-Options "SAMEORIGIN"' >> /etc/httpd/conf/httpd.conf
    #sudo echo 'Header set X-Frame-Options "ALLOW-FROM https://localhost"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset X-Content-Type-Options' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header always set X-Content-Type-Options "nosniff"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset X-XSS-Protection' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header always set X-XSS-Protection "1; mode=block"' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header unset Expect-CT' >> /etc/httpd/conf/httpd.conf
    sudo echo 'Header always set Expect-CT "enforce; max-age=3600"' >> /etc/httpd/conf/httpd.conf

    sudo echo "Header unset Referrer-Policy" >> /etc/httpd/conf/httpd.conf
    sudo echo "Header always set Referrer-Policy \"no-referrer-when-downgrade\"" >> /etc/httpd/conf/httpd.conf
    sudo echo "Header unset Content-Security-Policy" >> /etc/httpd/conf/httpd.conf
    sudo echo "Header always set Content-Security-Policy \"default-src 'self' blob: data: 'unsafe-inline' 'unsafe-eval'\"" >> /etc/httpd/conf/httpd.conf
    #https://www.keycdn.com/support/content-security-policy/

    sudo echo '<Directory "/var/www/html/public_html">' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Options Indexes FollowSymLinks' >> /etc/httpd/conf/httpd.conf
    sudo echo '   AllowOverride all' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Require all granted' >> /etc/httpd/conf/httpd.conf
    sudo echo '   <Limit CONNECT DELETE HEAD OPTIONS PUT CUSTOM TRACK >' >> /etc/httpd/conf/httpd.conf
    sudo echo '       Require all denied' >> /etc/httpd/conf/httpd.conf
    sudo echo '   </Limit>' >> /etc/httpd/conf/httpd.conf
    sudo echo '   <LimitExcept GET POST >' >> /etc/httpd/conf/httpd.conf
    sudo echo '       Require all granted' >> /etc/httpd/conf/httpd.conf
    sudo echo '       LimitRequestBody 134217728' >> /etc/httpd/conf/httpd.conf
    sudo echo '   </LimitExcept>' >> /etc/httpd/conf/httpd.conf
    sudo echo '</Directory>' >> /etc/httpd/conf/httpd.conf

    sudo echo '<Directory "/var/www/html/public_html/api">' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Options -Indexes' >> /etc/httpd/conf/httpd.conf
    sudo echo '   AllowOverride all' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Require all granted' >> /etc/httpd/conf/httpd.conf
    sudo echo '   <Limit CONNECT HEAD OPTIONS CUSTOM TRACK >' >> /etc/httpd/conf/httpd.conf
    sudo echo '       Require all denied' >> /etc/httpd/conf/httpd.conf
    sudo echo '   </Limit>' >> /etc/httpd/conf/httpd.conf
    sudo echo '   <LimitExcept GET POST PUT DELETE>' >> /etc/httpd/conf/httpd.conf
    sudo echo '       Require all granted' >> /etc/httpd/conf/httpd.conf
    sudo echo '       LimitRequestBody 134217728' >> /etc/httpd/conf/httpd.conf
    sudo echo '   </LimitExcept>' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Header unset Access-Control-Allow-Methods' >> /etc/httpd/conf/httpd.conf
    sudo echo '   Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE"' >> /etc/httpd/conf/httpd.conf
    sudo echo '</Directory>' >> /etc/httpd/conf/httpd.conf

    sudo systemctl stop httpd.service
    sudo systemctl start httpd.service

    sudo sh include/install_certbot.sh
    break;;
    HTTP) break;;
  esac
done
