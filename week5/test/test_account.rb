#!/usr/bin/env ruby -w

$: << 'lib'
require 'test/unit'
require 'bank.rb'
require 'account.rb'

class TestAccount < Test::Unit::TestCase
  def setup
	@bank = Bank.new
    account = @bank.new_account("Money Penny", 100)
  end

  def test_deposit
	actual = @bank.deposit("Money Penny", 10)
	expected = 110
	
	assert_equal expected, actual
  end

  def test_withdraw
	actual = @bank.withdraw("Money Penny", 10)
	expected = 90

	assert_equal expected, actual
  end

  # have fun and good luck...
end
