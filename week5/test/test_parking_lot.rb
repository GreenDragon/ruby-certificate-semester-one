#!/usr/bin/env ruby -w

$: << 'lib'
require 'test/unit'
require 'parking-lot.rb'

class TestParkingLot < Test::Unit::TestCase
  def setup
    @lot = ParkingLot.new
  end
  
  def test_enter_gate
    actual = @lot.enter_lot?("912 NXR", "Nov 14 18:00")
    expected = [ "912 NXR", "Fri Nov 14 18:00:00 -0800 2008" ]
    
    assert_equal expected, actual
  end
  
  def test_full_lot
    @lot.enter_lot?("912 NXR", "Nov 14 18:00")
    @lot.enter_lot?("ARASHI", "Nov 14 18:02")
    @lot.enter_lot?("HOT MAMA", "Nov 14 18:03")
    @lot.enter_lot?("EXEC PAY", "Nov 14 18:04")
    
    actual = @lot.enter_lot?("666 UNX", "Nov 14 18:05")
    expected = "Sorry! Lot is Full"
    
    assert_equal expected, actual
  end
  
  def test_exit_lot_fee
    @lot.enter_lot?("912 NXR", "Nov 14 18:00")
    
    actual = @lot.exit_lot_fee?("912 NXR","Nov 14 23:59")
    expected = 59
    
    assert_equal expected, actual
  end
  
  def test_pay_lot_fee
    @lot.enter_lot?("912 NXR", "Nov 14 18:00")
    fee = @lot.exit_lot_fee?("912 NXR","Nov 14 23:59")
    
    actual = @lot.pay_fee("912 NXR", 59, "Nov 14 23:59")
    expected = [ "912 NXR", "OK", 0 ]
    
    assert_equal expected, actual
  end
  
  def test_pay_lot_fee_get_change
    @lot.enter_lot?("912 NXR", "Nov 14 18:00")
    fee = @lot.exit_lot_fee?("912 NXR","Nov 14 23:59")
    
    actual = @lot.pay_fee("912 NXR", 69, "Nov 14 23:59")
    expected = [ "912 NXR", "OK", 10 ]
    
    assert_equal expected, actual
  end
  
  def test_scan_for_fines
    @lot.enter_lot?("912 NXR", "Nov 13 18:00")
    
    actual = @lot.write_tickets
    expected = {"912 NXR"=>100}
    
    assert_equal expected, actual
  end
  
    
end