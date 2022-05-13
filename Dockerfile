# almalinuxのイメージを利用する
# ARG SYSBASE=almalinux/8-base
# FROM ${SYSBASE} as system-build
FROM almalinux/almalinux

# COPY /etc/localtime /etc/localtime.org

# RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN dnf -y update
# RUN dnf -y install epel-release kernel-devel kernel-headers gcc perl make dkms binutils patch libgomp glibc-headers glibc-devel elfutils-libelf-deve


# nginxのインストール
RUN dnf -y install nginx
# システム自動起動設定コマンド
# RUN systemctl is-enabled nginx
# RUN systemctl enable nginx

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf module enable php:remi-8.0 -y
RUN dnf install -y php php-cli
RUN dnf install -y php-cli php-fpm php-curl php-mysqlnd php-gd php-opcache php-zip php-intl php-common php-bcmath php-imap php-imagick php-xmlrpc php-json php-readline php-memcached php-redis php-mbstring php-apcu php-xml

COPY ./nginx.conf /etc/nginx/nginx.conf

#php-fpmのuser groupとかの変更
COPY ./www.conf /etc/php-fpm.d/www.conf

RUN dnf -y install wget

# 下記は自分で
# RUN composer create-project "laravel/laravel=9.0.*" test_project

# RUN chown -R nginx:nginx /var/www/html/test_project/
# RUN chown -R nginx:nginx /var/www/html/test_project/storage/
# RUN chown -R nginx:nginx /var/www/html/test_project/bootstrap/cache/
# RUN chmod -R 0777 /var/www/html/test_project/storage/
# RUN chmod -R 0775 /var/www/html/test_project/bootstrap/cache/

# WORKDIR /test_projexct
RUN dnf -y update
# RUN dnf module list postgresql
RUN dnf module enable postgresql:13 -y
RUN dnf install -y postgresql postgresql-server
# RUN /usr/bin/postgresql-setup initdb
# RUN systemctl enable --now postgresql
# RUN systemctl status postgresql
