# Wicket new site

This repository contains the site of [Apache Wicket
framework](http://wicket.apache.org).

## Project info

The site is based on [Jekyll](http://jekyllrb.com/). So you have to be
familiar with Markdown template language and have Jekyll (ver. 3+)
installed to contribute to the project.

## Run the project

Just go on project root folder and execute `jekyll serve -w` to generate
the static HTML and start the local server. The project comes with all
the dependencies you need (css, js, pictures, etc.) so you don't need
any preliminary operation before running Jekyll.

If Jekyll is missing any dependency then run `bundle install`.

### Using Docker (thanks Apache Arrow!)

If you don't wish to change or install `ruby` and `nodejs` locally, you can use docker to build and preview the site with a command like:

```shell
cd path/to/wicket-site
docker run -v $PWD:/wicket-site -p 4000:4000 -it ruby bash
cd /wicket-site
apt-get update
apt-get install -y npm
gem install bundler
bundle install
# Serve using local container address
jekyll serve -H 0.0.0.0
```

Then open http://localhost:4000 locally
