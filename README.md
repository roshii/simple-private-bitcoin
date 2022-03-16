# Simple Private Bitcoin Services

Simple, self-hosted and self-managed containerized Bitcoin services definition.

## Installation

Make sure both [`docker`](https://www.docker.com/get-started) and [`docker-compose`](https://docs.docker.com/compose/cli-command/#installing-compose-v2) commands are available.
Clone project to local file system with [`git`](https://git-scm.com/).

## Usage

Start bitcoin node behind a tor proxy as follows.

```bash
docker-compose up
```

Reindex blocks from existing volume.

```bash
docker-compose run bitcoin -reindex
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
