# automation

## Portainer

### Commands

Replace the password for the admin account and run the below:

```bash
PASSWORD="password"; \
docker run --detach \
   --name portainer \
   --publish 9000:9000 \
   --restart always \
   --volume /var/run/docker.sock:/var/run/docker.sock \
   portainer/portainer-ce \
   --admin-password=$(docker run --rm httpd:2.4-alpine htpasswd -nbB admin "$PASSWORD" | cut -d ":" -f 2); \
   unset PASSWORD
```

### URL
- http://127.0.0.1:9000
