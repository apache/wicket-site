# A quick and dirty plugin for Jekyll by Eli Naeher
#
# This plugin creates a site.years template variable which allow you to
# group archive links by year and month.
#
# The structure of site.years is:
# site.years = 2001=>[[post1, post2...], [...]], 2002=>[...]
#
# Usage should look something like this:
# {% for year in site.years %}
#   <h2>Year {{ year.first.first.date | date: "%Y" }}</h2>
#   {% for month in year %}
#     <h3>Month {{ month.first.date | date: "%B" }}</h3>
#     {% for post in month %}
#       <a href="{{ post.url">{{ post.title }}</a>
#     {% endfor %}
#   {% endfor %}
# {% endfor %}

class Jekyll::Site
  alias :site_payload_without_tiered_archives :site_payload

  def site_payload
	if Jekyll::VERSION < '3.0.0'
      posts = self.posts
    else
      posts = self.posts.docs
    end
    data = site_payload_without_tiered_archives
    data['site']['years'] = TieredArchives::find_years(posts.reverse)
    data
  end
end

module TieredArchives
  def self.find_years(posts)
    posts.group_by {|post| post.date.year}.values.map {|year| year.group_by {|post| post.date.month}.values};
  end
end
