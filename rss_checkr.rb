#!/usr/bin/env ruby
#
# = RSS Checkr
# by Mike Green
#
# == Summary
# Checks a specified RSS feed and returns the latest headlines
#
# == Usage
# rss_checkr.rb [-n NUMBER] [-dlh] <feed url>

require 'optparse'
require 'ostruct'
require 'rss'
require 'open-uri'
require 'erb'

config = OpenStruct.new
config.items		= 5
config.details	= false
config.links		= false

opts = OptionParser.new
opts.banner = "Usage: rss_checkr [-n NUMBER] [-dlh] <feed url>"
opts.on('-n', '--n-items NUMBER', 'Specify the number of items to display (default 5)') do |n|
	config.items = n.to_i
end
opts.on('-d', '--details', 'Show details of feed items') do 
	config.details = true
end
opts.on('-l', '--links', 'Show links to full posts on the web') do 
	config.links = true
end
opts.on_tail('-h', '--help', 'Displays usage information and command line options') do
	puts opts
end

opts.parse!(ARGV)