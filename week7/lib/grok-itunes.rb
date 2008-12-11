#!/usr/bin/env ruby -w

require 'ftools'
require 'time'
require 'rubygems'
require 'sqlite3'
# require 'scrobbler'

class GrokITunes
  BENCHMARK = false

  attr_accessor :db, :file, :tracks, :playlists, :now
 
  def initialize(file)
    @db = nil
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

  def init_db
    puts "init_db: start #{Time.now}" if BENCHMARK
    
    db_file = File.expand_path(@file) + ".db"

		@now = Time.now
    @db = SQLite3::Database.new("#{db_file}")

    @db.execute( "drop table if exists tracks_playlists" )
    @db.execute( "drop table if exists playlists" )
    @db.execute( "drop table if exists tracks" )

    create_tables = <<SQL
      create table tracks (
        track_id                INTEGER PRIMARY KEY,
        name                    VARCHAR DEFAULT NULL,
        artist                  VARCHAR DEFAULT NULL,
        album_artist            VARCHAR DEFAULT NULL,
        composer                VARCHAR DEFAULT NULL,
        album                   VARCHAR DEFAULT NULL,
        grouping                VARCHAR DEFAULT NULL,
        genre                   VARCHAR DEFAULT NULL,
        kind                    VARCHAR DEFAULT NULL,
        size                    INTEGER DEFAULT NULL,
        total_time              INTEGER DEFAULT NULL,
        disc_number             INTEGER DEFAULT NULL,
        disc_count              INTEGER DEFAULT NULL,
        track_number            INTEGER DEFAULT NULL,
        track_count             INTEGER DEFAULT NULL,
        year                    INTEGER DEFAULT NULL,
        bpm                     INTEGER DEFAULT NULL,
        date_modified           DATE DEFAULT NULL,
        date_added              DATE DEFAULT NULL,
        bit_rate                INTEGER DEFAULT NULL,
        sample_rate             INTEGER DEFAULT NULL,
        volume_adjustment       INTEGER DEFAULT NULL,
        part_of_gapless_album   BOOLEAN DEFAULT NULL,
        equalizer               VARCHAR DEFAULT NULL,
        comments                VARCHAR DEFAULT NULL,
        play_count              INTEGER DEFAULT NULL,
        play_date               INTEGER DEFAULT NULL,
        play_date_utc           DATE DEFAULT NULL,
        skip_count              INTEGER DEFAULT NULL,
        skip_date               DATE DEFAULT NULL,
        release_date            DATE DEFAULT NULL,
        rating                  INTEGER DEFAULT NULL,
        album_rating            INTEGER DEFAULT NULL,
        album_rating_computed   BOOLEAN DEFAULT NULL,
        compilation             BOOLEAN DEFAULT NULL,
        series                  VARCHAR DEFAULT NULL,
        season                  INTEGER DEFAULT NULL,
        episode                 VARCHAR DEFAULT NULL,
        episode_order           INTEGER DEFAULT NULL,
        sort_album              VARCHAR DEFAULT NULL,
        sort_album_artist       VARCHAR DEFAULT NULL,
        sort_artist             VARCHAR DEFAULT NULL,
        sort_composer           VARCHAR DEFAULT NULL,
        sort_name               VARCHAR DEFAULT NULL,
        sort_series             VARCHAR DEFAULT NULL,
        artwork_count           INTEGER DEFAULT NULL,
        persistent_id           VARCHAR DEFAULT NULL,
        disabled                BOOLEAN DEFAULT NULL,
        clean                   BOOLEAN DEFAULT NULL,
        explicit                BOOLEAN DEFAULT NULL,
        track_type              VARCHAR DEFAULT NULL,
        podcast                 BOOLEAN DEFAULT NULL,
        has_video               BOOLEAN DEFAULT NULL,
        hd                      BOOLEAN DEFAULT NULL,
        video_width             INTEGER DEFAULT NULL,
        video_height            INTEGER DEFAULT NULL,
        movie                   BOOLEAN DEFAULT NULL,
        tv_show                 BOOLEAN DEFAULT NULL,
        protected               BOOLEAN DEFAULT NULL,
        purchased               BOOLEAN DEFAULT NULL,
        unplayed                BOOLEAN DEFAULT NULL,
        file_type               INTEGER DEFAULT NULL,
        file_creator            INTEGER DEFAULT NULL,
        location                VARCHAR DEFAULT NULL,
        file_folder_count       INTEGER DEFAULT NULL,
        library_folder_count    INTEGER DEFAULT NULL
      );

      create table playlists (
        playlist_id             INTEGER PRIMARY KEY,
        master                  BOOLEAN DEFAULT NULL,
        name                    VARCHAR DEFAULT NULL,
        playlist_persistent_id  VARCHAR DEFAULT NULL,
        distinguished_kind      INTEGER DEFAULT NULL,
        folder                  BOOLEAN DEFAULT NULL,
        visible                 BOOLEAN DEFAULT NULL,
        audiobooks              BOOLEAN DEFAULT NULL,
        movies                  BOOLEAN DEFAULT NULL,
        music                   BOOLEAN DEFAULT NULL,
        party_shuffle           BOOLEAN DEFAULT NULL,
        podcasts                BOOLEAN DEFAULT NULL,
        purchased_music         BOOLEAN DEFAULT NULL,
        tv_shows                BOOLEAN DEFAULT NULL,
        all_items               BOOLEAN DEFAULT NULL,
        genius_track_id         BOOLEAN DEFAULT NULL,
        smart_info              BLOB DEFAULT NULL,
        smart_criteria          BLOB DEFAULT NULL
      );

      create table tracks_playlists (
        track_id                INTEGER,
        playlist_id             INTEGER
      );
