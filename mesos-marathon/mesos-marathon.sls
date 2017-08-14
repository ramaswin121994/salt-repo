---
mypkgs:
  pkg.installed:
    - sources:
      - mesosphere: http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm


mainpackage:
 pkg.installed:
  -
    pkgs:
      - docker
      - mesosphere-zookeeper
      - mesos
      - marathon
      - chronos

docker.service:
  service.running:
    -
      enable: true

zookeeper.service:
  service.running:
    -
      enable: true

mesos-master.service:
  service.running:
    -
      enable: true

mesos-slave.service:
  service.running:
    -
      enable: true

marathon.service:
  service.running:
    -
      enable: true

chronos.service:
  service.running:
    -
      enable: true
