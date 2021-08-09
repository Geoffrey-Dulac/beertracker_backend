# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

Brewer.destroy_all
puts 'Brewer all destroyed !'

brewers_website_scrapping_url = 'http://projet.amertume.free.fr/html/liste_brasseries.htm'
brewers_html = URI.open(brewers_website_scrapping_url).read
brewers_doc = Nokogiri::HTML(brewers_html)
counter = 0
puts 'Seeding brewers...'
brewers_doc.search('#table1 tr').each do |element|
    counter += 1
    if counter > 1
        brewer_name = element.search('td').first.text.strip.gsub("\t", "").gsub("\n", "").downcase.delete_prefix("de ").delete_prefix("du ")
        brewer_city = element.search('td')[2].text.strip.gsub("\t", "").gsub("\n", "").downcase
        brewer_country = 'france'
        Brewer.new(name: brewer_name, city: brewer_city, country: brewer_country).save!
    end
end