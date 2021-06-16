# automation

## Media

### Prerequisites

docker-compose version 1.29.2 or above is required

### Deployment

#### Initial quick setup configs and pull images

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "target directory path for configs and downloads" "plex_token"
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

- sonarr: http://127.0.0.1:8989
- radarr: http://127.0.0.1:7878
- transmission: http://127.0.0.1:9091
- bazarr: http://127.0.0.1:6767
- jackett: http://127.0.0.1:9117
- overseerr: http://127.0.0.1:5055
- plex: http://127.0.0.1:32400/web
- synclounge: http://127.0.0.1:8088


### Include VPN Setup

```bash
sudo chmod +x $PWD/init.sh && $PWD/init.sh "target directory path for configs and downloads"
```

claim plex token from https://plex.tv/claim (it's only valid for 4 minutes), run again the above with the configurations, it will work faster since the images are pulled with the above command!

```bash
$PWD/init.sh "target directory path for configs and downloads" "plex_token" "" "" "true" "NORDVPN" "france" "VpnProviderUsername" "VpnProviderPassword" ""
```

```bash
$PWD/compose-execute.sh
```