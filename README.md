# Simple Private Bitcoin Services

Simple, self-hosted and self-managed containerized Bitcoin services definition.

* tor proxy
* bitcoin node
* joinmarket

## Installation

Make sure both [`docker`](https://www.docker.com/get-started) and [`docker-compose`](https://docs.docker.com/compose/cli-command/#installing-compose-v2) commands are available.
Clone project to local file system with [`git`](https://git-scm.com/).

## Usage

1.   Pull containers' images from docker hub or build with either
`docker-compose pull` or `docker-compose build` respectively.

2.   Start all services with `docker-compose up`

Bitcoin service will create a `joinmarket` wallet upon startup, used by joinmarket to _store addresses as watch-only_ in this wallet.
Joinmarket wallet on the other hand has to be created interactively with the following commmand.

```shell
docker-compose exec joinmarket run wallet-toool.py generate
```

Yield generator can be started with the following command.

```shell
docker-compose exec joinmarket run yg-privacyenhanced.py
```

## Reindex blocks from existing volume.

```shell
docker-compose run bitcoin -reindex
```

### Configuration

Bitcoin and JoinMarket data are persisted to local file system and can be configured with the following environment variables and which may be set in a `.env` file.

* `BITCOIN_BLOCKS_MOUNTPOINT`
* `BITCOIN_DATA_MOUNTPOINT`
* `BITCOIN_WALLET_MOUNTPOINT`
* `JOINMARKET_DATA_MOUNTPOINT`

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
