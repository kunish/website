FROM alpine as builder

WORKDIR /data/app

COPY . .

RUN apk add hugo
RUN hugo -D

FROM caddy:alpine

WORKDIR /srv/app

COPY --from=builder /data/app/public public
COPY . .

EXPOSE 80

CMD ["caddy", "run"]
