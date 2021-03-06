virtualenv-thing:
    virtualenv.managed:
        - name: /opt/deploy/{{ pillar['project_name'] }}_app/
        - system_site_packages: False
        - user: deploy

fetch-repo:
    cmd.run:
        - name: /srv/salt/django-project/django-script.sh
        - user: deploy
        - cwd: /opt/deploy
        - env:
           - BB_USER: {{ pillar['bb_user'] }}
           - BB_PASS: {{ pillar['bb_pass'] }}
           - REPO_SLUG: {{ pillar['repo_slug'] }}
           - KNOWN_HOSTS_URL: {{ pillar['known_hosts_url'] }}

    git.latest:
        - name: git@bitbucket.org:axiacore/{{ pillar['repo_slug'] }}.git
        - target: /opt/deploy/{{ pillar['project_name'] }}_app/{{ pillar ['project_name'] }}
        - rev: master
        - user: deploy
        - identity: /opt/deploy/.ssh/id_rsa

pip-install:
    cmd.run:
        - name: /srv/salt/django-project/django-pip.sh
        - user: deploy
        - cwd: /opt/deploy/{{ pillar['project_name'] }}_app/
        - env:
           - PROJECT_NAME: {{ pillar['project_name'] }}


/opt/deploy/{{ pillar['project_name'] }}_app/{{ pillar ['project_name'] }}/app/local_settings.py:
    file.managed:
        - source: salt://django-project/local_settings.py
        - user: deploy
        - mode: 640
        - group: www-data
        - template: jinja
