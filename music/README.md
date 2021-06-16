# automation

## Music

### Prerequisites

docker-compose version 1.29.2 or above is required

### Deployment

#### Initial setup configs and pull images

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "target directory path for configs and downloads" "deemix arl if exist"
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

- deemix: http://127.0.0.1:6595
- mstream: http://127.0.0.1:3000
