FROM centos:7
ENV container=docker

#update
RUN yum update -y

#install repos
RUN rpm -ivh http://mirror.yandex.ru/epel/7/x86_64/e/epel-release-7-8.noarch.rpm http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm


#install packages
RUN yum install  httpd  postgresql postgresql-server sudo ovirt-engine -y; yum clean all

#install db
RUN sudo -u postgres /usr/bin/initdb /var/lib/pgsql/data/

#change postgres parameters
RUN  sed -i "s/lc_messages = '.'/lc_messages = 'en_US.UTF-8'/g" /var/lib/pgsql/data/postgresql.conf \
     && sed -i 's/max_connections = .../max_connections = 200/g' /var/lib/pgsql/data/postgresql.conf

#copy answers file for ovirt-engine setup to container
COPY answers /tmp/answers 


#start postgres, create users and DBs and setup engine
RUN sudo -u postgres  /usr/bin/pg_ctl -D /var/lib/pgsql/data -l /var/lib/pgsql/logfile  start \
    &&  sleep 5 \
    && sudo -u postgres psql -c "create role ovirt_engine_history with login encrypted password 'ovirt_engine_history'" \
    && sudo -u postgres psql -c "create database ovirt_engine_history owner ovirt_engine_history template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8'" \
    && sudo -u postgres psql -c "create role engine with login encrypted password 'engine'" \
    && sudo -u postgres psql -c "create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8'" \
    && engine-setup --config-append=/tmp/answers


#mount volumes
VOLUME  ["/var/lib/ovirt-engine", "/var/log/httpd", "/var/log/ovirt-engine", "/var/log/ovirt-engine-dwh", "/var/log/ovirt-imageio-proxy", "/var/lib/pgsql" ]


#startup for ovirt engine services and httpd
COPY rc.start /usr/local/bin/rc.start 

#chmod rc.start
RUN chmod 777 /usr/local/bin/rc.start

# Expose required container ports
EXPOSE 80 443 6100 54323 

# Start services
CMD ["rc.start"]
