#!/usr/bin/env ruby -w

require 'find'
require 'getoptlong'
# require 'rdoc/usage'

class AdminUtil
  
  attr_accessor :top, :directory, :files, :file_sizes, :file_groups
    
  def initialize(top=10, directory=".")
    @top = top
    @directory = directory
    @files = []
    @file_sizes = Hash.new{0}
    @file_groups = Hash.new{0}
  end
  
  def parse_args(argv)
    opts = GetoptLong.new(
      [ '-n', GetoptLong::OPTIONAL_ARGUMENT ]
    )
    
    opts.each do |opt, arg|
      puts "opt: #{opt}, arg: #{arg}"
      case opt
        when '-n'
          @top = arg.to_i
      end
    end
    
    puts "args #{argv.length}"
    puts "top #{@top}"
    
    if argv.length != 1
      puts "Missing directory argument"
      exit 0
    end
    
    @directory = argv.shift
    puts "dir: #{@directory}"
  end
  
  def gather_data(dir)
    Dir.glob( File.join(directory, '**', '*') ) { |file| @files << file }
  end
  
  def calc_extensions
    unless @files.empty?
      @files.each do |file|
        /^.*\.(.*)$/ =~ file
        @file_groups[Regexp.last_match(1)] += 1
      end
    end
  end
  
  def calc_sizes
    # stats is a hash of path => [File::Stat] info
    unless @files.empty?
      @files.each do |file|
        @file_sizes[file] = File.stat(file).size
      end
    end
  end
  
  def report
    # sort by highest
    @file_sizes.sort{ |a,b| b[1] <=> a[1]}.each { |elem| 
      puts "#{elem[1]}, #{elem[0]}"
    }
  end      

  def run(argv)
    # @directory = argv[0]
    parse_args(argv)
    data = gather_data directory
    calc_sizes
    calc_extensions
    # report data
  end
end

au = AdminUtil.new
au.run(ARGV) if __FILE__ == $0

class NotEnoughArgumentsException < StandardError; end

# Bonus points for those who mock out the file system walker itself so
# it can be tested as well.
