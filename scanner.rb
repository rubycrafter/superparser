load 'statistics.rb'

module Scanner

  GROUP_TAG = '#catalog-content .children a'
  SUBGROUP_TAG = '#content.bar .children a'
  PRODUCT_TAG = '#content.bar .goods .img'

  PIC_URL_REGEX = /url\((.*)'./

  attr_accessor :depth, :products_array, :stats
  
  def parse_page(page, tag, type, group)
    hrefs = page.search(tag).map do |row|
      name = row.text.sub(/\d*$/, '')
      name = row['title'] if type == 'product'
      pic = take_pic_name(row)
      new_record(type, group, name, pic)
      row['href']
    end
    links = hrefs.map { |link| page.link_with(href: link) }
    links
  end

  def scan_main(page)
    @products_array = []
    @stats = Statistics.new
    Scanner.depth = 0
    parse_page(page, GROUP_TAG, 'group', '-')
  end

  def scan_page(link)
    Scanner.depth += 1
    page = link.click
    group = link.text.sub(/\d*$/, '')
    @current_group = group if Scanner.depth == 1
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
  end

  def new_record(type, group, name, pic)
    record = "#{type}\t#{group}\t#{name}\t#{pic}\n"
    @products_array << record
    #puts record #DEBUG
    @stats.total_items += 1
    @stats.items_in_group[@current_group] += 1
    if @stats.total_items == 1000
      @stats.print_statistics
    end
  end

 def take_pic_name(row)
    pic_name = File.basename(row['style'].scan(PIC_URL_REGEX).join)
    if pic_name == '' || pic_name == 'no_img_w280h140.png'
      pic_name = '-'
      @stats.item_without_picture
    else
      @stats.save_pic(pic_name)
      @stats.check_size(pic_name)
    end
    pic_name
  end
end
