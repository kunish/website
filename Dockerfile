FROM alpine as builder

WORKDIR /data/app

RUN apk add hugo

COPY . .

RUN hugo

FROM caddy:alpine

WORKDIR /srv/app

EXPOSE 80

COPY Caddyfile .
COPY --from=builder /data/app/public public

CMD ["caddy", "run"]
