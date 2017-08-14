---

/etc/pki/rpm-gpg/RPM-GPG-KEY-GerritForge:
  file.managed:
    - source:
      - https://raw.githubusercontent.com/Zetten/puppet-gerrit/master/files/rpm-gerritforge.key
    - user: root
    - mode: '0777'
    - skip_verify: True


gerrit:
  pkg.installed:
    -
      sources:
        -
          gerritforge-repo-1-1: "https://gerritforge.com/gerritforge-repo-1-1.noarch.rpm"

gerrit:
  pkg.installed
