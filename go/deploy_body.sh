#!/bin/bash

set -x

echo "start deploy ${USER}"
GOOS=linux GOARCH=amd64 go build -o isuumo_linux
for server in isu01; do
  ssh -t $server "sudo systemctl stop isuumo.go.service"
  scp ./isuumo_linux $server:/home/isucon/isuumo/webapp/go/isuumo
  rsync -vau ../mysql/db $server:/home/isucon/isuumo/webapp/mysql/db
  ssh -t $server "sudo systemctl start isuumo.go.service"
done

echo "finish deploy ${USER}"
