# almalinuxのイメージを利用する
ARG SYSBASE=almalinux/8-base
FROM ${SYSBASE} as system-build


# ここだと失敗した為下に移動
# RUN dnf install -y epel-release kernel-devel kernel-headers gcc perl make dkms binutils patch libgomp glibc-headers glibc-devel vim less

# nginxのインストール
RUN dnf -y install nginx
# 設定ファイルのコピー
COPY ./docker_conf/nginx.conf /etc/nginx/nginx.conf

# phpのインストール
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf module enable php:remi-8.1 -y
RUN dnf install -y php php-cli

RUN dnf install -y php-cli php-fpm php-curl php-mysqlnd php-gd php-opcache php-zip php-intl php-common php-bcmath php-imap php-imagick php-xmlrpc php-json php-readline php-memcached php-redis php-mbstring php-apcu php-xml php-pdo_pgsql php-pear php-devel

RUN dnf install -y epel-release kernel-devel kernel-headers gcc perl make dkms binutils patch libgomp glibc-headers glibc-devel vim less

#php-fpmのuser groupとかの変更している
COPY ./docker_conf/www.conf /etc/php-fpm.d/www.conf

# composerインストール
RUN dnf -y install wget
RUN wget https://getcomposer.org/installer -O composer-installer.php
RUN php composer-installer.php --filename=composer --install-dir=/usr/local/bin
# マウントはまだできていない状況？の為ファイルがないと出てしまう。
# WORKDIR /var/www/sns_project/
# RUN composer install
# RUN composer --version

COPY ./src/sns_project/.env.example ./src/sns_project/.env

# ポスグレインストール
RUN dnf -y update
RUN dnf module enable postgresql:13 -y
RUN dnf install -y postgresql postgresql-server

# 2. Install Xdebug. 下記だけなら成功するが設定しないといけない項目不明の為手動
# RUN pecl install Xdebug
# 下記だと失敗
# RUN pecl install xdebug \
#     && docker-php-ext-enable xdebug
