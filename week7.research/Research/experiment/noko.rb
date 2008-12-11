#!/usr/bin/ruby -w

require 'rubygems'
require 'nokogiri'

doc = Nokogiri::XML(File.read("./tiny.xml")

(doc/'dict/dict').each do |element|
	args = {}
	(element/'key').each do |e|
		key = e.to_sym
		value = e.next
		puts "key: #{key}, value: #{value}"
	end
end
