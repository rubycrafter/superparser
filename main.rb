require 'csv'
require 'mechanize'

$CATALOG = 'http://www.a-yabloko.ru/catalog/'
$HEADERS = %w(type group pic name)

page = Mechanize.new.get($CATALOG)
page.search('#catalog-content .children a').each { |link| puts link['href'] }
