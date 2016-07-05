# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'

class SolarParse
	attr_accessor :page
	def initialize url
		html = open(url) do |f|
			f.read
		end
		@page = Nokogiri::HTML.parse(html)
	end
end

doc = SolarParse.new('http://localhost:7777')

summary = []
solars = []
doc.page.xpath("//p | //div[@class='totalTitle' or @class='totalValue' or @class='totalUnit' or @class='totalLabel']").each do |node|
	summary.push(node.text)
end
temp = []
doc.page.xpath("//div[@class='title' or @class='value' or @class='unit' or @class='label']").each do |node|
	temp.push(node.text)
end

while temp.size > 0 do
	solars.push(temp.slice!(0,17))
end

p summary[0,summary.size - 1].join(",")
solars.each do |s|
	p s[0, s.size - 2].join(",")
end
