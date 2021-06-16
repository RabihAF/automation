# automation

## Homer

### Commands

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
