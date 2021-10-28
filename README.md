## Self-Hosted Personal Website

This repo is mostly used for experiment with kubernetes stuff.

### How To Use It

Start local development server

```shell
make dev
```

Visit [http://localhost](http://localhost)

```shell
open http://localhost
```

Build And Tag Docker Image

```shell
make build
```

Push To Docker Registry

```shell
docker push kunish/website
```
