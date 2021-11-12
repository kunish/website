## Self-Hosted Personal Website

This repo is mostly used for experimenting with kubernetes stuff.

### How To Use It

#### Start local development server

```shell
hugo server -D
```

Visit [http://localhost:1313](http://localhost:1313)

```shell
open http://localhost:1313
```

#### Build And Tag Docker Image

```shell
docker build . -t kunish/website
```

#### Push To Docker Registry

```shell
docker push kunish/website
```
