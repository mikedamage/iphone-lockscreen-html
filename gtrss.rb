#!/usr/bin/env ruby
#
# = Geektool RSS Script
# 
# AUTHOR:: Mike Green
# EMAIL:: mike.is.green@gmail.com
# URL:: http://mikedamage.github.com
# LICENSE:: GNU GPL
#
# == Summary
# Opens the specified RSS feed and displays the latest headlines (5 by default).
# For use with GeekTool on OS X, Samurize on Windoze, or Conky on Linux to display
# news feeds on the desktop.

require 'optparse'
require 'ostruct'
require 'open-uri'
require 'rss/1.0'
require 'rss/2.0'

defaults = {
	:items => 5,
	:details => false,
	:link => false,
	:html => false
}

config = OpenStruct.new(defaults)

opts = OptionParser.new
opts.on('-n', '--number NUMBER', 'How many headlines to show (5 by default)') do |n|
	config.items = n.to_i
end
opts.on('-d', '--details', "Display the items' summaries along with their headlines") do
	config.details = true
end
opts.on('-l', '--link', "Display the item's URL beneath its title") do
	config.link = true
end
opts.on('-x', '--xhtml', "Renders the headlines as an XHTML ordered list") do
	config.html = true
end
opts.on_tail('-h', '--help', "Display this help message") do
	puts opts
	exit 0
end

opts.parse!(ARGV)
url = ARGV.shift
raw_feed = ""
open(url) {|s| raw_feed = s.read }
rss = RSS::Parser.parse(raw_feed, false)
title_underline = ""
i = 0
while i <= (rss.channel.title.size + 3) do
	title_underline += "="
	i += 1
end

if config.html
	puts "<html>"
	puts "<head>"
	puts "<style type=\"text/css\">"
	puts "body {color:#fff;font-family:sans-serif;}"
	puts "ul {padding-left:none;}"
	puts "</style>\n</head>\n<body>"
	puts "<h2>#{rss.channel.title}</h1>"
	puts "<ol>\n"
else
	puts rss.channel.title + "\n" + title_underline + "\n"
end

i = 0

config.items.to_i.times do
	if config.html
		puts "<li><strong>#{rss.items[i].date.strftime("%m-%d-%Y")}:</strong> #{rss.items[i].title}"
		puts "<ul>" if config.link or config.details
		puts "<li><a href=\"#{rss.items[i].link}\">#{rss.items[i].link}</a></li>" if config.link
		puts "<li>#{rss.items[i].description}</li>" if config.details
		puts "</ul>" if config.link or config.details
		puts "</li>"
	else
		puts rss.items[i].date.strftime("%m-%d-%Y: ") + " " + rss.items[i].title
		puts rss.items[i].link if config.link
		puts rss.items[i].description if config.details
	end
	puts "\n"
	i += 1
end

puts "</ol>\n</body>\n</html>" if config.html