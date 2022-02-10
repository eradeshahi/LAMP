# get centos version
version=$(rpm -q --queryformat '%{VERSION}' centos-release)

while :
do
  read -p "Enter php version (example:7.4) : " PHP_VERSION
  
  if [[  $PHP_VERSION =~ ^[7-9]{1}\.[0-9]{1}$ ]]
  then
    break;
  fi
done


CURRENTPHP=$(php -r "echo substr(phpversion(),0,3);")

if [[  $CURRENTPHP =~ $PHP_VERSION ]]
then
  echo "php $PHP_VERSION already installed."
  exit
fi



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

## install composer
composer -v > /dev/null 2>&1
COMPOSER=$?
if [[ $COMPOSER -ne 0 ]]; then
    sudo yum -y install wget unzip

  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  php -r "unlink('composer-setup.php');"

  
fi
