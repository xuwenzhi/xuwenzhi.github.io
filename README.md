# blog
think and write.

## Local development

Uses Docker so you don't need Ruby/Jekyll installed locally (the site is pinned
to the old `jekyll ~> 3.3`, which is painful to build on modern Ruby).

```sh
docker compose up        # serve at http://localhost:4000 with livereload
docker compose build     # rebuild the image after changing the Gemfile
```

One-off commands:

```sh
docker compose run --rm jekyll bundle exec jekyll build   # build into _site/
docker compose run --rm jekyll bundle update              # refresh Gemfile.lock
```
