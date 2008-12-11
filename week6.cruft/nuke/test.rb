#!/usr/bin/env ruby -w

my_file = 'source.txt'

f = File.open(my_file, 'r')

#file_data = f.read if f.read.match("search")

f.map { |line| print line if line =~ /search/ }
f.close

puts file_data
