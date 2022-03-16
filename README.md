# README
API for the Shramble app.

This is not a gambling app that facilitates the exchange of any real currency, nor should it be used
as such. It's just a for-fun project that allows players to join a room, set odds for whatever they
choose and score / lose **imaginary** points. We do not condone the usage of it for monetary gain
and will not implement any features to support something like that.

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

# Bonus setup notes for first time installers
Some people working on this have had issues at various times during setup, so we'll put notes
here until we add it to a setup script or something.

## RVM & Ruby
Follow steps at [rvm.io](https://rvm.io/)

install our version of ruby
```
rvm install ruby-2.7.0
```
swap to our version with
```
rvm use 2.7.0
```
if that gives you issues, you'll need to swap to a login shell with something like
```
bash --login
```
and then retry.

A potential issue when running `bundle install` produces errors for gem 'pg', which is remedied by:
```
sudo apt-get install libpq-dev
```
then re-running `bundle install`

## Postgres
These steps are meant for first-time setup of your local database if you care not about permissions
and would like to just get started. If you already have an existing installation with proper user
permissions, please create a user for this app and give it the necessary roles to manage the
'shramble' db.

- install postgresql
- login with `sudo -u postgres psql template1` as a first time setup exception
- run the following commands in the psql shell, line by line:
  ```
  CREATE USER <your user> WITH ENCRYPTED PASSWORD '<your password>';
  GRANT ALL PRIVILEGES ON DATABASE shramble TO <your user>;
  ALTER USER <your user> WITH SUPERUSER;
  ```
