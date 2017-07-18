echo ""
echo "#########################################################################"
echo "######   Delete LAMP_CentOS files?"
echo "#########################################################################"

select yn in "Delete" "No_Delete";do
  case $yn in
    Delete)
    echo "Deleting... "
    if [[ ${1} == "root" ]];then
      sudo rm -Rf /root/LAMP_CentOS/
      echo "Deleted in: '/root/LAMP_CentOS/'"
    else
      sudo rm -Rf /home/${1}/LAMP_CentOS/
      echo "Deleted in: '/home/${1}/LAMP_CentOS/'"
    fi
    break;;
    No_Delete) break;;
  esac
done
