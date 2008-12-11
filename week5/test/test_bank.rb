#!/usr/bin/env ruby -w

##
# Student Name:  John Howe
# Homework Week: 5
#

$: << 'lib'
require 'test/unit'
require 'bank.rb'

##
# NOTE: these tests are just hints, go nuts with them and/or the design...

class TestBank < Test::Unit::TestCase
  def setup
    @bank = Bank.new
	test_account = @bank.new_account("Mary", 100)
  end

  def test_create_account
	actual = @bank.new_account("Joe Smith", 10000)
	expected = [ "Joe Smith", 10000 ]

	assert_equal expected, actual
  end

  def test_deposit_to_acct
	actual = @bank.deposit("Mary", 10)
	expected = 110

	assert_equal expected, actual
  end

  def test_deposit_to_acct_unknown_person
	actual = @bank.deposit("Fred", 100)
	expected = "Account: Fred not found"

	assert_equal expected, actual
  end

  def test_withdraw_known_person
	actual = @bank.withdraw("Mary", 10)
	expected = 90

	assert_equal expected, actual
  end

  def test_withdraw_known_person_overdraw
	actual = @bank.withdraw("Mary", 1000)
	expected = "Insufficient Funds"

	assert_equal expected, actual
  end

  def test_withdraw_unknown_person
	actual = @bank.withdraw("Fred", 1000)
	expected = "Account: Fred not found"

	assert_equal expected, actual
  end
end
