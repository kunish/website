FROM alpine as builder

WORKDIR /data/app

COPY . .

RUN apk add hugo
RUN hugo

FROM caddy:alpine

WORKDIR /srv/app

COPY . .
COPY --from=builder /data/app/public public

EXPOSE 80

CMD ["caddy", "run"]
