echo ""
echo "#########################################################################"
echo "######   Create a new user?"
echo "#########################################################################"

NewUser="${1}"

select yn in "Create_User" "No_Create_Create";do
  case $yn in
    Create_User)
    echo "Enter the name of the new user: "
    echo "NO spaces"
    echo "NO special characters"
    echo "NO Capital letters"
    read NewUser
    echo "procesing..."
    sudo adduser $NewUser
    sudo passwd $NewUser
    break;;
    No_Create_Create) break;;
  esac
done

sudo sh include/create_ssh.sh $NewUser
