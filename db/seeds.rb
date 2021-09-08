require 'open-uri'
require 'bcrypt'
require 'nokogiri'


# METHODS 
def formatExtraction(element)
    return element&.text&.strip&.gsub("\t", "")&.gsub("\n", "")&.downcase
end

def scrapper_beers_service(url)
    beers_doc = Nokogiri::HTML(URI.open(url))
    counter_beers = 0
    beers_doc.search('tr').each do |element|
        counter_beers += 1
        if counter_beers > 4
            beer_name = formatExtraction(element.search('td')[2])
            beer_brewer_name = formatExtraction(element.search('td')[3])
            beer_degrees = formatExtraction(element.search('td')[4])&.gsub(',', '.')&.to_f
            beer_type = formatExtraction(element.search('td')[5])
            beer_country = formatExtraction(element.search('td')[8])
            if beer_country === 'france'
                newBeer = Beer.find_or_create_by(name: beer_name)
                newBeer.degrees = beer_degrees
                newBeer.kind = beer_type
                if Brewer.where(name: beer_brewer_name).blank?
                    newBreewer = Brewer.new(name: beer_brewer_name)
                    newBreewer.save!
                    newBeer.brewer = newBreewer;
                else 
                    newBeer.brewer = Brewer.where(name: beer_brewer_name).first
                end
                newBeer.save!
            end
        end
    end
end


# BREWERIES SEEDING 
Brewer.destroy_all
puts 'Brewers all destroyed !'
puts 'Seeding breweries...'
brewers_website_scrapping_url = 'http://projet.amertume.free.fr/html/liste_brasseries.htm'
brewers_doc = Nokogiri::HTML(URI.open(brewers_website_scrapping_url))
counter_brewers = 0
brewers_doc.search('#table1 tr').each do |element|
    counter_brewers += 1
    if counter_brewers > 1
        brewer_name = formatExtraction(element.search('td').first)&.delete_prefix("de ")&.delete_prefix("du ") || ''
        brewer_city = formatExtraction(element.search('td')[2]) || ''
        brewer_country = 'france'
        newBrewer = Brewer.find_or_create_by(name: brewer_name)
        newBrewer.city = brewer_city
        newBrewer.country = brewer_country
        newBrewer.save!
    end
end


# BEERS SEEDING 
Beer.destroy_all
puts 'Beers all destroyed !'
puts 'Seeding beers...'
scrapper_beers_service("http://projet.amertume.free.fr/html/listing.htm")
scrapper_beers_service("http://projet.amertume.free.fr/html/listing_chiffres.htm")
('b'..'z').to_a.each do |letter|
    scrapper_beers_service("http://projet.amertume.free.fr/html/listing_#{letter}.htm")
end


# USER SEEDING
User.destroy_all
puts 'Users all destroyed !'
puts 'Seeding users...'
User.create(username: 'geoffrey', email: 'geoffrey@yopmail.com', password: BCrypt::Password.create('azerty'))


# USER_BEERS SEEDING
UserBeer.destroy_all
puts 'UserBeers all destroyed !'
puts 'Seeding userbeers...'
user = User.find(1)
beer1 = Beer.find(1)
beer2 = Beer.find(2)
beer3 = Beer.find(3)
beer4 = Beer.find(4)
userbeer1 = UserBeer.new(user_grade: 8)
userbeer2 = UserBeer.new(user_grade: 4)
userbeer3 = UserBeer.new(user_grade: 5)
userbeer4 = UserBeer.new(user_grade: 7)
userbeer1.user = user
userbeer2.user = user
userbeer3.user = user
userbeer4.user = user
userbeer1.beer = beer1
userbeer2.beer = beer2
userbeer3.beer = beer3
userbeer4.beer = beer4
userbeer1.save!
userbeer2.save!
userbeer3.save!
userbeer4.save!



puts 'Seed done with success !'
