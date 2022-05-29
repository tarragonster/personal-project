# PHP(WordPress) server demo reverse-proxy Nginx

You will build a wordpress webserver using docker-compose with mysql and phpmyadmin

## Reference

[Nginx docker](https://hub.docker.com/_/nginx) \
[How to check nginx status without systemctl?](https://stackoverflow.com/questions/49081809/how-to-check-nginx-status-without-systemctl) \
[Is it possible to make Nginx listen to different ports?](https://serverfault.com/questions/655067/is-it-possible-to-make-nginx-listen-to-different-ports) \
[How To Install Nginx on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04) \
[Why does Nginx keep redirecting me to localhost?](https://stackoverflow.com/questions/32712443/why-does-nginx-keep-redirecting-me-to-localhost) \
[How to deploy ML models using Flask + Gunicorn + Nginx + Docker](https://medium.com/p/9b32055b3d0) \
[How to mount a single file in a volume](https://stackoverflow.com/questions/42248198/how-to-mount-a-single-file-in-a-volume) \

Error Wordpress

[How to Fix the “Is its parent directory writable by the server?” WordPress Error](https://www.hostinger.com/tutorials/fix-the-is-its-parent-directory-writable-by-the-server-wordpress-error) \
SELECT: How to Fix “Is its parent directory writable by the server?” Error on VPS

[How can I give full permission to folder and subfolder](https://askubuntu.com/questions/719996/how-can-i-give-full-permission-to-folder-and-subfolder) \
FIX: no permission to access folder wp-content

[docker-compose wordpress mysql connection refused](https://stackoverflow.com/questions/34068671/docker-compose-wordpress-mysql-connection-refused) \

## Start stack docker-compose

```
cd webserver/nginx-wordpress-reverse-proxy/
docker-compose up -d
```

## Run Demo

```
http://localhost:8082
```