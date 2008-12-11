#!/usr/bin/env ruby -w

require 'rubygems'
require 'nokogiri'

doc = Nokogiri::XML(File.read("./small.xml"))

(doc/'dict/dict').each do |element|
	args = {}
	puts "element: #{element}"
	(element/'key').each do |e|
		puts "e: #{e}"
		#key = e.downcase.gsub(" ", "_").to_sym
		#value = e.next_inner_text
		#puts "key: #{key}, value: #{value}"
	end
end
