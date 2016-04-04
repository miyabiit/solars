#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
require 'webrick'
include WEBrick

s = HTTPServer.new(
	:Port => 7777,
	:DocumentRoot => File.join(File.dirname(File.expand_path(__FILE__)), "public_html")
)
trap("INT"){s.shutdown}
s.start
