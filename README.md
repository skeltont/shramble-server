# README
API for the Shramble app.

# Setup
## .env

Postgres creds
```
PSQL_HOST=...
PSQL_USER=...
PSQL_PASS=...
PSQL_PORT=...
```

## dependencies
```
bundle install
```

## db
```
bin/rails db:setup
```

## TODO:
_remove this once we've pulled them into issues_
- handle error message rendering to client
- figure out server secret key management
- figure out server db secrets
- add support for passing on a round
- better support for joining mid-round
- style the app better
- user feedback when selecting bets
- handle starting a new match
- consolidate request code in the front-end