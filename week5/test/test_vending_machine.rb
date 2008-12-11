#!/usr/bin/env ruby -w

$: << 'lib'
require 'test/unit'
require 'vending-machine.rb'

class TestVendingMachine < Test::Unit::TestCase
  def setup
	  @machine = VendingMachine.new
    cola = @machine.new_product("Cola", 10, 1.50)
    chips = @machine.new_product("Chips", 10, 0.75)
  end

  def test_add_new_product
    actual = @machine.new_product("Candy", 10, 2.00)
    expected = [ "Candy", 10, 2.00 ]
	
    assert_equal expected, actual
  end

  def test_dispense_product
    actual = @machine.dispense("Cola", 10)
    expected = 0

    assert_equal expected, actual
  end
  
  def test_refill_product
    @machine.dispense("Cola", 10)
    actual = @machine.refill("Cola", 20)
    expected = 20
    
    assert_equal expected, actual
  end
  
  def test_purchase_product
    actual = @machine.purchase("Cola", 1, 1.50)
    expected = [ "Cola", 1, 0.00 ]
    
    assert_equal expected, actual
  end
  
  def test_purchase_product_get_change
    actual = @machine.purchase("Cola", 1, 2.00)
    expected = [ "Cola", 1, 0.50 ]
    
    assert_equal expected, actual
  end
  
  def test_purchase_product_need_more_money
    actual = @machine.purchase("Cola", 1, 1.00)
    expected = [ "Short Funds", 0, -0.50 ]
    
    assert_equal expected, actual
  end
  
  def test_purchase_product_multiples
    actual = @machine.purchase("Cola", 2, 3.00)
    expected = [ "Cola", 2, 0.00 ]
    
    assert_equal expected, actual
  end
  
  def test_purchase_product_when_out_of_stock
    @machine.dispense("Cola", 10)
    
    actual = @machine.purchase("Cola", 1, 2.00)
    expected = [ "Cola out of stock!", 0, 2.00 ]
        
    assert_equal expected, actual
  end
  
  def test_purchase_product_over_available_stock
    @machine.dispense("Chips", 8)
    
    actual = @machine.purchase("Chips", 3, 10.00)
    expected = [ "Not enough Chips!", 0, 10.00 ]
    
    assert_equal expected, actual
  end
    
  
end
