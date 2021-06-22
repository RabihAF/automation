# automation

## IOT

### Prerequisites

docker-compose version 1.29.2 or above is required

### Deployment

#### Initial quick setup configs and pull images

Unencrypted MQTT

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "target directory path for configs and downloads" "mqtt_username" "mqtt_password"
```

MQTT over SSL

The certs are to be called:
certfile: server.crt
cafile: ca.crt
keyfile: server.key

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "target directory path for configs and downloads" "mqtt_username" "mqtt_password" true "certs directory path"
```

#### Run

```bash
$PWD/compose-execute.sh
```

#### Helpful Commands

```bash
$PWD/compose-execute.sh OR $PWD/compose-execute.sh "up -d"
$PWD/compose-execute.sh down
$PWD/compose-execute.sh restart
$PWD/compose-execute.sh config
$PWD/compose-execute.sh pull
```

### URL's

- nodered: http://127.0.0.1:1880
- homeassistant: http://127.0.0.1:8123

to create a password file for mqtt (optional, this is already done in the init script):

```bash
USER="user"; \
PASSWORD="password"; \
LOCAL_DIR="."; \
FILE_NAME="passwd"; \
docker run --rm --entrypoint /bin/sh eclipse-mosquitto \
-c "touch '$FILE_NAME' && \
 printf '$PASSWORD\n$PASSWORD\n' | mosquitto_passwd -c '$FILE_NAME' '$USER' > /dev/null && \
 cat '$FILE_NAME'" > ${LOCAL_DIR}/${FILE_NAME}; \
unset USER PASSWORD LOCAL_DIR FILE_NAME; \
history -d $(history 1);
```