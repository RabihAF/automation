# automation

## IOT

### Prerequisites

docker-compose version 1.29.2 or above is required

### Deployment

#### Initial quick setup configs and pull images

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "/mnt/sda1/"
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
