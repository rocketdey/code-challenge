require 'nokogiri'
require 'json'

class Parser

  def load_document(doc_path)
    File.open(doc_path, "r") do |f|
      doc = Nokogiri::HTML(f)
      return doc
    end
  end

  def element_selector(doc)

    elems = doc.xpath("
      //div[starts-with(@data-attrid, 'kc:/')]
        //div
          [@role or @style]
          [not(@role='button') and not(@role='dialog') and not(@role='list')]
          [not(@aria-label)]
          [.//div]
          [not(.//a) or (count(.//a) = 1 and .//a[starts-with(@href, '/search?') and contains(@href, 'sca_esv') and contains(@href, '&ved')])]
          [not(.//img) or (count(.//img) = 1 and .//img[@src='data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='])]")

    main_elems = []
    for div in elems
      if div.element_children.any?
        a_elem = div.at_css("a")
        elem = div
        if a_elem.nil?
          unless div.at_css("div")['id'].nil?
            # "window_html": This is used in different carousels from artworks such as albums and buildings
            window_html = doc.text[%r/\(function\(\){window.jsl.dh\('#{div.css("div")[0]['id']}','(.*?)'\);\}\)\(\);\(function\(\)/m, 1].gsub(/\\x([0-9A-Fa-f]{2})/) { [$1].pack('H2') }
            elem = Nokogiri::HTML(window_html)
            elem = nil if elem.css("a").nil?
          else
            elem = nil
          end
        end

        entity_type = div.xpath("
          ./ancestor::div
            [preceding-sibling::div
              [.//div
                [@aria-level='2']
                [@role='heading']
                [.//span]
              ]
            ][1]
            /preceding-sibling::div
              //span/text()")
        entity_type_sym = entity_type.text.empty? ? :entities : entity_type.text.downcase.to_sym

        main_elems << [entity_type_sym, elem] unless elem.nil?
      end
    end

    return main_elems
  end

  def extract_data(doc_path = "./files/van-gogh-paintings.html")

    doc = load_document(doc_path)
    elems = element_selector(doc)
    main_dict = {}

    for entity_type, elem in elems
      a_elem = elem.at_css("a")
      url = "https://www.google.com" + a_elem['href']

      extensions = elem.xpath(".//div[(not(./*) and text())] | .//div/span[text()]")
      extension_with_title_attr = elem.at_css("[class*='title']")
      name = extension_with_title_attr.nil? ? extensions[0].text : extension_with_title_attr.text
      # 'See more' and 'Show more' can be found in Horizontal Gallery
      next if ['See more', 'Show more'].include?(name)
      unless extensions[1..].nil?
        extension_text_list = extensions[1..].map {|x| x.text}
        extension_text_list.delete(name)
      end
      elem_dict = {
        "name": name,
        "extensions": extension_text_list,
        "link": url
      }

      elem_img = elem.at_css("img")
      unless elem_img.nil?
        if elem_img.has_attribute?('id')
          # This is used to find base64 values from the scripts
          base64 = doc.text[%r/\(function\(\){var s='([^)]*?)';var ii=\['#{elem_img['id']}'\];/m, 1]
          if base64.nil?
            # This is used if the html for the element found in scripts
            base64 = doc.text[%r/"#{elem_img['id']}":"(.*?)"/m, 1].gsub(/\\u003d/, '=').gsub(/\\u0026/, '&')
          else
            # This is used with xxx-songs and when parsing known persons directly (ex: michelangelo)
            base64 = base64.gsub(/\\x([0-9A-Fa-f]{2})/) { [$1].pack('H2') }
          end
          elem_dict[:image] = base64
        else
          elem_dict[:image] = elem_img['data-src'].include?('www.gstatic.com/knowledgecard/') ? '' : elem_img['data-src']
        end
      end

      elem_dict.delete_if {|k,v| v.nil? | v.empty?}
      main_dict[entity_type] = [] unless main_dict.key?(entity_type)
      main_dict[entity_type].append(elem_dict)
    end

    File.open("./output/#{doc_path.match(/\b\/(.*?)\.html/)[1]}.json", 'w') do |f|
      f.write(JSON.pretty_generate(main_dict) + "\n")
    end

    main_dict
  end
end
