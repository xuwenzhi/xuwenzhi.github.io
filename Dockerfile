# Dev/build environment for this Jekyll site.
# Pinned to Ruby 2.7 — the sweet spot for the theme's `jekyll ~> 3.3`.
# (Ruby 3.0+ dropped WEBrick, which breaks `jekyll serve` for old Jekyll.)
FROM ruby:2.7-slim

# Build tools for native gem extensions (ffi, etc.) and git for the gemspec.
RUN apt-get update -qq \
 && apt-get install -y --no-install-recommends build-essential git libffi-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /site

# Install gems first for better layer caching. The full repo is bind-mounted
# at runtime (see docker-compose.yml); gems live in the image at /usr/local/bundle.
COPY Gemfile minimaless.gemspec ./
# 2.4.22 is the newest bundler that supports Ruby 2.7 (and satisfies the
# gemspec's `>= 2.2.33` dev dependency).
RUN gem install bundler -v '2.4.22' \
 && bundle install

EXPOSE 4000 35729

# --force_polling: file-change events don't cross the macOS<->container mount,
# so poll instead to keep livereload working.
CMD ["bundle", "exec", "jekyll", "serve", \
     "--host", "0.0.0.0", "--livereload", "--force_polling"]
