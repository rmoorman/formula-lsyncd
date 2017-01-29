{% set lsyncd = salt['pillar.get']('lsyncd') %}

lsyncd_package:
  pkg.installed:
    - pkgs:
      - lsyncd
      - rsync

lsyncd_config_directory:
  file.directory:
    - name: /etc/lsyncd

'lsyncd_config_/etc/lsyncd/lsyncd.conf.lua':
  file.managed:
    - name: /etc/lsyncd/lsyncd.conf.lua
    - source: salt://lsyncd/files/lsyncd.conf.lua.jinja2
    - template: jinja
    - context:
        config: {{ lsyncd['config'] | yaml }}
    - user: root
    - group: root
    - mode: 0640

lsyncd_service:
  service.running:
    - name: lsyncd
    - watch:
      - file: lsyncd_*
