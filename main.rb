require 'csv'
require 'mechanize'
load 'statistics.rb'
load 'page.rb'
load 'scanner.rb'

include Scanner

CATALOG = 'http://www.a-yabloko.ru/catalog/'
HEADERS = %w(type group pic name)
GROUP_TAG = '#catalog-content .children a'
SUBGROUP_TAG = '#content.bar .children a'
PRODICT_TAG = '#content.bar h1 div.goods .img'
STATISTICS = Statistics.new

page = Mechanize.new.get(CATALOG)

group_links = scan_main(page)

group_links.each do |link|
  scan_page(link)
end

#group_links = page.search(GROUP_TAG).map { |link| link['href'] }

#groups = group_links.map { |link| page.link_with(href: link).click }
