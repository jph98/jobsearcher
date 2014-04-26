#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

class StarScreamJobParser

   	def get_detail(page, name)
   		page.search("//td[contains(., '" + name + "')]/following-sibling::td").text().strip()
   	end

   	def scrape_page_details(page)

   		job_detail = page.search(".jobText").text
   		puts get_detail(page, "Advertiser")
   		puts get_detail(page, "Contact Name")
   		puts get_detail(page, "Telephone")
   		puts get_detail(page, "Reference")
   		puts get_detail(page, "Salary")
   		puts get_detail(page, "Location")
   		puts get_detail(page, "Job Type")
   		puts get_detail(page, "Date Posted")
   		puts get_detail(page, "Last Updated Date")

   	end

   	def parse_all_jobs_on_page(job_page)

		job_page.links().each do |l|
			if l.attributes["itemprop"] != nil
				puts "Found job: " + l.text
				scrape_page_details(l.click())
				puts "\n"
			end		
		end
   	end

   	def handle_jobs_page(page_number, job_page)

   		puts "Handling job page no. #{page_number}"

		parse_all_jobs_on_page(job_page)

   		next_link = job_page.link_with(:id => "NextPage")

		if (next_link != nil)
			next_page = next_link.click
			page_number = page_number + 1
			handle_jobs_page(page_number, next_page)			
		end
   	end

   	def parse()

   		starscream = Mechanize.new do |agent|
  			agent.user_agent_alias = 'Mac Safari'
		end

		starscream.get('http://www.theitjobboard.co.uk/') do |home_page|

			first_job_page = home_page.form_with(:id => "SearchForm") do |form|
				form["SearchTerms"] = "Java"
				form["LocationSearchTerms"] = "Bristol"
			end.submit

			page_number = 1
			handle_jobs_page(page_number, first_job_page)
		end
	end

end

parser = StarScreamJobParser.new()
parser.parse()