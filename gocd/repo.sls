gocd-repo-remove-old:
  pkgrepo.absent:
    - name: gocd-repo
    - require_in:
      - pkgrepo: gocd-repo

gocd-repo:
  pkgrepo.managed:
    - name: gocd
    - humanname: GoCD YUM Repository
    - baseurl: https://download.go.cd
    - gpgcheck: 1
    - gpgkey: https://download.go.cd/GOCD-GPG-KEY.asc
    - require:
      - cmd: gocd-repo-key

gocd-repo-key:
  cmd.run:
    - name:  rpm --import https://download.go.cd/GOCD-GPG-KEY.asc
    - unless: rpm -qi gpg-pubkey-8816c449
