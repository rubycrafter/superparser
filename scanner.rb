module Scanner
  class << self
    attr_accessor :depth
  end

  def parse(page, tag, type, group)
    row = page.search(tag).map do |row| 
      name = row.text.delete('0-9')
      pic = File.basename(row['style'].scan(/url\((.*)\)/).join) || '-'
      new_record(type, group, name, pic)
      print 'DEBUG: Scanning ', group, '; subgroups: ', name, "\n"
      row['href']
    end
    links = row.map { |link| page.link_with(href: link) }
    links
  end

  def scan_main(page)
    Scanner.depth = 0
    parse(page, GROUP_TAG, 'group', '-')    
  end

  def scan_page(link)
    Scanner.depth
    page = link.click
    group = link.text.delete('0-9')
    subgroups = find_subgroups(page, group)
    if subgroups.empty?
      scan_goods(link, group)
    else
      subgroups.each { |subgroup| scan_page(subgroup) }
    end
  end

  def find_subgroups(link, group)
    type = 'sub-' * Scanner.depth + 'group'
    subgroups = parse(link, SUBGROUP_TAG, type, group)
  end

  def scan_goods(link, group)
    
  end

  def new_record(type, group, name, pic)

  end
end
