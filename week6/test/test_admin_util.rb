#!/usr/bin/env ruby -w

$: << 'lib'

require 'test/unit'
require 'admin-util'

##
# Student Name: John Howe
# Homework Week: 6
#
#

## Problem #2: file statistics

# Admins often have to deal with large and unfamiliar file systems under
# severe time constraints. If a disk is full, or acting weird, they need
# to be able to react quickly. Let's help them out. Design a program
# that will give them some useful information that might help them
# figure out what to do on short notice.
#
#  Minimum requirements:
#
#	1) Must walk a whole file tree and provide "useful" information.
#
#	2) Must report the N biggest files names and sizes in readable fashion.
#
#	3) Must report the N biggest "groups" of file types (by file extension).
#
#	4) Must report the N oldest files names, dates, and sizes.
#
#	5) N can be specified as a command-line argument (-n), defaulting to 10.
#

class TestAdminUtil < Test::Unit::TestCase
  def setup
    @au = AdminUtil.new
  end
  
  def test_parse_args_set_directory
    argv = [ "testdir/" ]
    
    @au.parse_args(argv)
    
    actual = @au.directory
    expected = "testdir/"
    
    assert_equal expected, actual
  end
  
  def test_parse_args_set_top
    ARGV = [ "-n", "5", "testdir/" ]
    
    @au.parse_args(ARGV)
    
    actual = @au.top
    expected = 5
    
    assert_equal expected, actual
  end
  
  def test_walk_given_dir
    @au.directory = "testdir/"
    @au.gather_data(@au.directory)
    
    actual = @au.files
    expected = [
      "testdir/2008-10-12-warning-in-case-of-terrorist-attack.png", 
      "testdir/2008_WA_Permie.doc", 
      "testdir/2czc1ua.jpg", 
      "testdir/CPAN.txt", 
      "testdir/GEM.20081117", 
      "testdir/LJ.txt", 
      "testdir/Ohana.txt", 
      "testdir/political-pictures-barack-obama-chill-out-got-this.jpg", 
      "testdir/PORTS.txt", 
      "testdir/sheekymacro.jpg",
      "testdir/tobiuo.jpg"
    ]
    
    assert_equal expected, actual
  end
  
  def test_populate_file_size_hash
    @au.directory = "testdir/"
    @au.gather_data(@au.directory)
    @au.calc_sizes
    
    actual = @au.file_sizes
    expected = {
      "testdir/PORTS.txt"=>886,
      "testdir/political-pictures-barack-obama-chill-out-got-this.jpg"=>25513,
      "testdir/Ohana.txt"=>173,
      "testdir/LJ.txt"=>135,
      "testdir/2008-10-12-warning-in-case-of-terrorist-attack.png"=>108674,
      "testdir/2czc1ua.jpg"=>411516,
      "testdir/tobiuo.jpg"=>189430,
      "testdir/sheekymacro.jpg"=>128095,
      "testdir/GEM.20081117"=>736,
      "testdir/CPAN.txt"=>288,
      "testdir/2008_WA_Permie.doc"=>29696
    }
    
    assert_equal expected, actual
  end
  
  def test_populate_file_extensions_hash
    @au.directory = "testdir/"
    @au.gather_data(@au.directory)
    @au.calc_extensions
    
    actual = @au.file_groups
    expected = {
      "20081117"=>1, 
      "jpg"=>4, 
      "doc"=>1, 
      "txt"=>4, 
      "png"=>1
    }
    
    assert_equal expected, actual
  end
  
end