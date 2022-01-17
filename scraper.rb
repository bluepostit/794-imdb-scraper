# fetch_movie_urls
require 'nokogiri'
require 'open-uri'

def fetch_movie_urls
  # open the url for the top 250 movies
  # download it, save as variable
  # convert to Nokogiri HTML doc
  # search the document for all movie links
  # get the first 5 of them
  # return the array

  url = 'https://www.imdb.com/chart/top'
  html =  URI.open(url).read
  doc = Nokogiri::HTML(html)
  doc.search('.titleColumn a')[0..4].map do |link|
    "https://www.imdb.com#{link.attributes['href'].value}"
  end
end

def scrape_movie(url)
  # open the given url
  # download it, save as variable
  # convert to Nokogiri HTML doc
  # create a hash for the info
  # search the document for each required value (name, director, etc.)
  # add each one to the hash
  # return the hash

  html =  URI.open(url).read
  doc = Nokogiri::HTML(html)

  title = doc.search('h1').text
  year = doc.search('.TitleBlockMetaData__ListItemText-sc-12ein40-2').first.text.to_i
  storyline = doc.search('.GenresAndPlot__TextContainerBreakpointXS_TO_M-sc-cum89p-0.kHlJyu').text
  director = doc.search('.ipc-metadata-list__item:contains("Director") a').first.text
  cast = doc.search('.ipc-metadata-list__item:contains("Stars") a.ipc-metadata-list-item__list-content-item')
    .map { |item| item.text }.uniq

  {
    title: title,
    year: year,
    storyline: storyline,
    director: director,
    cast: cast
  }
end
