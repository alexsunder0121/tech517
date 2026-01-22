#!/bin/bash

DB_PRIVATE_IP="172.31.46.67"
export DB_HOST="mongodb://${DB_PRIVATE_IP}:27017/posts"

cd /home/ubuntu/tech517-sparta-app/app

pm2 delete sparta-app || true
pm2 start npm --name sparta-app -- start
pm2 save

systemctl restart nginx