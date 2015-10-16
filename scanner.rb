module Scanner
  def scan_main(page)
    group_row = page.search(GROUP_TAG).map do |row| 
      name = row.text.delete('0-9')
      pic = File.basename(row['style'].scan(/url\((.*)\)/).join) || '-'
      new_record('group', '-', name, pic)
      row['href']
    end
    group_links = group_row.map { |link| page.link_with(href: link) }
    group_links 
  end

  def new_record(type, group, name, pic)

  end
end
