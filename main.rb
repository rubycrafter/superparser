require 'mechanize'
load 'scanner.rb'
load 'catalog.rb'

include Scanner

CATALOG_URL = 'http://www.a-yabloko.ru/catalog/'

catalog = Catalog.new('list.txt')

main_page = Mechanize.new.get(CATALOG_URL)
group_links = scan_main(main_page)
group_links.each do |link|
  scan_page(link)
end

catalog.read_catalog(products_array)
catalog.save
