# A Marketplace for Private Poll Data

## Getting started

Make sure ganache and truffle are installed globally.

```sh
npm install -g ganache-cli
```
```sh
npm install -g truffle
```

Open a terminal window and start up the local private blockchain using ganache-cli.

```sh
ganache-cli --account='0x60cd6638b6578d0bced19e5d8673da8d3a148136e914ea442b1cc9fd0970a2, 10000000000000000000000000' '0xd8e70f46bcdd6c0437779bad4b927cb9160490620e7c69d9c26dbf7ddbf69701, 10000000000000000000000000'
```

Open a new terminal tab, navigate to the root directory, and run:

```sh
npm install
```

After all the node packages are installed, enter the following commands to build, migrate, and test the truffle project.

```sh
truffle build
```
```sh
truffle migrate --reset
```
```sh
truffle test
```