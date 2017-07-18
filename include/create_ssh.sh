echo ""
echo "#########################################################################"
echo "######   Create a SSH to use in GIT?"
echo "#########################################################################"

select yn in "Create_SSH" "No_Create_SSH";do
  case $yn in
    Create_SSH)
    echo "procesing..."
    sudo ssh-keygen -t rsa -b 4096 -C ${1}
    eval "$(ssh-agent -s)"
    if [[ ${1} == "root" ]];then
      ssh-add /root/.ssh/id_rsa
      echo "To use 'id_rsa.pub' file generated in User path: /${1}/.ssh/"
      cat /${1}/.ssh/id_rsa.pub
    else
      ssh-add /home/${1}/.ssh/id_rsa
      echo "To use 'id_rsa.pub' file generated in User path: /home/${1}/.ssh/"
      cat /home/${1}/.ssh/id_rsa.pub
    fi
    # IN 'sudo visudo' ADD: "Defaults  env_keep+=SSH_AUTH_SOCK" if want ssh for all users
    echo ""
    break;;
    No_Create_SSH) break;;
  esac
done
