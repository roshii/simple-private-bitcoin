# Simple Private Bitcoin Services

Simple, self-hosted and self-managed containerized Bitcoin services definition.

* tor proxy
* bitcoin node
* joinmarket
* lnd
* lndconnect
* lightning-terminal
* charge-lnd

## Installation

Make sure both [`docker`](https://www.docker.com/get-started) and [`docker compose`](https://docs.docker.com/compose/cli-command/#installing-compose-v2) commands are available.
Clone project to local file system with [`git`](https://git-scm.com/).

## Usage

Start all services with `docker compose up -d` which will pull images from DockerHub; if you rather build images from dockerfiles, run `docker compose build` beforehand. 

### Joinmarkat
Bitcoin service will create a `joinmarket` wallet upon startup, used by joinmarket to _store addresses as watch-only_ in this wallet.
Joinmarket wallet on the other hand has to be created interactively with:
```shell
docker compose exec joinmarket run wallet-tool.py generate
```

Yield generator can then be started with:
```shell
docker compose exec joinmarket run yg-privacyenhanced.py
```

### LND
LND deamon will be started automatically as soon as `bitcoin` service is healthy. Its wallet must either be created or unlocked as follows to further interact with service. See [LND wallet documentation](https://github.com/lightningnetwork/lnd/blob/master/docs/wallet.md) for more information.


Create a new wallet with:
```shell
docker compose run -it --rm lnd lncli create
```

### LNDConnect

[`lndconnect`](https://github.com/roshii/lndconnect) which does n0ot start automatically, will create a tor hidden service automatically with default configuration. An admnin connection QR code will be saved under lnd data directory. 

### Lightning Terminal

[`lit`](https://docs.lightning.engineering/lightning-network-tools/lightning-terminal) service will start automatically and allow you to interact with your lnd node at `https://your-host:8443`

### Charge LND

[`charge-lnd`](https://github.com/accumulator/charge-lnd) service matches your open Lightning channels against a number of customizable criteria and applies channel fees based on the matching policy. `charge-lnd.conf` must be updated with desired fee policy. 

## Reindex blocks from existing volume.

```shell
docker compose run -d bitcoin -reindex
```

### Configuration

Bitcoin and JoinMarket data are persisted to local file system and can be configured with the following environment variables and which may be set in a `.env` file. These data folders must exist before starting services, make sure to create any unexisting one.

* `BITCOIN_BLOCKS_MOUNTPOINT`, defaults to `./.data/bitcoin/.blocks`
* `BITCOIN_DATA_MOUNTPOINT`, defaults to `./.data/bitcoin`
* `JOINMARKET_DATA_MOUNTPOINT`, defaults to `./.data/joinmarket`
* `LND_DATA_MOUNTPOINT`, defaults to `./.data/lnd`

#### Fix file permissions

```shell
docker run --rm -v $(pwd)/.data:/srv alpine chown -R 913:913 /srv 
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
