# System.IS - AMS - AHS service

## Setup

### Passwords 

Change passwords based on your best practise. Find & replace:

1. `rootPassword`
2. `ahsPassword`

### With your own DB server

1. update `ahs` environment values to correct one

```yaml
DB_HOST: db
DB_PORT: 3306
DB_DBNAME: ahs
DB_USER: ahs
DB_PASS: ahsPassword
```

2. respect mysql setup

- `/mysql/amsdb.cnf`
- `/mysql/init.sql`

### Run

via `docker-compose`

```shell
$ docker-compose up -d
```

or as a `docker stack` on swarm node/cluster (`$ docker stack init`)

```shell
$ docker stack deploy -c docker-compose.yml systemis-ahs
```
