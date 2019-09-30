FROM ruby:2.6.4

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /usr/src/app

COPY Gemfile* ./

# --deployment puts gems in ./vendor/bundle, --binstubs puts execs in ./bin so don't need to prepend bundle exec to cmds
RUN bundle install
#--deployment 
#--binstubs

COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

#unset this for production
#ENV RAILS_ENV production

#unset this for initial setup
#RUN rails db:create && rails db:migrate && rails db:seed

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]