#!/usr/bin/env ruby -w

##
# Student Name: John Howe
# Homework Week: 4
#
# Instructions: TODO

$: << 'lib'

require 'test/unit'
require 'week4'

class TestWeek4 < Test::Unit::TestCase
  def test_arrays
    expected = [1, 2, "three", [:happy]]

    assert_equal expected, happy_array
  end

  def test_wordlist_array
    expected = %w(an array of words)

    assert_equal expected, wordlist_array
  end

  def test_hash_function_big
    actual = hash_function [1, 2, 3, 4]
    expected = {
      "key1" => 1,
      "key2" => 2,
      "key3" => 4,
      "key4" => 8,
    }
    assert_equal expected, actual
  end

  def test_hash_function_1
    actual = hash_function [6]
    expected = { "key6" => 32 }

    assert_equal expected, actual
  end

  def test_hash_function_2
    actual = hash_function [5, 6]
    expected = {
      "key5" => 16,
      "key6" => 32,
    }
    
    assert_equal expected, actual
  end

  def test_find_all_evens
    actual = find_all_evens [1, 2, 3, 4, 5, 6, 7, 8]
    expected = [2, 4, 6, 8]

    assert_equal expected, actual
  end

  def test_map
    actual = double [1, 2, 3, 4]
    expected = [2, 4, 6, 8]

    assert_equal expected, actual
  end

  def test_block
    actual = black_box 24 do |a, b|
      a + b
    end

    assert_equal 66, actual
  end

  def test_raises
    assert_raise RuntimeError do
      raise_an_exception
    end
  end

  def test_save_the_world
    # I hate this assertion. it is here for illustration.
    assert_nothing_raised do
      save_the_world!
    end
  end

  def test_count_chars
    # flunk "write tests for bad_func, find the error via tests, and then fix it"

    # pass one
    # actual = count_chars "Testing Rules"
    # expected = 13

    actual = count_chars "Testing Rules"
    expected = {
      " "   => 1,
      "R"   => 1,
      "T"   => 1,
      "e"   => 2,
      "g"   => 1,
      "i"   => 1,
      "l"   => 1,
      "n"   => 1,
      "s"   => 2,
      "t"   => 1,
      "u"   => 1,
    }
    
    assert_equal expected, actual
  end
end
