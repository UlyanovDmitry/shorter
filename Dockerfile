# Use an official ruby runtime as a parent image
FROM ruby:3.3.1

ENV BUNDLER_VERSION=2.5.9
RUN gem install bundler -v 2.5.9

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install

# Adding project files
COPY . ./


ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
