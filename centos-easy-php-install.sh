# get centos version
version=$(rpm -q --queryformat '%{VERSION}' centos-release)




# While : Do

while :
do
  read -p "Enter php version (example:7.4) : " PHP_VERSION
  
  if [[  $PHP_VERSION =~ ^[7-9]{1}\.[0-9]{1}$ ]]
  then
    break;
  fi
done




sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$version.noarch.rpm
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-$version.rpm
sudo yum -y install yum-utils

if  [[ $version =~ 8 ]]
then
  sudo dnf module reset php
  sudo dnf module install php:remi-$PHP_VERSION -y
else
  sudo yum-config-manager --disable 'remi-php*'
  sudo yum-config-manager --enable remi-php"${PHP_VERSION//./}"
fi
sudo yum -y remove php  php-*
sudo yum -y install php php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json}
