FROM ruby:3.4

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    libvips \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0"]