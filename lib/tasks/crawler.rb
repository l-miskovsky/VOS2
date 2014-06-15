# Crawler & parser
require 'open-uri'
require 'nokogiri'

#na doplnenie potrebneho poctu nul do adresy kvoli formatu tesco URLky
def format_category id
  dlzka=id.length
  id = "0"*(8-dlzka)+id
end

(4..512).each do |id| #kategorie
  id = format_category id.to_s #

  puts "Kategoria: #{id}"
  html = open("http://potravinydomov.itesco.sk/sk-SK/Product/BrowseProducts?taxonomyId=Cat#{id}")
  doc = Nokogiri::HTML(html, nil, 'UTF-8')
  posledna = doc.search('.pagination').search('li').last.text.gsub(/Strana:(?<foo>\d)z\d/, '\k<foo>').to_i

  page=1

  while (page <= posledna) do #pagination v konkretnej kategorii
    puts "Strana: #{page}"
    html2= open("http://potravinydomov.itesco.sk/sk-SK/Product/BrowseProducts?taxonomyID=Cat#{id}&pageNo=#{page}")
    doc2 = Nokogiri::HTML(html2, nil, 'UTF-8')

    doc2.search('.t.product').each do |produkt|

      meno = produkt.search('h2 a').text.gsub('...','')
      cena = produkt.search('.price').text.split(' ')
      platnostDo = produkt.search('.promoUntil').text
      platnostDo.sub!(/.*?(?=\d)/im, '')

      puts meno #\\r ??
      puts cena[0] +' '+ platnostDo[0..-3] #+' '+obchod=Tesco
      puts ''
    end
    page +=1
  end
end
# subject.save
#  end

# Na stahovanie (HTTP)

#https://github.com/taf2/curb
#https://github.com/toland/patron

# Nokogiri (XML & HTML parser)
#http://nokogiri.org/

# Mechanize
#http://mechanize.rubyforge.org/EXAMPLES_rdoc.html

# Queue
#
# sidekiq
#
# https://github.com/mperham/sidekiq/wiki

#(1.1_300_000).each do |id|
#  Sidekiq.enqueue(ParseDocument, id)
#end

#class ParseDocument
#  def perform(id)
#    html = open("http://www.statistics.sk/pls/wregis/detail?wxidorg=#{id}")
#
#    doc = Nokogiri::HTML(html)
#
#    doc.search('.tabid tr').each do |tr|
#      subject = Subject.new
#      tds = tr.search('td')
#      case tds[0].text
#     when 'IČO:' then subject.ico = tds[0].text
#     when 'Obchodné meno:' then subject.name = tds[2].text
#     end

#      subject.save
#    end
#  end
#end
