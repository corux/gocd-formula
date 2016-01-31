gocd-repo:
  pkgrepo.managed:
    - humanname: Go Continuous Delivery repository
    - baseurl: http://dl.bintray.com/gocd/gocd-rpm
    - gpgcheck: 0
    - gpgkey: http://dl.bintray.com/gocd/gocd-rpm/repodata/repomd.xml.key
    - require:
      - cmd: gocd-repo-key

gocd-repo-key:
  cmd.run:
    - name:  rpm --import http://dl.bintray.com/gocd/gocd-rpm/repodata/repomd.xml.key
    - unless: rpm -qi gpg-pubkey-173454c7
