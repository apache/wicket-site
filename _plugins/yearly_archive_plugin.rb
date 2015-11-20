# Jekyll Module to create monthly archive pages
#
# Shigeya Suzuki, November 2013
# Copyright notice (MIT License) attached at the end of this file
#

#
# This code is based on the following works:
#   https://gist.github.com/ilkka/707909
#   https://gist.github.com/ilkka/707020
#   https://gist.github.com/nlindley/6409459
#

#
# Archive will be written as #{archive_path}/#{year}/#{month}/index.html
# archive_path can be configured in 'path' key in 'monthly_archive' of
# site configuration file. 'path' is default null.
#

module Jekyll

  module YearlyArchiveUtil
    def self.archive_base(site)
      site.config['yearly_archive'] && site.config['yearly_archive']['path'] || ''
    end
  end

  # Generator class invoked from Jekyll
  class YearlyArchiveGenerator < Generator
    def generate(site)
      posts_group_by_year(site).each do |ym, list|
        site.pages << YearlyArchivePage.new(site, YearlyArchiveUtil.archive_base(site),
                                             ym[0], ym[1], list)
      end
    end

    def posts_group_by_year(site)
      if Jekyll::VERSION < '3.0.0'
        posts = site.posts
      else
        posts = site.posts.docs
      end
      posts.each.group_by { |post| [post.date.year] }
    end

  end

  # Actual page instances
  class YearlyArchivePage < Page

    ATTRIBUTES_FOR_LIQUID = %w[
      year,
      month,
      date,
      content
    ]

    def initialize(site, dir, year, month, posts)
      @site = site
      @dir = dir
      @year = year
      @month = month
      @archive_dir_name = 'news/%04d' % [year]
      @date = Date.new(@year)
      @layout =  site.config['yearly_archive'] && site.config['yearly_archive']['layout'] || 'default'
      @months = posts.map{|p| Date.new(@year, p.date.month, 1) }.uniq
      self.ext = '.html'
      self.basename = 'index'
      self.content = <<-EOS
      {% for year in site.years %}
      {% assign y = {year.first.first.date | date: '%Y'} %}
      {% if y == '#{year}' %}
      <div class="l-first">
          {% for month in year %}
              {% assign m = {month.first.date | date: '%m'} %}
              <div  class="l-full">
                  <h1>All News for {{ month.first.date | date: "%B %Y" }}</h1>
                  <p>This section contains all news items published in <a href="{{site.baseurl}}/news/{{y}}/{{m}}">{{ month.first.date | date: "%B %Y" }}</a>.</p>
              </div>
              {% for post in month %}
                  <div class="l-full">
              		<h3 id="{{ site.baseurl }}{{post.url}}">{{post.title}}</h3>
                      <small>{{post.date | date_to_string}}</small>
              		<p>{{ post.content | markdownify | strip_html | truncatewords:25 }}
              		<a href="{{ site.baseurl }}{{post.url}}">more</a></li></p>
                  </div>
              {% endfor %}
              <hr>
              <div class="l-first"></div>
          {% endfor %}
      </div>
      {% endif %}
      {% endfor %}


      EOS
      self.data = {
          'layout' => @layout,
          'type' => 'archive',
          'title' => "Yearly archive for #{@year}",
          'months' => @months,
          'posts' => posts,
          'url' => File.join('/',
                     YearlyArchiveUtil.archive_base(site),
                     @archive_dir_name, 'index.html')
      }
    end

    def render(layouts, site_payload)
      payload = {
          'page' => self.to_liquid,
          'paginator' => pager.to_liquid
      }.merge(site_payload)
      do_layout(payload, layouts)
    end

    def to_liquid(attr = nil)
      self.data.merge({
                               'content' => self.content,
                               'date' => @date,
                               'month' => @month,
                               'year' => @year
                           })
    end

    def destination(dest)
      File.join('/', dest, @dir, @archive_dir_name, 'index.html')
    end

  end
end

# The MIT License (MIT)
#
# Copyright (c) 2013 Shigeya Suzuki
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.