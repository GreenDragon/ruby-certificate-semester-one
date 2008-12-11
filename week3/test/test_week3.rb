#!/usr/bin/env ruby -w

require 'test/unit'
$: << 'lib'
require 'week3'

##
# Student Name: John Howe
# Homework Week: 3
#
# This week's homework is the most rudimentary tests I can come up
# with. We've not gone over much of the language yet, so we can't use
# many of the assertions (assert_raise won't make much sense until we
# go over exceptions on week 4). This week is a chicken and egg
# problem.
#
# Some of this week should be spent familiarizing yourself with this
# typical file layout, your editor, moving around, defining new
# functions, etc... Go slow, take your time, ask lots of questions,
# share your own answers. It only gets harder, so get the fundamentals
# down pat.
#
# That said, I highly recommend writing more tests to help explore the
# language (ie, verify that String#split works the way you think it
# does by testing it).
#

class TestWeek3 < Test::Unit::TestCase
  def test_problem_1
    assert problem_1
  end

  def test_problem_2
    assert_equal "happy", problem_2
  end

  def test_problem_3_numbers
    assert_equal    3,   problem_3(1, 2)
    assert_in_delta 3.5, problem_3(1.5, 2), 0.001
  end

  def test_problem_3_strings
    assert_equal "hi bye", problem_3("hi ", "bye")
  end

  def test_problem_3_arrays
    a = %w(a b c)
    b = [1, 2, 3]
    assert_equal ["a", "b", "c", 1, 2, 3], problem_3(a, b)
    assert_equal ["a", "b", "c"], a, "a should be unmolested"
    assert_equal [1, 2, 3], b, "b should be unmolested"
  end

  def test_fizzbang
    assert_equal "3. Fizz", fizzbang(3)
    assert_equal "5. Buzz", fizzbang(5)
    assert_equal "15. FizzBuzz", fizzbang(15)
    assert_equal "4.", fizzbang(4)
  end
end
