{% from "gocd/map.jinja" import gocd with context %}

include:
  - java
  - .repo

go-server:
  pkg.installed:
    - name: go-server
    - fromrepo: gocd-repo

  service.running:
    - name: go-server
    - enable: True
    - watch:
      - file: go-server-config

go-server-config:
  file.managed:
    - name: /etc/default/go-server
    - source: salt://gocd/files/go-config
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - defaults:
        config: {{ gocd.server.config }}

go-server-plugins-external:
  file.directory:
    - name: {{ gocd.server.config.SERVER_WORK_DIR }}/plugins/external
    - makedirs: True
    - user: {{ gocd.server.user }}
    - group: {{ gocd.server.group }}
    - watch_in:
      - service: go-server

go-server-plugins-external-clean:
  file.directory:
    - name: {{ gocd.server.config.SERVER_WORK_DIR }}/plugins/external
    - clean: True
    - watch_in:
      - service: go-server

{% for jar, url in gocd.server.plugins.items() %}
{% set destination = gocd.server.config.SERVER_WORK_DIR + '/plugins/external/' + jar + '.jar' %}
{{ destination }}:
  cmd.run:
    - name: 'curl -L --silent "{{ url }}" > "{{ destination }}"'
    - unless: 'test -f "{{ destination }}"'
    - require:
      - file: go-server-plugins-external
    - prereq:
      - file: {{ destination }}

  file.managed:
    - name: {{ destination }}
    - user: {{ gocd.server.user }}
    - group: {{ gocd.server.group }}
    - mode: 644
    - watch_in:
      - service: go-server
    - require_in:
      - file: go-server-plugins-external-clean
{% endfor %}
