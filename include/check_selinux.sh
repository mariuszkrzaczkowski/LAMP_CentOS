echo ""
echo "#########################################################################"
echo "######   Checking SElinux"
echo "#########################################################################"
echo "procesing..."

if [[ -z "$(sestatus | grep disabled)" ]];then
  sudo setsebool -P httpd_can_network_connect 1
  sudo setsebool -P httpd_can_network_connect_db 1
  sudo setsebool -P httpd_unified 1
  sudo setsebool -P polyinstantiation_enabled 1
  sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' '/etc/selinux/config'
  sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' '/etc/selinux/config'
  sudo setenforce 0

  echo ""
  echo "#########################################################################"
  echo "######   Restart Now? [recommended: Yes]"
  echo "######   NOTE: Once restarted, start the script again"
  echo "#########################################################################"

  select yn in "Restart_Now" "No_Restart";do
    case $yn in
      Restart_Now)
      sudo reboot
      break;;
      No_Restart) break;;
    esac
  done
else
  echo ""
  echo "#########################################################################"
  echo "######   SElinux Status"
  sudo cat '/etc/selinux/config' | grep '^SELINUX='
  echo "#########################################################################"
fi
