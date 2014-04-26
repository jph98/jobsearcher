#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

class JobParser

	attr_accessor :match

	def initialize()    
		@baseurl = "http://www.cwjobs.co.uk"
   	end

	# Parse football fixtures/results
   	def parse()
   		a = Mechanize.new { |agent|
  			agent.user_agent_alias = 'Mac Safari'
		}

		a.get('http://google.com/') do |page|

		  search_result = page.form_with(:name => 'f') do |search|
		    search.q = 'Hello world'
		  end.submit

		  search_result.links.each do |link|
		    puts link.text
		  end
		  
		end
	end

end

parser = JobParser.new()
parser.parse()