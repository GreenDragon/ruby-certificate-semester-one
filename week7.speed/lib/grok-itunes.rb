#!/usr/bin/env ruby -w

require 'ftools'
require 'time'

class GrokITunes
  BENCHMARK = false

  attr_accessor :file, :tracks, :playlists, :now
 
  def initialize(file)
    @file = file
    @top = 10
    @tracks = []
    @playlists = []
    @now = Time.now
    valid_file?
  end

  def valid_file?
    unless File.exist?(File.expand_path(@file))
      raise FileNotFoundException, "File not found: #{@file}"
    end
    if File.size?(File.expand_path(@file)) == nil
      raise FileEmptyException, "File has no content: #{@file}"
    else
      true
    end
  end

  # Based on seconds_fraction_to_time http://snippets.dzone.com/posts/show/5958
  def human_clock_time(seconds)
    days = hours = mins = 0
    if seconds >= 60 then
      mins = ( seconds / 60 ).to_i
      seconds = ( seconds % 60 ).to_i
      
      if mins >= 60 then
        hours = ( mins / 60 ).to_i
        mins = ( mins % 60 ).to_i
      end
      
      if hours >= 24 then
        days = ( hours / 24 ).to_i
        hours = ( hours % 24 ).to_i
      end
    end
    "#{days.to_s.rjust(3,"0")}:#{hours.to_s.rjust(2,"0")}:#{mins.to_s.rjust(2,"0")}:#{seconds.to_s.rjust(2,"0")}"
  end
  
  def fix_type(value, type)
    # Sanitize String data into proper Class before injection 
    if type =~ /date/ then
      value = value.sub(/T/, ' ').sub(/Z/, '')
      Time.parse(value)
    elsif type =~ /integer/ then
      value.to_i
    elsif type =~ /string/ then
      value.to_s
    elsif type =~ /boolean/ then
      if value == "true"
        true
      elsif value == "false"
        false
      else
        raise NonBooleanValueException, "Really now? True or False?: #{value}"
      end
    else
      raise UnknownDataTypeException, "I don't know how to treat type: #{type}"
    end
  end

  # Based on work by zenspider @ http://snippets.dzone.com/posts/show/3700

  def parse_xml
    puts "Start: #{Time.now} parse_xml" if BENCHMARK
    
    is_tracks = is_playlists = false

    track = {}
    playlist = {}
    playitems = []

    IO.foreach(File.expand_path(@file)) do |line|
      if line =~ /^\t<key>Tracks<\/key>$/
        is_tracks = true
        next
      end

      if is_tracks then
        if line =~ /^\t\t\t<key>(.*)<\/key><(date|integer|string)>(.*)<\/.*>$/ then
          key = $1.downcase.split.join("_").intern
          track[key] = fix_type($3, $2)
          next
        elsif line =~ /^\t\t\t<key>(.*)<\/key><(true|false)\/>$/ then
          key = $1.downcase.split.join("_").intern
          track[key] = fix_type($2, "boolean")
          next
        elsif line =~ /^\t\t<\/dict>$/ then
          @tracks.push(track.dup)
          track.clear
          next
        elsif is_tracks && line =~ /^\t<\/dict>$/
          is_tracks = false
          next
        else
          next
        end
      end

      if line =~ /^\t<key>Playlists<\/key>$/ then
        is_playlists = true
        next
      end
      
      if is_playlists then
        if line =~ /^\t\t\t<key>(.*)<\/key><(date|integer|string)>(.*)<\/.*>$/ then
          key = $1.downcase.split.join("_").intern
          playlist[key] = fix_type($3, $2)
          next
        elsif line =~ /^\t\t\t<key>(.*)<\/key><(true|false)\/>$/ then
          key = $1.downcase.split.join("_").intern
          playlist[key] = fix_type($2, "boolean")
          next
        elsif line =~ /^\t\t\t\t\t<key>Track ID<\/key><integer>(.*)<\/integer>$/ then
          playitems.push($1.to_i)
          next
        elsif line =~ /^\t\t<\/dict>$/ then
          @playlists.push([playlist.dup, playitems.dup])
          playlist.clear
          playitems.clear
          next
        elsif is_playlists && line =~ /^\t<\/array>$/ then
          is_playlists = false
          next
        else
          next
        end
      end
    end

    puts "Stop:  #{Time.now} parse_xml" if BENCHMARK
  end

  def top_thing(name)
    c = Hash.new(0)
    @tracks.each do |t|
      c[t[name]] += 1 if t[name]
    end
    c.sort { |a,b| b[1] <=> a[1] }.first(@top)
  end

  def count_thing(name)
    c = Hash.new(0)
    @tracks.each do |t|
      c[t[name]] += 1 if t[name]
    end
    c.size
  end
  
  def count_tracks
    tracks.size
  end
  
  def total_time
    time = 0
    @tracks.each do |t|
      if t[:total_time] then
        time += t[:total_time]/1000.00
      end
    end
    human_clock_time(time) 
  end

  def oldest_tracks
    a = []
    @tracks.each do |t|
      if t[:play_date_utc] then
        a.push([t[:play_date_utc].dup,t[:name].dup])
      end
    end
    a.sort.first(@top) 
  end

  def top_tracks_on_rating_times_playcount
    a = []
    @tracks.each do |t|
      if t[:rating] && t[:play_count] then
        a.push([ (t[:rating] * t[:play_count]), t[:name], t[:artist], t[:play_date_utc] ])
      end
    end
    a.sort.reverse.first(@top)
  end

#  # Based on work by zenspider @ http://snippets.dzone.com/posts/show/3700 
  def top_tracks_aging_well
    results = []
    @tracks.each do |t|
      if t[:rating] && t[:play_count] && t[:play_date_utc] then
        rating = t[:rating] * t[:play_count] * Math.log( ((self.now - Time.parse("#{t[:play_date_utc]}")) / 86400.00).to_i )
        results.push( [ rating.to_i, t[:name], t[:artist], t[:play_date_utc] ] )
      end
    end
    results.sort.reverse.first(@top)
  end
end

class FileEmptyException < StandardError; end
class FileNotFoundException < StandardError; end
class UnknownDataTypeException < StandardError; end
class NonBooleanValueException < StandardError; end
