require 'csv'
require 'mechanize'

CATALOG = 'http://www.a-yabloko.ru/catalog/'
HEADERS = %w(type group pic name)
GROUP_TAG = '#catalog-content .children a'
SUBGROUP_TAG = ''
PRODICT_TAG = ''

page = Mechanize.new.get($CATALOG)

group_links = page.search('#catalog-content .children a').map { |link| link.['href'] }

groups = group_links.map { |link| page.link_with(href: link).click }
