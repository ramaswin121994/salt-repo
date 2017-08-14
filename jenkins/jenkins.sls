---
mainpackage:
 pkg.installed:
  -
    pkgs:
      - java-1.8.0-openjdk.x86_64

jenkins:
  pkg.installed:
    -
      sources:
        -
          jenkins: "https://pkg.jenkins.io/redhat-stable/jenkins-2.7.4-1.1.noarch.rpm"

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


jenkins.service:
  service.running:
    -
      enable: true
