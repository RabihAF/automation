# automation

## Homer

### Commands

Reset any changes and overwrite the localhost ip address

```bash
git reset --hard origin/master; \
git fetch; \
sudo chmod +x $PWD/setIP.sh && \
$PWD/setIP.sh "ip address of the server or leave empty to default to the private IP"
```

```bash
docker run --detach \
   --env "UID=$(id -u)" \
   --env "GID=$(id -g)" \
   --name homer \
   --publish 8080:8080 \
   --restart always \
   --volume $PWD/assets/config.yml:/www/assets/config.yml \
   b4bz/homer
```

### URL
- http://127.0.0.1:8080
