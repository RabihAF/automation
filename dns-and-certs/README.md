# automation

## Duck DNS and Let's Encrypt SSL Certs

### Commands

Replace the password for the admin account and run the below:

#### Duck DNS

Go to the duckdns website, register your subdomain(s) and retrieve your token.
Create a container with your subdomain(s) and token, it will update your IP with the DuckDNS service every 5 minutes

```bash
SUBDOMAINS="subdomain1,subdomain2"; \
TOKEN=""; \
CONFIG_DIR=""; \
mkdir -p ${CONFIG_DIR}; \
docker run --detach \
  --name=duckdns \
  --env "PUID=$(id -u)" \
  --env "PGID=$(id -g)" \
  --env TZ=Europe/London \
  --env "SUBDOMAINS=${SUBDOMAINS}" \
  --env "TOKEN=${TOKEN}" \
  --env LOG_FILE=false \
  --volume "${CONFIG_DIR}:/config" \
  --restart always \
  ghcr.io/linuxserver/duckdns;
```

#### Let's Encrypt Create SSL Certs
Run when needed.

```bash
DOMAINNAME=""; \
EMAIL=""; \
CERTS_DIR=""; \
mkdir -p ${CERTS_DIR}; \
docker run -it --rm \
    --volume "$CERTS_DIR:/etc/letsencrypt" \
    --volume "$CERTS_DIR:/var/lib/letsencrypt" \
    --publish 80:80 \
    certbot/certbot certonly \
    --standalone \
    --domain ${DOMAINNAME} \
    --domain www.${DOMAINNAME} \
    --non-interactive \
    --no-eff-email \
    --agree-tos \
    --email ${EMAIL} \
    --verbose;
```

#### Let's Encrypt Renew SSL Certs

```bash
CERTS_DIR=""; \
docker run -it --name certbot-renew \
    --volume "$CERTS_DIR:/etc/letsencrypt" \
    --volume "$CERTS_DIR:/var/lib/letsencrypt" \
    --publish 80:80 \
    certbot/certbot renew;
```

Create a restart.sh script for the services that needs to be restarted after the certs are renewed.

Configure a crontab to run everyday at 01:00

```bash
crontab -e
```

Add the line below after editing the path for the restart script:
```bash
0 1 * * * docker start certbot-renew && docker logs -n 2 certbot-renew | grep -qw "No renewals were attempted." || <restart script path>/restart.sh
```