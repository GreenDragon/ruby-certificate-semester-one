#!/usr/bin/ruby -w

# TODO Refactor option parsing into a separate class

require 'pp'
require 'open-uri'

class PowerGrep
  
  attr_accessor :options, :search, :sources, :found, :results
  
  def initialize
    @count = 0
    @options = Hash.new{0}
    @search = nil
    @sources = []
    @found = 0
    @results = []
  
    @valid_opts = "^\-[ifq]$"
    @opts = "^\-[a-zA-Z0-9].*$"
    @switch = "^\-+"
  end

  def usage
    puts
    puts "Usage:"
    puts "    #{$0} [-f|-i|-q] search_term source(s)"
    puts
    puts "Purpose:"
    puts "    Searches source(s) for given search_term"
    puts
    puts "    search_term can be a simple term or simple regex"
    puts "    enclose complex regexes in quotes"
    puts
    puts "    source(s) can either be files or URLs"
    puts
    puts "Options:"
    puts "    -f fast search, no regexes in search_term"
    puts "    -i case insensitive search"
    puts "    -q quiet search, returns 1 on match, 0 on no match"
    puts
    puts "Examples:"
    puts "    #{$0} -f javascript http://www.google.com/"
    puts "    #{$0} -i \"^\[2008-11-18\]: smtp:.*\" /var/log/mail.info"
    exit!
  end

  def no_options(opt)
    raise SwitchPassedWithNoOptionsDeclaredException, "No option char passed with switch: #{opt}"
  end
  
  def parse_argv(argv)
    if argv[0] =~ /^(\-*h|\-*help)$/ or argv.size < 2 then
      raise NotEnoughArgumentsException, "No arguments provided! Try \"#{$0} --help\""
    else
      argv.map { |arg| parse_args(arg) }
    end
  end
    
  def parse_opts(opt)
    # scan for our options
    options[:fast] = 1			    if opt == "-f"
    options[:insensitive] = 1	  if opt == "-i"
    options[:quiet] = 1		      if opt == "-q"
    # does the user want help?
    usage                       if opt == "-h"
    # bad options 
    unless opt =~ /#{@valid_opts}/
      raise BadSwitchInArgumentsException, "Bad Option Provided: #{opt}"
    end
  end

  def parse_args(arg)
    if @count == 0 then
      if arg =~ /#{@opts}/ then
        # first element is an option
        parse_opts(arg)
      elsif arg =~ /#{@switch}/
        # or a bad switch
        no_options(arg)
      else
        # or a search term
        set_search(arg)
      end
    elsif @search != nil then
      # has @search been defined?
      if arg =~ /#{@opts}/ then
        # Is user passing errant switch out of call order?
        raise SwitchesUsedAfterDeclaringSearchTermException, "Switch used after search term"
      elsif arg =~ /#{@switch}/
        # or passing a bad switch?
        no_options(arg)
      else
        # Start populating the source array
        @sources << arg
      end
    else
      if arg =~ /#{@opts}/ then
        # there may be many options
        parse_opts(arg)
      elsif arg =~ /#{@switch}/
        # or a bad switch
        no_options(arg)
      else
        # otherwise it must be the search term
        set_search(arg)
      end
    end
    @count += 1
  end
  
  def has_search?
    unless @search
      raise MissingSearchTermException, "Missing search terms"
    end
  end

  def has_sources?
    if @sources.empty?
      raise MissingSourcesException, "Missing source(s) list"
    end
  end

  def insensitive?
    @options.has_key?(:insensitive)? true: false
  end

  def fast?
    @options.has_key?(:fast)? true: false
  end

  def quiet?
    @options.has_key?(:quiet)? true: false
  end

  def set_search(str)
    if insensitive? then
      if fast? then
        @search = Regexp.new(Regexp.escape(str),true)
      else
        @search = Regexp.new(str,true)
      end
    else
      if fast? then
        @search = Regexp.new(Regexp.escape(str))
      else
        @search = Regexp.new(str)
      end
    end
  end
  
  def is_valid_uri?(src)
    if src =~ /^(ftp|http|https)\:\/\/.*/ then
      true
    elsif src =~ /^([a-zA-Z]+.*)\:\/\/.*/ then
      raise UnsupportedURIException, "Unsupported URI: #{src}"
    elsif src =~ /(\*|\+|\?)/ then
      raise UnsupportedFileGlobException, "Unsupport file glob: #{src}"
    else
      true
    end
  end
  
  def parse_source(src)
    begin
      open(src) do |f|
        a = []
        f.map { |line| a << line if line.match(search) }
        display_results(a, src) unless a.empty?
      end
    rescue
      raise CantOpenSourceFileForReadException, "Can't open #{src} for read"
    end
  end
  
  def display_results(array, str)
    if quiet?
      @found=1
    else
      array.each do |a|
        @results << "#{str}: #{a.chomp}"
      end
      @results.each { |result| puts result }
    end
  end

  def run(argv)
    parse_argv(argv)
    
    has_search?
    has_sources?
    
    @sources.each do |source| 
      parse_source(source) if is_valid_uri?(source)
    end

    exit(@found) if quiet?
  end

end

class NotEnoughArgumentsException < StandardError; end

class BadSwitchInArgumentsException < StandardError; end

class SwitchPassedWithNoOptionsDeclaredException < StandardError; end

class SwitchesUsedAfterDeclaringSearchTermException < StandardError; end

class MissingSearchTermException < StandardError; end

class MissingSourcesException < StandardError; end

class UnsupportedURIException < StandardError; end

class UnsupportedFileGlobException < StandardError; end

class CantOpenSourceFileForReadException < StandardError; end

pg = PowerGrep.new
pg.run(ARGV) if $0 == __FILE__
