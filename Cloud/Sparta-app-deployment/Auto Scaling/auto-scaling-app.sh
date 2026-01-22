#!/bin/bash

cd /tech517-sparta-app/app

pm2 delete sparta-app || true
pm2 start npm --name sparta-app -- start
pm2 save