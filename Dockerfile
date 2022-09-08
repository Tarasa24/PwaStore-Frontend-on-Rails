FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
VOLUME /myapp/config/master.key

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

ENV PG_DB=""
ENV PG_USERNAME=""
ENV PG_PASSWORD=""
ENV PG_HOSTNAME=""
ENV PG_PORT=5432
ENV PG_SCHEMA="public"

COPY . /myapp