---
grafana:
  pkg.installed:
    -
      sources:
        -
          grafana: "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.4.1-1.x86_64.rpm"

grafana-server.service:
  service.running:
    -
      enable: true 


mainpackage:
 pkg.installed:
  -
    pkgs:
      - git
      - epel-release
      - httpd
      - mod_wsgi
      - pycairo
      - libffi-devel
      - gcc
      - expect


pythonpackage:
 pkg.installed:
  -
    pkgs:
      - python-pip
      - python-devel

graphite-web:
  git.latest:
    - name: https://github.com/graphite-project/graphite-web.git
    - target: /usr/local/src/graphite-web


carbon:
  git.latest:
    - name: https://github.com/graphite-project/carbon.git
    - target: /usr/local/src/carbon

pip install -r /usr/local/src/graphite-web/requirements.txt:
 cmd.run

carbonscript:
 cmd.run:
    - name: python setup.py install
    - cwd: /usr/local/src/carbon/

graphite-webscript:
 cmd.run:
    - name: python setup.py install
    - cwd: /usr/local/src/graphite-web/
 

/opt/graphite/conf/carbon.conf:
  file.managed:
    - source:
      - salt://carbon.conf
    - user: root
    - group: root
    - mode: '0755'


/opt/graphite/conf/storage-schemas.conf:
  file.managed:
    - source:
      - salt://storage-schemas.conf
    - user: root
    - group: root
    - mode: '0755'


/opt/graphite/conf/storage-aggregation.conf:
  file.managed:
    - source:
      - salt://storage-aggregation.conf
    - user: root
    - group: root
    - mode: '0755'


/opt/graphite/conf/relay-rules.conf:
  file.managed:
    - source:
      - salt://relay-rules.conf
    - user: root
    - group: root
    - mode: '0755'


/opt/graphite/conf/aggregation-rules.conf:
  file.managed:
    - source:
      - salt://aggregation-rules.conf
    - user: root
    - group: root
    - mode: '0755'


/etc/init.d/carbon-aggregator:
  file.managed:
    - source:
      - salt://carbon-aggregator
    - user: root
    - group: root
    - mode: '0755'

/etc/init.d/carbon-cache:
  file.managed:
    - source:
      - salt://carbon-cache
    - user: root
    - group: root
    - mode: '0755'


/etc/init.d/carbon-relay:
  file.managed:
    - source:
      - salt://carbon-relay
    - user: root
    - group: root
    - mode: '0755'


/opt/graphite/webapp/graphite/local_settings.py:
  file.managed:
    - source:
      - salt://local_settings.py
    - user: root
    - group: root
    - mode: '0755'


/etc/httpd/conf.d/graphite.conf:
  file.managed:
    - source:
      - salt://graphite.conf
    - user: root
    - group: root
    - mode: '0755'


/etc/httpd/conf/httpd.conf:
  file.managed:
    - source:
      - salt://httpd.conf
    - user: root
    - group: root
    - mode: '0755'


/root/graphite.exp:
  file.managed:
    - source:
      - salt://graphite.exp
    - user: root
    - group: root
    - mode: '0777'


/opt/graphite/conf/graphite.wsgi:
  file.managed:
    - source:
      - salt://graphite.wsgi
    - user: root
    - group: root
    - mode: '0755'



chmod +x /etc/init.d/carbon-*:
 cmd.run


/var/log/graphite:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0755

setenforce 0:
 cmd.run

httpd.service:
  service.running:
    -
      enable: true


sudo cp /usr/local/src/carbon/distro/redhat/init.d/carbon-* /etc/init.d/:
 cmd.run
service carbon-cache start:
 cmd.run

service carbon-aggregator start:
 cmd.run
sudo chmod +x /etc/init.d/carbon-*:
 cmd.run

systemctl daemon-reload:
 cmd.run


carbon-relay.service:
  service.running:
    -
      enable: true


myscript:
  cmd.run:
    - name: sudo PYTHONPATH=/opt/graphite/webapp/ django-admin.py migrate --run-syncdb --settings=graphite.settings
    - cwd: /opt/graphite


Run myscript:
  cmd.run:
    - name: expect graphite.exp
    - cwd: /root/

sudo chown -R apache:apache /opt/graphite/storage/:
 cmd.run

sudo chown -R apache:apache /opt/graphite/static:
 cmd.run

sudo chown -R apache:apache /opt/graphite/webapp:
 cmd.run

httpd:
  service.running:
    - enable: True
    - reload: True
