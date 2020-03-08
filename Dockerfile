FROM ruby:2.6

RUN gem install bundler
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]