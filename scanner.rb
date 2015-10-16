module Scanner

  PIC_URL_REGEX = /url\((.*)\)/

  class << self
    attr_accessor :depth
  end

  def parse_page(page, tag, type, group)
    hrefs = page.search(tag).map do |row|
      name = row.text.sub(/\d*$/, '')
      name = row['title'] if type == 'product'
      pic = take_pic_name(row)
      new_record(type, group, name, pic)
      puts "#{Scanner.depth} DEBUG: Added #{type} from #{group}: #{name}; #{pic}"
      row['href']
    end
    links = hrefs.map { |link| page.link_with(href: link) }
    links
  end

  def scan_main(page)
    Scanner.depth = 0
    parse_page(page, GROUP_TAG, 'group', '-')
  end

  def scan_page(link)
    Scanner.depth += 1
    page = link.click
    group = link.text.delete('0-9')
    subgroups = find_subgroups(page, group)
    if subgroups.empty?
      scan_goods(page, group)
    else
      subgroups.each { |subgroup| scan_page(subgroup) }
    end
    Scanner.depth -= 1
  end

  def find_subgroups(page, group)
    type = 'sub-' * Scanner.depth + 'group'
    subgroups = parse_page(page, SUBGROUP_TAG, type, group)
    subgroups
  end

  def scan_goods(page, group)
    type = 'product'
    parse_page(page, PRODUCT_TAG, type, group)
    puts "DEBUG: SCANNING GOODS"
  end

  def new_record(type, group, name, pic)
  end

  def take_pic_name(row)
    pic_name = File.basename(row['style'].scan(PIC_URL_REGEX).join)
    if pic_name == '' || pic_name == 'no_img_w280h140.png'
      pic_name = '-'
    end
    pic_name
  end
end
