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
require 'erb'

defaults = {
	:items => 5,
	:details => false,
	:link => false
}

@config = OpenStruct.new(defaults)

opts = OptionParser.new
opts.banner = <<END
RSS Reader Script
by Mike Green

Usage: #{File.basename(__FILE__)} [-n | --number NUM] [-dlh] feed_url
END
opts.on('-n', '--number NUMBER', 'How many headlines to show (5 by default)') do |n|
	@config.items = n.to_i
end
opts.on('-d', '--details', "Display the items' summaries along with their headlines") do
	@config.details = true
end
opts.on('-l', '--link', "Display the item's URL beneath its title") do
	@config.link = true
end
opts.on_tail('-h', '--help', "Display this help message") do
	puts opts
	exit 0
end

opts.parse!(ARGV)
url = ARGV.shift
raw_feed = ""
open(url) {|s| raw_feed = s.read }
@rss = RSS::Parser.parse(raw_feed, false)
@range = 0..(@config.items - 1)
@template = ERB.new(DATA.read)
puts @template.result(binding)

__END__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

	<title><%= @rss.channel.title %></title>
	<style type="text/css">
		body {
			font-family:sans-serif;
			font-size:8px;
			color:#fff;
			text-shadow:1px 1px 1px #000;
		}
		ul {
			padding-left:0;
			list-style:none;
		}
		ol {
			padding-left:0;
		}
	</style>
</head>

<body>
	<h1><%= @rss.channel.title %></h1>
	<ol>
		<% @range.to_a.each do |i| %>
		<li>
			<strong><%= @rss.items[i].date.strftime("%m-%d-%Y") %>:</strong> <%= @rss.items[i].title %>
			<%= "<br/><a href=\"#{@rss.items[i].link}\">#{@rss.items[i].link}</a>" if @config.link %>
		</li>
		<% end %>
	</ol>
</body>
</html>
