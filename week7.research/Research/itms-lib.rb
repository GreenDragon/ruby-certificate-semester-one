# ITMS (iTunes) Search Library v 0.1
# Author: Chris Heald ( cheald at gmail )
# License: LGPL 2.1
# http://creativecommons.org/licenses/LGPL/2.1/

require 'rubygems'
require 'net/http'
require 'cgi'
require 'zlib'
require 'hpricot'

# === About
#
# Module for searching iTunes and returning interesting information from it.
# 
# === Searching iTunes
#
#	result = ITunes::Search.new("Good Charlotte").search
# 	
# This returns a +ResultParser+ that can parse the result body into a standard Ruby hash.
# If you're just interested in the songs from a search result:
# 
#	ITMS::Search.new("Good Charlotte").search.results(:items)                          # Gets all items from the search
#	ITMS::Search.new("Good Charlotte").search.results(:items, :kind => :song)          # Gets all songs from the search
#	ITMS::Search.new("Good Charlotte").search.results(:items, :kind => "tv-episode")   # Gets all TV episodes from the search
#
#	# Get all songs and their reference URL from a search
#	result = ITMS::Search.new("Good Charlotte").search
#	puts result.results(:items, :kind => :song).collect {|song| [song["itemName"], song["url"]] }.inspect
#
module ITMS

	# Object capable of parsing an ITMS reponse body and will return a hash from it. Can also be used for iTunes local library files!
	class ResultParser
		
		# Create a new parser. Takes an XML string and the CSS path to the root node to parse.
		def initialize(body, path = nil)			
			@path = path
			@doc = Hpricot.XML body
		end
		
		# Convert the ITMS XML to a ruby hash
		def to_hash
			return @result unless @result.nil?
			root = @doc.at(@path)
			@result = {}
			parse_node(root, @result)
			return @result
		end

		# Returns the Hpricot document used to parse this document, in case you want to get right down to the metal with it. Not recommended!
		def doc
			@doc
		end
		
		# Return all results from this search from a toplevel +key+, with subvalues matching options.
		# For example:
		#
		#	# Return all the "items" array from a search
		#	results(:items)
		#	
		#	# Return all the "items" array from a search, where the "kind" key == "song"
		#	results(:items, :kind => :song)
		#
		def results(key = nil, options = {})
			return to_hash if key.nil?
			to_hash[key.to_s].select do |i|
				result = true
				options.each do |k,v|
					result = false unless i[k.to_s] == v.to_s
				end
				result
			end
		end
		
	private
	
		# Recursive XML parsing. ITMS XML uses a rather odd convention in that it has a "<key>keyName</key><valueType>value</valueType>" structure, rather than
		# the more conventional
		#
		#	<keyName attr="value">
		#
		def parse_node(node, parent)
			key = nil
			node.each_child do |child|
				next unless child.elem?
				if child.name == "key" then
					raise "Tried to set a new key \"#{child.name}\" when we already have an existing key \"#{key}\"" unless key.nil?
					key = child.to_plain_text
				else
					sibling = child
					case sibling.name
					when "dict"
						if parent.is_a? Hash
							parent[key] = {}
							parse_node(sibling, parent[key])
						elsif parent.is_a? Array
							v = {}
							parse_node(sibling, v)
							parent.push v
						else
							raise "Invalid parent class: #{parent.class}, expected Hash or Array"
						end
						key = nil
					when "array"
						if parent.is_a? Hash
							parent[key] = []
							parse_node(sibling, parent[key])
						elsif parent.is_a? Array
							v = []
							parse_node(sibling, v)
							parent.push v
						else
							raise "Invalid parent class: #{parent.class}, expected Hash or Array"
						end
						key = nil
					when "integer"
						if parent.is_a? Hash
							parent[key] = sibling.to_plain_text.to_i
						elsif parent.is_a? Array
							parent.push sibling.to_plain_text.to_i
						else
							raise "Invalid parent class: #{parent.class}, expected Hash or Array"
						end
						key = nil
					else
						if parent.is_a? Hash
							parent[key] = sibling.to_plain_text.strip
						elsif parent.is_a? Array
							parent.push sibling.to_plain_text.strip
						else
							raise "Invalid parent class: #{parent.class}, expected Hash or Array"
						end
						key = nil
					end
				end
			end
		end
	end
	
	DEFAULT_HEADERS = {
		"User-Agent"			=>	"iTunes/7.4.2",
		"Accept-Language"		=>	"en-us, en;q=0.50",
		"X-Apple-Tz"			=>	"0",
		"Accept-Encoding"		=>	"gzip",
		"X-Apple-Store-Front"	=> "143441-1"		
	}
	
	# Base class used for searching the ITMS. Needs a specific search action URL to actually do anything.
	# If you want to search a URL not provided for in another class, just pass it as the first parameter to +search+
	
	class SearchBase
		SEARCH_HOST = "ax.phobos.apple.com.edgesuite.net"
		
		def search(url, path, host = nil, port = 80)
			return @result unless @result.nil?
			@http = Net::HTTP.new((host || SEARCH_HOST), port)
			resp = @http.request_get(url, DEFAULT_HEADERS)
			body = StringIO.new resp.body
			begin
				full_body = Zlib::GzipReader.new(body).read
			rescue => e
				puts e.message
				puts resp.body.inspect
				raise e
			end
			@result = ResultParser.new(full_body, path)
		end
		
		# Get the ITMS::ResultParser resulting from this search.
		def result
			@result
		end
	end

	# Perform an ITMS search. See ITMS::SearchBase for the result.
	class Search < SearchBase
		SEARCH_URL	= "/WebObjects/MZSearch.woa/wa/search?submit=edit&term=%s"
		
		# Create a new search. +query+ is the string to search for.
		def initialize(query)
			@search_url = sprintf(SEARCH_URL, CGI::escape(query))
		end
		
		# Perform the search. Returns an ITMS::ResultParser
		def search
			super(@search_url, "Document>TrackList>plist>dict")
		end
		
		# Return all items from this search matching +kind+. If no +kind+ is specified, then all items are returned.
		def items(kind = nil, opts = {})
			search.results(:items, opts)
		end
	end
	
	# Search for Cover Art for a specific artist/album
	class CoverArt < SearchBase
		SEARCH_URL	= "/WebObjects/MZSearch.woa/wa/coverArtMatch?an=%s&pn=%s"
		
		# Create a new search. +artist+ and +album+ must be specified.
		def initialize(artist, album)
			@search_url = sprintf(SEARCH_URL, CGI::escape(artist), CGI::escape(album))
		end
		
		# Perform the search. Returns an ITMS::ResultParser
		def search
			super(@search_url, "Document>Protocol>plist>dict")
		end
	end
end