{% from "gocd/map.jinja" import gocd with context %}

include:
  - java
  - .repo

go-agent-deps:
  pkg.installed:
    - pkgs:
      - git

go-agent:
  pkg.installed:
    - name: go-agent
    - fromrepo: gocd

  service.running:
    - name: go-agent
    - enable: True
    - require:
      - pkg: go-agent
      - pkg: go-agent-deps
    - watch:
      - file: go-agent-config

go-agent-config:
  file.managed:
    - name: /etc/default/go-agent
    - source: salt://gocd/files/go-config
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        config: {{ gocd.agent.config }}
