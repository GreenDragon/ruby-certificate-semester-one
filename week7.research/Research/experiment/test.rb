#!/usr/bin/ruby -w

require 'base64'

str="AQEBAgAAABkAAAqMAQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="

str2 = 
"U0xzdAABAAEAAAAFAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgAAAABAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEEVCAIMFX9McAAAAAAAAAAAAAAAAAAAAB" +
"EVCAIMFX9McAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAAQAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARBFQgCDBV/TI" +
"AAAAAAAAAAAAAAAAAAAAARFQgCDBV/TIAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAKAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAEQRUIAgwVf0yQAAAAAAAAAAAAAAAAAAAAERUIAgwVf0yQAAAAAAAAAAAAAAAAAA" +
"AAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEEVCAIMFX9MoAAAAAAAAAAAAAAAAAAAABEVCAIMFX" +
"9MoAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAAQAAAAAAAAAA" +
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARBFQgCDBV/TLAAAAAAAA" +
"AAAAAAAAAAAAARFQgCDBV/TLAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAA"

plain = Base64.decode64(str2)

puts plain
