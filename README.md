# server-shell
Scripts to manage web app servers based on shell, letsencrypt and nginx.

```sh
# test env vars (app hostname must be provided and valid)
ssh [credentials] 'bash -lc "cd server-shell && APP_HOSTNAME=[app hostname] op run --env-file=../app.env -- ./tests/env.sh"'

# setup ssl certs
ssh [credentials] 'bash -lc "cd server-shell && APP_HOSTNAME=[app hostname] op run --env-file=../app.env -- ./scripts/setup_ssl.sh"'
```
