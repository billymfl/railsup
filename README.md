# railsup
Rails "App". Template for getting started with a Rails 5 app (because Rails 6 is a pain atm)

From https://docs.docker.com/compose/rails/

1. Edit the Dockerfile (note, file is different from what is shown below) and set ruby version and other items

```bash
FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
```

2. edit Gemfile and set rails version (this file will be replaced when you do 'rails new')

```bash
source 'https://rubygems.org'
gem 'rails', '~>5'
```

3. make sure in provided entrypoint.sh file (Rails-specific issue that prevents the server from restarting when a certain server.pid file pre-exists) the app path matches Dockerfile.

```bash
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
```

4. Build it

```bash
docker build -t rails:dev .
```

5. Run dev environment, mounting a volume to store the gems that get installed, and binding to the current working directory. Set any network name, Make sure network and volume exist (use docker network create XXX and docker volume create YYY)

```bash
docker run -it --rm --mount type=bind,src="$(pwd)",dst=/usr/src/app --mount type=volume,src=latest_gems,dst=/usr/local/bundle -p 80:3000 --network rails-app rails:dev bash
```