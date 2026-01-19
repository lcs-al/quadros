FROM ruby:2.7.6

WORKDIR /app

RUN gem install bundler:2.2.19

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test'
RUN bundle install

COPY . .

ENV RAILS_ENV=production

CMD ["rails", "s"]