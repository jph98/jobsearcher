#!/usr/bin/env ruby

require 'nokogiri'
require 'mechanize'
require 'digest/sha1'

class ITJobBoard

   	def get_detail(page, name)
   		page.search("//td[contains(., '" + name + "')]/following-sibling::td").text().strip()
   	end

   	def persist_job_details()
   		# TODO
   	end

   	def scrape_page_details(page)

   		job_details = page.search(".jobText").text
   		advertiser = get_detail(page, "Advertiser")
   		contact_name = get_detail(page, "Contact Name")
   		telephone = get_detail(page, "Telephone")
   		reference = get_detail(page, "Reference")
   		salary = get_detail(page, "Salary")
   		location = get_detail(page, "Location")
   		job_type = get_detail(page, "Job Type")
   		date_posted = get_detail(page, "Date Posted")
   		last_updated_date = get_detail(page, "Last Updated Date")

   		hashed_content = Digest::SHA1.hexdigest job_details 
   		
   		persist_job_details()
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

   	def parse(skill, location)

   		parser = Mechanize.new do |agent|
  			agent.user_agent_alias = 'Mac Safari'
		end

		site_source = 'http://www.theitjobboard.co.uk/'

		parser.get(site_source) do |home_page|

			first_job_page = home_page.form_with(:id => "SearchForm") do |form|
				form["SearchTerms"] = skill
				form["LocationSearchTerms"] = location
			end.submit

			page_number = 1
			handle_jobs_page(page_number, first_job_page)
		end
	end

end

parser = ITJobBoard.new()
parser.parse("Java", "Bristol")