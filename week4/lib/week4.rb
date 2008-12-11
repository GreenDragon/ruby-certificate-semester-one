#!/usr/bin/env ruby -w

##
# Student Name: John Howe
# Homework Week: 4
#
# See test/test_week4.rb for instructions.

require 'jcode'

def happy_array
  [1,2,"three", [:happy]]
end

def wordlist_array
  %w(an array of words)
end

def hash_function array
  # given an array, make a hash based on "key#{array} => 2^#{array-1}"
  h = Hash.new
  array.each do |element|
    h["key#{element}"] = 2**(element-1)
  end
  h
end

def find_all_evens array
  # Given an array, test to see if divisible by 2 and return postive results
  a = Array.new
  array.each do |element|
    a << element if element % 2 == 0
  end
  a
end

def double array
  # Given an array, double each element
  a = Array.new
  array.each do |element|
    a << element*2
  end
  a
end

def black_box a,b=42
  # Dolphins like fish
  a + b
end

def raise_an_exception
  raise "Raise an Exception"
end
  
def save_the_world!
  # save the cheerleader...
  # do_something_bad, NOT!
end

class ZOMGPonies < StandardError; end
def do_something_bad
  # don't change me, this is simulating bad code"
  raise ZOMGPonies, "oh noes! the world will end!"
end

##
# Counts chars in +str+ and returns a hash of letters => occurances.

def count_chars str
  # pass one, return the size of the string
  # str.size
  
  h = Hash.new
  a = Array.new
  str.each_char do |char|
    a << char
  end
  a.sort.each do |char|
    h.has_key?(char) ? h[char] +=1 : h[char] = 1
  end
  h
end
