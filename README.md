Introduction.

You can test and use Ovirt 4 engine running in a Docker container using the files which i make available on the Docker Hub. (ovirt-engine without ovirt-fence-kdump-listener and ovirt-fence-kdump-listener) 
Configuring.

Clone repo:

git clone https://github.com/vyrodovalexey/ovirt-engine4.git
cd ovirt-engine4
In the file answers change DOMAIN and SITE.DOMAIN. For example file answers-example with DOMAIN - example.com and SITE.DOMAIN -portal.example.com)
Create image:

docker build -t ovirt-engine4 .
Run the container

Change SITE.DOMAIN in following line and run. For example: (portal.example.com)
docker run -p 80:80 -p 443:443 -p 6100:6100 -p 54323:54323 -h SITE.DOMAIN -d  ovirt-engine4  
Don't forget to open following ports:
80/tcp
443/tcp 
6100/tcp 
54323/tcp 
Ovirt-engine 4 is now up and running.

https://SITE.DOMAIN
login: admin
password: test
Enjoy!

About author

Profile of the author
