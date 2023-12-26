# server-shell
Scripts to manage web app servers based on shell, letsencrypt and nginx.

```sh
# test env vars (app hostname must be provided and valid)
APP_HOSTNAME=[app hostname] op run --env-file="./app.env" -- ./server-shell/tests/env.sh

# setup ssl certs
APP_HOSTNAME=[app hostname] op run --env-file="./app.env" -- ./server-shell/scripts/setup_ssl.sh
```
