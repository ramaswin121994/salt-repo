---
mainpackage:
 pkg.installed:
  -
    pkgs:
      - unzip
      - wget
      - java-1.8.0-openjdk.x86_64

java_env:
   environ.setenv:
     - name: JAVA_HOME
     - value: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64/
     - update_minion: True

path_env:
   environ.setenv:
     - name: PATH
     - value: $JAVA_HOME/bin:$PATH
     - update_minion: True

source /etc/profile:
 cmd.run

sonarqube:
  archive.extracted:
    - name: /mnt/
    - source: https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.0.zip
    - skip_verify: True


sh /mnt/sonarqube-6.0/bin/linux-x86-64/sonar.sh start start:
 cmd.run