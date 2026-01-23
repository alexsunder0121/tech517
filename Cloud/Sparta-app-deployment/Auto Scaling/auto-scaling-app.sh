#!/bin/bash

if [ -d "/tech517-sparta-app/app" ]; then
  cd /tech517-sparta-app/app
elif [ -d "/home/ubuntu/tech517-sparta-app/app" ]; then
  cd /home/ubuntu/tech517-sparta-app/app
else
  exit 1
fi

pm2 delete sparta-app || true
pm2 start npm --name sparta-app -- start
pm2 save

systemctl restart nginx