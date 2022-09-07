# Simple Private Bitcoin Services

Simple, self-hosted and self-managed containerized Bitcoin services definition.

* tor proxy
* bitcoin node
* joinmarket

## Installation

Make sure both [`docker`](https://www.docker.com/get-started) and [`docker-compose`](https://docs.docker.com/compose/cli-command/#installing-compose-v2) commands are available.
Clone project to local file system with [`git`](https://git-scm.com/).

## Usage

Start all services with a single command as follows.

```sh
docker-compose up
```

Bitcoin service will create a `joinmarket` wallet upon startup, used by joinmarket to _store addresses as watch-only_ in this wallet.
Joinmarket wallet on the other hand has to be created interactively with the following commmand.

```sh
docker-compose exec joinmarket run wallet-toool.py generate
```

Yield generator can be started with the following command.

```sh
docker-compose exec joinmarket run yg-privacyenhanced.py generate
```

## Reindex blocks from existing volume.

```sh
docker-compose run -d --rm --name bitcoin bitcoin bitcoin-node -reindex
```

### Configuration

Bitcoin data are persisted to local file system and can be configured with the following environment variables and which may be set in a `.env` file.

* `BITCOIN_BLOCKS_MOUNTPOINT`
* `BITCOIN_DATA_MOUNTPOINT`
* `BITCOIN_WALLET_MOUNTPOIN`

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
