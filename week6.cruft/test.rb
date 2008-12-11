#!/usr/bin/env ruby -w
 require 'find'
 
 def find_and_print(path, pattern)
   Find.find(path) do |entry|
     if File.file?(entry) and entry[pattern]
       puts entry
     end
   end
 end
 
 # print all the ruby files
 find_and_print(".", /.*/)
