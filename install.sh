#!/bin/bash

read -p "Enter domain name (e.g., example.com): " DOMAIN
read -p "Enter MySQL host: " DB_ENDPOINT
read -p "Enter MySQL username: " DB_USER
read -s -p "Enter MySQL password: " DB_PASS
echo

INSTALL_DIR="$(pwd)"
DB_NAME=${DOMAIN//[.]/_}_cmsms
SQL_SCRIPT="$INSTALL_DIR/cmsms_2.2.19.sql"

wget -q -P "$INSTALL_DIR" https://cmsms-downloads.s3.eu-south-1.amazonaws.com/2.2.19/cmsms_2.2.19.sql || exit 1

mysql -h $DB_ENDPOINT -u $DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;" &&
mysql -h $DB_ENDPOINT -u $DB_USER -p$DB_PASS $DB_NAME < $SQL_SCRIPT || {
    mysql -h $DB_ENDPOINT -u $DB_USER -p$DB_PASS -e "DROP DATABASE $DB_NAME;"
    sudo rm -rf "$INSTALL_DIR"
    exit 1
}

cat <<EOF >$INSTALL_DIR/config.php
<?php
\$config['dbms'] = 'mysqli';
\$config['db_hostname'] = '$DB_ENDPOINT';
\$config['db_username'] = '$DB_USER';
\$config['db_password'] = '$DB_PASS';
\$config['db_name'] = '$DB_NAME';
\$config['db_prefix'] = 'cms_';
\$config['root_url'] = 'https://$DOMAIN';
\$config['root_path'] = '$INSTALL_DIR';
\$config['admin_dir'] = 'admin';
\$config['timezone'] = 'UTC';
\$config['url_rewriting'] = 'mod_rewrite';
\$config['page_extension'] = '/';
\$config['permissive_smarty'] = true;
?>
EOF

cp "$INSTALL_DIR/doc/htaccess.txt" "$INSTALL_DIR/.htaccess" || exit 1

mkdir -p $INSTALL_DIR/tmp/cache $INSTALL_DIR/tmp/templates_c

sudo chmod -R g+w $INSTALL_DIR
sudo chmod g+s $INSTALL_DIR
sudo chmod 777 $INSTALL_DIR/tmp/cache $INSTALL_DIR/tmp/templates_c
sudo rm $SQL_SCRIPT
