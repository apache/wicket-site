# wicket.apache.org

The source of the [Apache Wicket](https://wicket.apache.org) website, built with
[Jekyll](https://jekyllrb.com/). The branch `asf-site` holds the source and, in
`content/`, the built site that the ASF web servers publish.

Run it on your machine with Docker or Podman:

```shell
docker run --rm -it -p 4000:4000 -v "$PWD":/site:z -w /site ruby:3.3 \
  bash -c "bundle install && bundle exec jekyll serve -H 0.0.0.0 -d /tmp/site"
```

and open http://localhost:4000. Build the site for publishing with
`bundle exec jekyll build`, which writes `content/`.

The contributor documentation on the site explains the rest:
https://wicket.apache.org/contribute/, starting with
[Make your first change to the site](https://wicket.apache.org/contribute/site-first-change.html).
