"""
Deploy Downloader with fabric

Usage:

$ ln -s contrib/fabfile.py
$ fab -H dl1,dl2 deploy

"""
from json import loads as json

from fabric.operations import put, sudo, local, run
from fabric.decorators import runs_once
from fabric.context_managers import hide

@runs_once
def build():
    local('GOARCH=amd64 GOOS=linux go build -o downloader')

def copy():
    put('downloader', '/usr/local/lib/downloader/bin', use_sudo=True, mode=0755)

def restart():
    sudo('systemctl restart downloader@api.service')
    sudo('systemctl restart downloader@processor.service')
    sudo('systemctl restart downloader@notifier.service')

def status():
    run('systemctl status downloader@*.service')

def stats():
    keys = ['processor', 'notifier']

    with hide('output'):
        stats = [json(run('redis-cli get stats:{}'.format(s))) for s in keys]
        for ss in stats:
            for s, v in json(ss).items():
                print "{:>30} {:>10}".format(s, v)

def deploy():
    build()
    copy()
    restart()
