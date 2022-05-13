```php

powershellで実行するコマンド

// -tをつけるとタグ名
docker build .
docker build . -t test_almalinux

// docker run -v //c/Users/chopp/Docker_Project/test/src/:/var/www/ -itd -p 80:80 --privileged --name test_almalinux_dockerfile test_almalinux /bin/bash
// /sbin/initを与えないといけないらしい↓
docker run -v //c/Users/chopp/Docker_Project/test/src/:/var/www/ -itd -p 80:80 --privileged --name test_almalinux_dockerfile test_almalinux /sbin/init

// Dcoker立ち上げ実行コマンド
docker exec -it test_almalinux_dockerfile /bin/bash

//接続したら
cp /etc/localtime /etc/localtime.org
ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
// dnf update
// dnf install epel-release kernel-devel kernel-headers gcc perl make dkms binutils patch libgomp glibc-headers glibc-devel elfutils-libelf-deve


systemctl restart php-fpm
systemctl restart nginx

systemctl is-enabled nginx
systemctl enable nginx

wget https://getcomposer.org/installer -O composer-installer.php
php composer-installer.php --filename=composer --install-dir=/usr/local/bin
composer self-update
composer install
composer --version

chown -R nginx:nginx /var/www/sns_project/
chown -R nginx:nginx /var/www/sns_project/storage/
chown -R nginx:nginx /var/www/sns_project/bootstrap/cache/
chmod -R 0777 /var/www/sns_project/storage/
chmod -R 0775 /var/www/sns_project/bootstrap/cache/


```
