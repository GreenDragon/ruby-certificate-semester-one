#!/usr/bin/env ruby -w

$: << 'lib'

require 'test/unit'
require 'grok-itunes'
require 'time'

##
# Student Name: John Howe
# Homework Week: 7
#
#

$testfile = "./ryan.new.itunes.xml"

class TestGrokITunes < Test::Unit::TestCase
  # accelerate read-only tests
  static_data = GrokITunes.new($testfile)
  static_data.parse_xml
  @@static_tracks = static_data.tracks
  @@static_playlists = static_data.playlists
  
  def setup
    @grok = GrokITunes.new($testfile)
    @grok.tracks = @@static_tracks
    @grok.playlists = @@static_playlists
  end

  def test_init_valid_file_no_file
    assert_raise FileNotFoundException do
      @test = GrokITunes.new("./this_missing_file.xml")
    end
  end

  def test_init_valid_file_empty_file
    assert_raise FileEmptyException do
      @test = GrokITunes.new("./empty.xml")
    end
  end

  def test_fix_type_boolean_true
    actual_true = @grok.fix_type("true", "boolean")
    expected_true = true
    assert_equal expected_true, actual_true
    assert_instance_of TrueClass, actual_true
  end

  def test_fix_type_boolean_false
    actual_false = @grok.fix_type("false", "boolean")
    expected_false = false
    assert_equal expected_false, actual_false
    assert_instance_of FalseClass, actual_false
  end

  def test_fix_type_boolean_bogon
    assert_raise NonBooleanValueException do
      actual_bogon = @grok.fix_type("bogon", "boolean")
    end
  end

  def test_fix_type_date
    actual = @grok.fix_type("2008-08-30T19:55:51Z", "date")
    expected = Time.parse("Sat Aug 30 19:55:51 -0700 2008")
    assert_equal expected, actual
    assert_instance_of Time, actual
  end

  def test_fix_type_integer_fixnum
    actual = @grok.fix_type("2", "integer")
    expected = 2
    assert_equal expected, actual
    assert_instance_of Fixnum, actual
  end

  def test_fix_type_integer_bignum
    actual = @grok.fix_type("3310678273", "integer")
    expected = 3310678273
    assert_equal expected, actual
    assert_instance_of Bignum, actual
  end

  def test_fix_type_string
    actual = @grok.fix_type("Test", "string")
    expected = "Test"
    assert_equal expected, actual
    assert_instance_of String, actual
  end

  def test_fix_type_unknown
    assert_raise UnknownDataTypeException do
      actual = @grok.fix_type("<xml>test</xml>", "xml")
    end
  end
  
  def test_human_clock_time_int
    actual = @grok.human_clock_time(276854)
    expected = "003:04:54:14"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_minute
    actual = @grok.human_clock_time(60)
    expected = "000:00:01:00"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_hour
    actual = @grok.human_clock_time(3600)
    expected = "000:01:00:00"
    assert_equal expected, actual
  end
  
  def test_human_clock_time_one_day
    actual = @grok.human_clock_time(86400)
    expected = "001:00:00:00"
    assert_equal expected, actual
  end

  def test_parse_xml_tracks_array_size
    actual = @grok.tracks.size
    expected = 4248
    assert_equal expected, actual
  end
  
  def test_parse_xml_tracks_array_record_66_album
    actual_album = @grok.tracks[66][:album]
    expected_album = "Treasure"
    assert_equal expected_album, actual_album
    assert_instance_of String, actual_album
  end

  def test_parse_xml_tracks_array_record_66_album_artist
    actual_album_artist = @grok.tracks[66][:album_artist]
    expected_album_artist = nil
    assert_equal expected_album_artist, actual_album_artist
    # assert_instance_of String, actual_album_artist
  end

  def test_parse_xml_tracks_array_record_66_album_rating
    actual_album_rating = @grok.tracks[66][:album_rating]
    expected_album_rating = 80
    assert_equal expected_album_rating, actual_album_rating
    assert_instance_of Fixnum, actual_album_rating
  end

  def test_parse_xml_tracks_array_record_66_album_rating_computed
    actual_album_rating_computed = @grok.tracks[66][:album_rating_computed]
    expected_album_rating_computed = true
    assert_equal expected_album_rating_computed, actual_album_rating_computed
    assert_instance_of TrueClass, actual_album_rating_computed
  end

  def test_parse_xml_tracks_array_record_66_artist
    actual_artist = @grok.tracks[66][:artist]
    expected_artist = "Cocteau Twins"
    assert_equal expected_artist, actual_artist
    assert_instance_of String, actual_artist
  end

  def test_parse_xml_tracks_array_record_66_artwork_count
    actual_artwork_count = @grok.tracks[66][:artwork_count]
    expected_artwork_count = 1
    assert_equal expected_artwork_count, actual_artwork_count
    assert_instance_of Fixnum, actual_artwork_count
  end

  def test_parse_xml_tracks_array_record_66_bit_rate
    actual_bit_rate = @grok.tracks[66][:bit_rate]
    expected_bit_rate = 128
    assert_equal expected_bit_rate, actual_bit_rate
    assert_instance_of Fixnum, actual_bit_rate
  end

  def test_parse_xml_tracks_array_record_66_composer
    actual_composer = @grok.tracks[66][:composer]
    expected_composer = "Cocteau Twins"
    assert_equal expected_composer, actual_composer
    assert_instance_of String, actual_composer
  end

  def test_parse_xml_tracks_array_record_66_date_added
    actual_date_added = @grok.tracks[66][:date_added]
    expected_date_added = Time.parse("Wed Jul 17 20:41:10 -0700 2002")
    assert_equal expected_date_added, actual_date_added
    assert_instance_of Time, actual_date_added
  end

  def test_parse_xml_tracks_array_record_66_date_modified
    actual_date_modified = @grok.tracks[66][:date_modified]
    expected_date_modified = Time.parse("Tue Oct 18 17:03:07 -0700 2005")
    assert_equal expected_date_modified, actual_date_modified
    assert_instance_of Time, actual_date_modified
  end

  def test_parse_xml_tracks_array_record_66_disc_count
    actual_disc_count = @grok.tracks[66][:disc_count]
    expected_disc_count = 1
    assert_equal expected_disc_count, actual_disc_count
    assert_instance_of Fixnum, actual_disc_count
  end

  def test_parse_xml_tracks_array_record_66_disc_number
    actual_disc_number = @grok.tracks[66][:disc_number]
    expected_disc_number = 1
    assert_equal expected_disc_number, actual_disc_number
    assert_instance_of Fixnum, actual_disc_number
  end

  def test_parse_xml_tracks_array_record_66_file_creator
    actual_file_creator = @grok.tracks[66][:file_creator]
    expected_file_creator = nil
    assert_equal expected_file_creator, actual_file_creator
  end

  def test_parse_xml_tracks_array_record_66_file_folder_count
    actual_file_folder_count = @grok.tracks[66][:file_folder_count]
    expected_file_folder_count = 4
    assert_equal expected_file_folder_count, actual_file_folder_count
    assert_instance_of Fixnum, actual_file_folder_count
  end

  def test_parse_xml_tracks_array_record_66_genre
    actual_genre = @grok.tracks[66][:genre]
    expected_genre = "Goth"
    assert_equal expected_genre, actual_genre
    assert_instance_of String, actual_genre
  end

  def test_parse_xml_tracks_array_record_66_kind
    actual_kind = @grok.tracks[66][:kind]
    expected_kind = "AAC audio file"
    assert_equal expected_kind, actual_kind
    assert_instance_of String, actual_kind
  end

  def test_parse_xml_tracks_array_record_66_library_folder_count
    actual_library_folder_count = @grok.tracks[66][:library_folder_count]
    expected_library_folder_count = 1
    assert_equal expected_library_folder_count, actual_library_folder_count
    assert_instance_of Fixnum, actual_library_folder_count
  end

  def test_parse_xml_tracks_array_record_66_location
    actual_location = @grok.tracks[66][:location]
    expected_location = "file://localhost/Users/ryan/Music/iTunes/iTunes%20Music/Cocteau%20Twins/Treasure/01%20Ivo.m4a"
    assert_equal expected_location, actual_location
    assert_instance_of String, actual_location
  end

  def test_parse_xml_tracks_array_record_66_name
    actual_name = @grok.tracks[66][:name]
    expected_name = "Ivo"
    assert_equal expected_name, actual_name
    assert_instance_of String, actual_name
  end

  def test_parse_xml_tracks_array_record_66_persistent_id
    actual_persistent_id = @grok.tracks[66][:persistent_id]
    expected_persistent_id = "3CF1F47A0CA8D0B1"
    assert_equal expected_persistent_id, actual_persistent_id
    assert_instance_of String, actual_persistent_id
  end

  def test_parse_xml_tracks_array_record_66_play_count
    actual_play_count = @grok.tracks[66][:play_count]
    expected_play_count = 41
    assert_equal expected_play_count, actual_play_count
    assert_instance_of Fixnum, actual_play_count
  end

  def test_parse_xml_tracks_array_record_66_play_date
    actual_play_date = @grok.tracks[66][:play_date]
    expected_play_date = 3309728375
    assert_equal expected_play_date, actual_play_date
    assert_instance_of Bignum, actual_play_date
  end

  def test_parse_xml_tracks_array_record_66_play_date_utc
    actual_play_date_utc = @grok.tracks[66][:play_date_utc]
    expected_play_date_utc = Time.parse("Fri Nov 17 08:59:35 -0800 2008")
    assert_equal expected_play_date_utc, actual_play_date_utc
    assert_instance_of Time, actual_play_date_utc
  end

  def test_parse_xml_tracks_array_record_66_purchased
    actual_purchased = @grok.tracks[66][:purchased]
    expected_purchased = nil
    assert_equal expected_purchased, actual_purchased
  end

  def test_parse_xml_tracks_array_record_66_rating
    actual_rating = @grok.tracks[66][:rating]
    expected_rating = 100
    assert_equal expected_rating, actual_rating
    assert_instance_of Fixnum, actual_rating
  end

  def test_parse_xml_tracks_array_record_66_release_date
    actual_release_date = @grok.tracks[66][:release_date]
    expected_release_date = nil
    assert_equal expected_release_date, actual_release_date
  end

  def test_parse_xml_tracks_array_record_66_sample_rate
    actual_sample_rate = @grok.tracks[66][:sample_rate]
    expected_sample_rate = 44100
    assert_equal expected_sample_rate, actual_sample_rate
    assert_instance_of Fixnum, actual_sample_rate
  end

  def test_parse_xml_tracks_array_record_66_size
    actual_size = @grok.tracks[66][:size]
    expected_size = 3934305
    assert_equal expected_size, actual_size
    assert_instance_of Fixnum, actual_size
  end

  def test_parse_xml_tracks_array_record_66_total_time
    actual_total_time = @grok.tracks[66][:total_time]
    expected_total_time = 233266
    assert_equal expected_total_time, actual_total_time
    assert_instance_of Fixnum, actual_total_time
  end

  def test_parse_xml_tracks_array_record_66_track_count
    actual_track_count = @grok.tracks[66][:track_count]
    expected_track_count = 10
    assert_equal expected_track_count, actual_track_count
    assert_instance_of Fixnum, actual_track_count
  end

  def test_parse_xml_tracks_array_record_66_track_id
    actual_track_id = @grok.tracks[66][:track_id]
    expected_track_id = 1045
    assert_equal expected_track_id, actual_track_id
    assert_instance_of Fixnum, actual_track_id
  end

  def test_parse_xml_tracks_array_record_66_track_number
    actual_track_number = @grok.tracks[66][:track_number]
    expected_track_number = 1
    assert_equal expected_track_number, actual_track_number
    assert_instance_of Fixnum, actual_track_number
  end

  def test_parse_xml_tracks_array_record_66_track_type
    actual_track_type = @grok.tracks[66][:track_type]
    expected_track_type = "File"
    assert_equal expected_track_type, actual_track_type
    assert_instance_of String, actual_track_type
  end

  def test_parse_xml_tracks_array_record_66_year
    actual_year = @grok.tracks[66][:year]
    expected_year = 1984
    assert_equal expected_year, actual_year
    assert_instance_of Fixnum, actual_year
  end

  # Playlist tests

  def test_parse_xml_playlists_array_size
    actual = @grok.playlists.size
    expected = 40
    assert_equal expected, actual
  end

  def test_parse_xml_playlists_genius_all_items
    actual_all_items = @grok.playlists[8][0][:all_items]
    expected_all_items = true
    assert_equal expected_all_items, actual_all_items
    assert_instance_of TrueClass, actual_all_items
  end
  
  def test_parse_xml_playlists_genius_distinguished_kind
    actual = @grok.playlists[8][0][:distinguished_kind]
    expected = 26
    assert_equal expected, actual
    assert_kind_of Fixnum, actual
  end

  def test_parse_xml_playlists_genius_genius_track_id
    actual = @grok.playlists[8][0][:genius_track_id]
    expected = 5381
    assert_equal expected, actual
    assert_instance_of Fixnum, actual
  end

  def test_parse_xml_playlists_genius_name
    actual_name = @grok.playlists[8][0][:name]
    expected_name = "Genius"
    assert_equal expected_name, actual_name
    assert_instance_of String, actual_name
  end
  
  def test_parse_xml_playlists_genious_playlist_id
    actual_playlist_id = @grok.playlists[8][0][:playlist_id]
    expected_playlist_id = 31144
    assert_equal expected_playlist_id, actual_playlist_id
    assert_instance_of Fixnum, actual_playlist_id
  end

  def test_parse_xml_playlists_genius_playlist_persistent_id
    actual_persistent_id = @grok.playlists[8][0][:playlist_persistent_id]
    expected_persistent_id = "AFBA9D1CC404A519"
    assert_equal expected_persistent_id, actual_persistent_id
    assert_instance_of String, actual_persistent_id
  end
  
  def test_parse_xml_playlists_genius_playlists
    actual_playlist_items = @grok.playlists[8][1]
    expected_playlist_items = [
      5381,3037,2633,3367,4213,3397,2949,1047,5677,6793,5345,1795,8921,2349,6361,
      3063,5371,3829,1775,953,1043,2631,6831,7083,2023,1767,5391,7897,4857,5973,
      4935,995,5357,5377,5491,8231,3047,3067,1889,8207,6835,7459,945,3041,2343,
      2025,5769,7249,1007,1273
    ]
    assert_equal expected_playlist_items, actual_playlist_items
    assert_instance_of Array, actual_playlist_items
  end

  # Specification requirements

  def test_artist_count
    actual = @grok.count_thing(:artist)
    expected = 247
    assert_equal expected, actual
  end

  def test_count_thing_album_count
    actual = @grok.count_thing(:album)
    expected = 397
    assert_equal expected, actual
  end

  def test_count_tracks
    actual = @grok.count_tracks
    expected = 4248
    assert_equal expected, actual
  end

  def test_total_playtime
    actual = @grok.total_time
    expected = "014:06:27:51"
    assert_equal expected, actual
  end

  def test_top_field_artists
    actual = @grok.top_thing(:artist)
    expected = [
      ["Nine Inch Nails", 149],
      ["Depeche Mode", 139],
      ["The Cure", 129],
      ["Siouxsie &#38; the Banshees", 120],
      ["New Model Army", 95],
      ["The Police", 89],
      ["Cocteau Twins", 88],
      ["Peter Murphy", 84],
      ["DJ Krush", 81],
      ["Bauhaus", 77]
    ]
    assert_equal expected, actual
  end

  def test_top_field_genres
    actual = @grok.top_thing(:genre)
    expected = [
      ["Alternative", 1433],
      ["Goth", 727],
      ["Electronic", 640],
      ["Industrial", 525],
      ["Rock", 407],
      ["Punk", 222],
      ["World", 67],
      ["Podcast", 60],
      ["Soundtrack", 40],
      ["New Age", 38]
    ]
    assert_equal expected, actual
  end
  
  def test_top_tracks_on_rating_times_playcount
    actual = @grok.top_tracks_on_rating_times_playcount
    expected = [
      [8000, "Carnage Visors", "The Cure", 
        Time.parse("Wed Sep 17 12:10:59 -0700 2008")],
      [6640, "Future Proof", "Massive Attack", 
        Time.parse("Thu Oct 02 05:57:15 -0700 2008")],
      [6500, "Group Four", "Massive Attack", 
        Time.parse("Wed Sep 17 18:54:47 -0700 2008")],
      [6400, "Teardrop", "Massive Attack", 
        Time.parse("Thu Oct 23 05:57:05 -0700 2008")],
      [6000, "Angel", "Massive Attack", 
        Time.parse("Tue Oct 07 12:51:24 -0700 2008")],
      [5800, "Special Cases", "Massive Attack", 
        Time.parse("Mon Oct 06 17:01:13 -0700 2008")],
      [5600, "Inertia Creeps", "Massive Attack", 
        Time.parse("Thu Oct 23 07:16:22 -0700 2008")],
      [5500, "Dissolved Girl", "Massive Attack", 
        Time.parse("Mon Oct 06 16:15:23 -0700 2008")],
      [5300, "No New Tale To Tell", "Love &#38; Rockets", 
        Time.parse("Mon Nov 03 01:48:38 -0800 2008")],
      [5100, "Risingson", "Massive Attack", 
        Time.parse("Sat Oct 18 08:53:14 -0700 2008")]
    ]
    assert_equal expected, actual
  end
  
  def test_oldest_tracks
    actual = @grok.oldest_tracks
    expected = [
      [Time.parse("Thu Aug 15 18:14:03 -0700 2002"), "Introduction"],
      [Time.parse("Thu Nov 13 19:26:53 -0800 2003"), "Segue: Ramona A. Stone/I Am With Name"],
      [Time.parse("Tue Dec 23 08:02:11 -0800 2003"), "Mother / Oh Mein Pa Pa"],
      [Time.parse("Tue Dec 23 08:59:40 -0800 2003"), "Shame"],
      [Time.parse("Fri Feb 27 18:45:22 -0800 2004"), "Fourteen"],
      [Time.parse("Mon Mar 22 04:31:04 -0800 2004"), "To Have And To Hold"],
      [Time.parse("Tue Apr 20 06:52:50 -0700 2004"), "Over And Out"],
      [Time.parse("Thu May 06 03:23:40 -0700 2004"), "The Theft"],
      [Time.parse("Tue Jun 08 10:32:05 -0700 2004"), "Sins Of The Fathers"],
      [Time.parse("Fri Jul 02 23:01:19 -0700 2004"), "Back On Earth"]
    ]
    assert_equal expected, actual
  end
  
  def test_top_tracks_aging_well
    @grok.now = Time.parse("Tue Dec 09 18:00:00 -0800 2008")
    actual = @grok.top_tracks_aging_well
    expected = [
      [35350,"Carnage Visors","The Cure",
        Time.parse("Wed Sep 17 12:10:59 -0700 2008")],
      [28722,"Group Four","Massive Attack",
        Time.parse("Wed Sep 17 18:54:47 -0700 2008")],
      [28017,"Future Proof","Massive Attack",
        Time.parse("Thu Oct 02 05:57:15 -0700 2008")],
      [24858,"Angel","Massive Attack",
        Time.parse("Tue Oct 07 12:51:24 -0700 2008")],
      [24640,"Teardrop","Massive Attack",
        Time.parse("Thu Oct 23 05:57:05 -0700 2008")],
      [24121,"Special Cases","Massive Attack",
        Time.parse("Mon Oct 06 17:01:13 -0700 2008")],
      [22873,"Dissolved Girl","Massive Attack",
        Time.parse("Mon Oct 06 16:15:23 -0700 2008")],
      [21560,"Inertia Creeps","Massive Attack",
        Time.parse("Thu Oct 23 07:16:22 -0700 2008")],
      [20794,"One Hundred Years","The Cure",
        Time.parse("Mon Oct 06 10:56:13 -0700 2008")],
      [20715,"A Prayer For England","Massive Attack",
        Time.parse("Tue Oct 07 15:00:18 -0700 2008")]
    ]
    assert_equal expected, actual
  end

end
