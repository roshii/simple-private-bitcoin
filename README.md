# Simple Private Bitcoin Services

Simple, self-hosted and self-managed containerized Bitcoin services definition.

* tor proxy
* bitcoin node
* joinmarket

## Installation

Make sure both [`docker`](https://www.docker.com/get-started) and [`docker compose`](https://docs.docker.com/compose/cli-command/#installing-compose-v2) commands are available.
Clone project to local file system with [`git`](https://git-scm.com/).

## Usage

Start all services with `docker compose up -d` which will pull images from DockerHub; if you rather build images from dockerfiles, run `docker compose build` beforehand. 

Bitcoin service will create a `joinmarket` wallet upon startup, used by joinmarket to _store addresses as watch-only_ in this wallet.
Joinmarket wallet on the other hand has to be created interactively with the following commmand.

```shell
docker compose exec joinmarket run wallet-tool.py generate
```

Yield generator can be started with the following command.

```shell
docker compose exec joinmarket run yg-privacyenhanced.py
```

## Reindex blocks from existing volume.

```shell
docker compose run -d bitcoin -reindex
```

### Configuration

Bitcoin and JoinMarket data are persisted to local file system and can be configured with the following environment variables and which may be set in a `.env` file. These data folders must exist before starting services, make sure to create any unexisting one.

* `BITCOIN_BLOCKS_MOUNTPOINT`, defaults to `./.data/bitcoin/.blocks`
* `BITCOIN_DATA_MOUNTPOINT`, defaults to `./.data/bitcoin`
* `JOINMARKET_DATA_MOUNTPOINT`, defaults to `./.data/joinmarket`

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
