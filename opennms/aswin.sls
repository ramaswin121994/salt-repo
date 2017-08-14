---
expect:
 pkg.installed

opennms:
  archive.extracted:
    -
      name: /mnt/
    -
      source: https://github.com/opennms-forge/opennms-install/archive/1.1.tar.gz
    -
      skip_verify: True

/mnt/opennms-install-1.1/nithees.exp:
  file.managed:
    - source:
      - salt://nithees.exp
    - mode: '777'


expect nithees.exp:
  cmd.run:
    - source: salt://nithees.exp
    - name: expect nithees.exp

opennms.service:
  service.running:
    -
      enable: true  
