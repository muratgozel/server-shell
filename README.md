# server-shell
Scripts to manage web app servers based on shell, letsencrypt, nginx and 1password.

```sh
# test env vars (app hostname must be provided and valid)
ssh [credentials] 'bash -lc "cd server-shell && APP_HOSTNAME=[app hostname] op run --env-file=../app.env -- ./tests/env.sh"'

# setup ssl certs
ssh [credentials] 'bash -lc "cd server-shell && APP_HOSTNAME=[app hostname] op run --env-file=../app.env -- ./scripts/setup_ssl.sh"'

# setup nginx conf
ssh [credentials] 'bash -lc "cd server-shell && APP_HOSTNAME=[app hostname] op run --env-file=../app.env -- ./scripts/setup_app_server.sh"'
```
