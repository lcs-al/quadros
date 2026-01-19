FROM ruby:2.7.6

WORKDIR /app
RUN gem install bundler:2.2.19

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local without 'development test'
RUN bundle install

ADD .env.production /app/.env.production
ADD . /app

ENV RAILS_ENV=production

CMD ["rails", "s"]