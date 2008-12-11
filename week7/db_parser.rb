#!/usr/bin/ruby -w
require 'time'

class Album < Array
	def age
		map { |track| track.age }.max
	end

	def score
		total / Math.log(age)
	end

	def total
		inject(0.0) do |total_score, track|
			total_score + track.score
		end
	end

	def self.parse(file)
		today = Time.now
		d = {}
		library = Hash.new { |h,k| h[k] = Album.new }
  
		IO.foreach(File.expand_path(file)) do |line|
			if line =~ /<key>(Name|Artist|Album|Date Added|Play Count|Rating)<\/key><.*?>(.*)<\/.*?>/ then
				key = $1.downcase.split.first
				val = $2
				d[key.intern] = val

				if d.size == 6 then
					date = d[:date].sub(/T.*/, '')
					key = "#{d[:album]} by #{d[:artist]}"
					age = ((today - Time.parse(date)) / 86400.0).to_i
					library[key] << Track.new(age, d[:play].to_i, d[:rating].to_i / 20)
					d.clear
				end
			end
		end
		library
 	end
end
  
Track = Struct.new(:age, :count, :rating)
class Track
	def score
		rating * count.to_f
	end
end

max = (ARGV.shift || 10).to_i
file = ARGV.shift || "~/Music/iTunes/iTunes Music Library.xml"
library = Album.parse(file)
  
top = library.sort_by { |h,k| -k.score }[0...max]
top.each_with_index do |(artist_album, album), c|
	puts "%-3d = (%4d tot, %5.2f adj): %s" % [c+1, album.total, album.score, artist_album,]
	album.each do |t|
		puts "  #{t.age} days old, #{t.count} count, #{t.rating} rating = #{t.score}"
	end 
	# if $DEBUG
end
