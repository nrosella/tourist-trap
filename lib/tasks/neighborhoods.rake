namespace :neighborhoods do
  require "open-uri"
  require "csv"

  desc "Parses wiki of Manhattan neighborhoods into a csv"
  task manhattan: :environment do
    f = File.open("lib/docs/manhattan-neighborhoods.html")
    doc = Nokogiri::HTML(f)
    neighborhoods = doc.css(".wikitable td a").collect {|elem| elem.text }.uniq
    CSV.open("lib/neighborhoods/manhattan.csv", "wb") do |csv|
      csv << neighborhoods
    end
  end

  desc "Parses wiki of Brooklyn neighborhoods into a csv"
  task brooklyn: :environment do 
    f = File.open("lib/docs/brooklyn-neighborhoods.html")
    doc = Nokogiri::HTML(f)
    neighborhoods = doc.css("#mw-content-text li a").collect{|elem| elem.text}.uniq
    CSV.open("lib/neighborhoods/brooklyn.csv", "wb") do |csv|
      csv << neighborhoods
    end
  end

end
