FROM ruby:3.3.4
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
RUN gem install bundler:2.5.11
ADD Gemfile* $APP_HOME/
RUN bundle config set without 'development test'
RUN bundle install
ADD . $APP_HOME
