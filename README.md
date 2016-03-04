# dockerized glastopf v3


[glastopf](https://github.com/glastopf/glastopf) is a python web application honeypot. 

This repository contains the necessary files to create a *dockerized* version of glastopf v3. 

This dockerized version is part of the **[T-Pot community honeypot](http://dtag-dev-sec.github.io/)** of Deutsche Telekom AG. 

The `Dockerfile` contains the blueprint for the dockerized glastopf and will be used to setup the docker image.  

The `glastopf.cfg` is tailored to fit the T-Pot environment. All important data is stored in `/data/glastopf/`.

The `supervisord.conf` is used to start glastopf under supervision of supervisord. 

Using upstart, copy the `upstart/glastopf.conf` to `/etc/init/glastopf.conf` and start using

    service glastopf start

This will make sure that the docker container is started with the appropriate rights and port mappings. Further, it autostarts during boot.

# Glastopf Dashboard

![Glastopf Dashboard](https://raw.githubusercontent.com/dtag-dev-sec/glastopf/master/doc/dashboard.png)

