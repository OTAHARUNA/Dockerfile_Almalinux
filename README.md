### powershellで実行するコマンド

```php
// -tをつけるとタグ名付与できる
docker build . -t test_almalinux

// /sbin/initを与えないとsystemed系のコマンドが使えない↓
docker run -v //c/Users/chopp/Docker_Project/test/src:/var/www/src/ -itd -p 80:80 --privileged --name test_almalinux_dockerfile test_almalinux /sbin/init
// docker run -v //c/Users/chopp/Docker_Project/test/:/var/www/src/ -itd -p 80:80 --privileged --name test_almalinux_dockerfile test_almalinux /sbin/init

// Dcoker立ち上げ実行コマンド:今後もずっと接続する時は使用/後者にしたらディレクトリに移動できる
docker exec -it -w /var/www/src/sns_project test_almalinux_dockerfile /bin/bash

//接続したら、タイムゾーンの設定
cp /etc/localtime /etc/localtime.org
ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

// 念のため再起動
systemctl restart php-fpm
systemctl restart nginx
// nginxの自動起動設定
systemctl is-enabled nginx
systemctl enable nginx

// composerインストール
// wget https://getcomposer.org/installer -O composer-installer.php
// php composer-installer.php --filename=composer --install-dir=/usr/local/bin
// composer self-update
cd /var/www/src/sns_project/
composer install
composer --version

chown -R nginx:nginx /var/www/src/sns_project/
chown -R nginx:nginx /var/www/src/sns_project/storage/
chown -R nginx:nginx /var/www/src/sns_project/bootstrap/cache/
chmod -R 0777 /var/www/src/sns_project/storage/
chmod -R 0775 /var/www/src/sns_project/bootstrap/cache/

```

### 注意事項
laravelをクローンしだけでは、ファイルが足りません。
vendorフォルダは上記のcomposer installで取得できましたが、envファイルがない状態です。

envファイルの作成はもとになるファイルはすでにあるのでコピーする
```php
cp .env.example .env
```
ポスグレつなげる設定の為、合わせてここで修正
* envファイル

* \config\database.phpファイル プッシュした為解決のはず。


キー発行と念のためキャッシュクリア（envファイル修正するときは使用）も実行
```php
php artisan key:generate
php artisan config:clear
```

**上記作業を行ったらLaravelの画面は開ける**

```php
// ポスグレ設定 初期化
/usr/bin/postgresql-setup initdb
systemctl enable --now postgresql
systemctl status postgresql

// 管理者ユーザーのパスワード更新
su - postgres
//'password'はご自身の設定されたいものをご入力ください。
psql -c "alter user postgres with password 'password'"
psql -c "alter user postgres with password 'love8672'"

//ポスグレログ出力先作成 rootユーザーでないとできない為、exit。それか入る前に実行。viと合わせて
mkdir /var/log/postgresql
chown postgres:postgres /var/log/postgresql
chmod 750 /var/log/postgresql

//外部接続設定:下記ファイルを修正→コピーコマンド実行予定:初期化をするつもりだからだめだ
vi /var/lib/pgsql/data/postgresql.conf
vi /var/lib/pgsql/data/pg_hba.conf

//ポスグレに接続:今後も使用
su - postgres
createuser --pwprompt --interactive pgadmin

//ポスグレ再起動
systemctl restart postgresql

su - postgres
psql
\l //DB確認できる

// 下記コマンド実行してエラーが発生しせずテーブル作成されていたら接続成功
exit
php artisan migrate
```

CREATE DATABASE sns_project


ln -s /var/www/src/sns_project/public /var/www/src/html/laravel_public
上記のシンボリックリンク作成したらドキュメントルートも変更にする

//xdebug
pecl install xdebug
docker-php-ext-enable xdebug
