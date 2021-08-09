require 'open-uri'


# METHODS 
def formatExtraction(element)
    return element&.text&.strip&.gsub("\t", "")&.gsub("\n", "")&.downcase
end

def scrapper_beers_service(url)
    beers_html = URI.open(url).read
    beers_doc = Nokogiri::HTML(beers_html)
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
brewers_html = URI.open(brewers_website_scrapping_url).read
brewers_doc = Nokogiri::HTML(brewers_html)
counter_brewers = 0
brewers_doc.search('#table1 tr').each do |element|
    counter_brewers += 1
    if counter_brewers > 1
        brewer_name = formatExtraction(element.search('td').first)&.delete_prefix("de ")&.delete_prefix("du ")
        brewer_city = formatExtraction(element.search('td')[2])
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

puts 'Seed done with success !'
