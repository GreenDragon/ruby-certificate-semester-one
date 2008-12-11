require 'rubygems'
require 'hpricot'
require 'open-uri'

artist = ARGV.pop.gsub('&', "and").gsub(' ', '+')
doc = Hpricot(open("http://ws.audioscrobbler.com/1.0/artist/#{artist}/toptags.xml"))

tag = (doc/"tag name").first.inner_html.gsub(/\b\w/){$&.upcase}
puts tag