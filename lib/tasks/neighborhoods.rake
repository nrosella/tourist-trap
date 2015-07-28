namespace :neighborhoods do
  desc "Parses wiki of Manhattan neighborhoods into a csv"
  task manhattan: :environment do
    require "open-uri"
    require "csv"

    f = File.open("lib/docs/manhattan-neighborhoods.html")
    doc = Nokogiri::HTML(f)
    neighborhoods = doc.css(".wikitable td a").collect {|elem| elem.text }.uniq

    CSV.open("lib/neighborhoods/manhattan.csv", "wb") do |csv|
      csv << neighborhoods
    end
  end

end
