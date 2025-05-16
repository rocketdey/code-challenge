#!/usr/bin/env ruby

require 'uri'
require_relative "../lib/parser.rb"

if ARGV.length > 0
  if ARGV[0].downcase == "all"
    all_html_files = Dir["./html/*.html"]
    for doc_path in all_html_files
      puts doc_path
      artworks = Parser.new.extract_data(doc_path)
    end
  else
    artworks = Parser.new.extract_data(ARGV[0])
  end
else
  artworks = Parser.new.extract_data()
end