SQL

    @db.execute_batch( create_tables )
    puts "init_db: stop  #{Time.now}" if BENCHMARK
  end

  def populate_db
    puts "populate_db: start #{Time.now}" if BENCHMARK
    @db.transaction do |db|
      db.prepare( 
        "insert into tracks values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
          ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
          ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
          ?, ?, ?, ?, ?, ? )" 
      ) do |stmt|
        @tracks.each do |t|
          stmt.execute t[:track_id], "#{t[:name]}", "#{t[:artist]}", 
          "#{t[:album_artist]}", "#{t[:composer]}", "#{t[:album]}", 
          "#{t[:grouping]}", "#{t[:genre]}", "#{t[:kind]}", t[:size], 
          t[:total_time], t[:disc_number], t[:disc_count], t[:track_number], 
          t[:track_count], t[:year], t[:bpm], t[:date_modified], t[:date_added], 
          t[:bit_rate], t[:sample_rate], t[:volume_adjustment], 
          t[:part_of_gapless_album], "#{t[:equalizer]}", "#{t[:comments]}", 
          t[:play_count], t[:play_date], t[:play_date_utc], t[:skip_count], 
          t[:skip_date], t[:release_date], t[:rating], t[:album_rating], 
          t[:album_rating_computed], t[:compilation], t[:series], t[:season], 
          t[:episode], t[:episode_order], "#{t[:sort_album]}", 
          "#{t[:sort_album_artist]}", "#{t[:sort_artist]}", "#{t[:sort_composer]}", 
          "#{t[:sort_name]}", "#{t[:sort_series]}", t[:artwork_count], 
          "#{t[:persistent_id]}", t[:disabled], t[:clean], t[:explicit], 
          "#{t[:track_type]}", t[:podcast], t[:has_video], t[:hd], t[:video_width], 
          t[:video_height], t[:movie], t[:tv_show], t[:protected], t[:purchased], 
          t[:unplayed], t[:file_type], t[:file_creator], t[:location], 
          t[:file_folder_count], t[:library_folder_count]
        end
      end

      db.prepare(
        "insert into playlists values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, 
        ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      ) do |stmt|
        @playlists.each do |p|
          stmt.execute p[0][:playlist_id], p[0][:master], "#{p[0][:name]}", 
          "#{p[0][:playlist_persistent_id]}", p[0][:distinguished_kind], p[0][:folder], 
          p[0][:visible], p[0][:audiobooks], p[0][:movies], p[0][:music], p[0][:party_shuffle], 
          p[0][:podcasts], p[0][:purchased_music], p[0][:tv_shows], p[0][:all_items], 
          p[0][:genius_track_id], p[0][:smart_info], p[0][:smart_criteria]
        end
      end

      db.prepare(
        "insert into tracks_playlists values ( ?, ? )"
      ) do |stmt|
        @playlists.each do |p|
          p[1].each do |tracks|
            stmt.execute p[0][:playlist_id], tracks
          end
        end
      end
    end
    puts "populate_db: stop  #{Time.now}" if BENCHMARK
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
    puts "parse_xml: start #{Time.now}" if BENCHMARK
    
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

			if line =~ /^\t<key>Playlists<\/key>$/
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
				elsif is_playlists && line =~ /^\t<\/array>$/
					is_playlists = false
					next
        else
          next
        end
      end
    end

    puts "parse_xml: stop  #{Time.now}" if BENCHMARK
  end
  
  def count_artists
    @db.execute("select count(distinct artist) as count from tracks
                  where artist not null and artist != ''")[0].first.to_i
  end
  
  def count_albums
    @db.execute("select count(distinct album) as count from tracks 
                  where album not null and album != ''")[0].first.to_i
  end
  
  def count_tracks
    @db.execute("select count(*) from tracks")[0].first.to_i
  end
  
  def total_time
    human_clock_time( 
      ( @db.execute("select sum(total_time) from tracks 
                    where total_time not null")[0].first.to_i )/1000.00
    )
  end

  def top_artists
    @db.execute("select count(artist) as count, artist from tracks
                  where artist not null
                  group by artist
                  order by count desc").first(@top)
  end

  
  def top_genres
    @db.execute("select count(genre) as count, genre from tracks
                  group by genre order by count desc, genre limit #{@top}")
  end

  def oldest_tracks
    @db.execute("select play_date_utc, name from tracks
                  where play_date_utc not null and play_date_utc != ''
                  order by play_date").first(@top)
  end

  def top_tracks_on_rating_times_playcount
    @db.execute("select rating*play_count as count, name, artist, play_date_utc from tracks 
                  order by count desc").first(@top)
  end

  # Based on work by zenspider @ http://snippets.dzone.com/posts/show/3700 
  def top_tracks_aging_well
    results = []
    now = Time.now
    rating = 0
    records = @db.execute("select rating, play_count, name, artist, play_date_utc from tracks
                            where rating not null and play_count not null and name not null 
                            and artist not null and play_date_utc not null
                            order by rating, play_count")
    records.each do |rec|
      rating = rec[0].to_i * rec[1].to_i * Math.log( ((@now - Time.parse(rec[4])) / 86400.0).to_i )
      results.push([ rating.to_i, rec[2], rec[3], rec[4] ])
    end
    results.sort.reverse.first(@top)
  end
  
  #
  # I don't trust this function yet since it always passes and Scrobbler kicks this error msg
  # /Library/Ruby/Gems/1.8/gems/scrobbler-0.2.0/lib/scrobbler/base.rb:21: warning: instance variable @similar not initialized
  #
  # Works from irb and is way cool!
  #
  #def you_may_like(artist)
  #  artist = Scrobbler::Artist.new(artist)
  #  results = []
  #  artist.similar.each do |a| 
  #    results << [ "#{a.match.dup}", "#{a.name.dup}" ]
  #  end
  #  results.first(@top)
  #end
end

class FileEmptyException < StandardError; end
class FileNotFoundException < StandardError; end
class UnknownDataTypeException < StandardError; end
class NonBooleanValueException < StandardError; end
