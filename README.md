# System.IS - AMS - AHS service

## Setup

### With your own DB server

1. update `ahs` environment values to correct one

```yaml
DB_HOST: db
DB_PORT: 3306
DB_DBNAME: ahs
DB_USER: ahs
DB_PASS: ahsPassword
```

### Run

via `docker-compose`

```shell
$ docker-compose up -d
```

or as a `docker stack` on swarm node/cluster (`$ docker stack init`)

```shell
$ docker stack deploy -c docker-compose.yml systemis-ahs
```
