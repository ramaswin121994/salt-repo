---
mainpackage:
 pkg.installed:
  -
    pkgs:
      - httpd
      - mariadb-server
      - net-tools
      - epel-release

httpd.service:
  service.running:
    -
      enable: true

mariadb.service:
  service.running:
    -
      enable: true

echo "CREATE DATABASE testlink_data" | mysql -u root:
 cmd.run

echo "CREATE USER 'testlink_user'@'localhost' IDENTIFIED BY 'StrongPassword'" | mysql -u root:
 cmd.run

echo "GRANT ALL PRIVILEGES ON testlink_data.* TO 'testlink_user'@'localhost'" | mysql -u root:
 cmd.run

echo "FLUSH PRIVILEGES" | mysql -u root:
 cmd.run

webtatic:
  pkg.installed:
    -
      sources:
        -
          webtatic-release: "https://mirror.webtatic.com/yum/el7/webtatic-release.rpm"

otherpackage:
 pkg.installed:
  -
    pkgs:
      - mod_php71w
      - php71w-mysqlnd
      - php71w-common
      - php71w-gd
      - php71w-ldap
      - php71w-cli
      - php71w-mcrypt
      - php71w-xml


cp /etc/php.ini /etc/php.ini.bak && sed -i "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 2880/" /etc/php.ini && sed -i "s/max_execution_time = 30/max_execution_time = 120/" /etc/php.ini:
 cmd.run


httpd:
  service.running:
    - enable: True
    - reload: True

testlink:
  archive.extracted:
    -
      name: /var/www/html
    -
      source: https://github.com/TestLinkOpenSourceTRMS/testlink-code/archive/1.9.16.zip
    -
      skip_verify: True

chown -R apache:apache /var/www/html/testlink-code-1.9.16:
 cmd.run

/var/www/html/testlink-code-1.9.16/custom_config.inc.php:
   file.managed:
    - source:
      - salt://config_db.inc.php

/etc/httpd/conf.d/testlink.conf:
  file.managed:
    - source:
      - salt://testlink.conf

setenforce 0:
 cmd.run      
