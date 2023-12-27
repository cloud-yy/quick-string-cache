FROM ruby:3.2.2
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
EXPOSE 4567

CMD [ "ruby", "app.rb" ]