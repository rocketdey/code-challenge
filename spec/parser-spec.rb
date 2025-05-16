require "json"

require_relative "../lib/parser"

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) } #This ignores the $stdout from the parser
end

module TestHelpers

  def validate_name(entity_list, index, name)
    expect(entity_list[index][:name].is_a?(String)).to eq(true)
    expect(entity_list[index][:name].empty?).to eq(false)
    expect(entity_list[index][:name]).to eq(name)
  end

  def validate_extension(entity_list, index, extension)
    expect(entity_list[index].key?(:extensions)).to eq(true)
    expect(entity_list[index][:extensions].is_a?(Array)).to eq(true)
    expect(entity_list[index][:extensions].empty?).to eq(false)
    expect(entity_list[index][:extensions]).to eq(extension)
  end

  def validate_link(entity_list, index, link)
    expect(entity_list[index][:link].is_a?(String)).to eq(true)
    expect(entity_list[index][:link].empty?).to eq(false)
    expect(entity_list[index][:link]).to eq(link)
  end

  def validate_image_base64(entity_list, index, image_length)
    expect(entity_list[index][:image].is_a?(String)).to eq(true)
    expect(entity_list[index][:image].empty?).to eq(false)
    expect(entity_list[index][:image].start_with?("data:image/jpeg;base64")).to eq(true)
    expect(entity_list[index][:image].length).to eq(image_length)
  end

  def validate_image_link(entity_list, index, image_link)
    expect(entity_list[index][:image].is_a?(String)).to eq(true)
    expect(entity_list[index][:image].empty?).to eq(false)
    expect(entity_list[index][:image]).to eq(image_link)
  end

end

RSpec.describe Parser do
  include TestHelpers
  let(:parser) {described_class.new}

  # Carousel Form
  context "van-gogh-paintings" do

    before do
      @main_dict = parser.extract_data()
      @entities = @main_dict[:artworks]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:artworks])
    end

    it "validates the count of artworks found" do
      expect(@entities.length).to eq(47)
    end


    it "validates if the 'parsed-array' is the same with 'expected-array'" do

      File.open('./files/expected-array.json', 'r') do |f|
        @expected_array = f.read()
      end

      File.open('./files/van-gogh-paintings.json', 'r') do |f|
        @parsed_array = f.read()
      end

      expect(@expected_array).to eq(@parsed_array)
    end


    it "validates the first artwork parsed" do
      index = 0
      validate_name(@entities, index, "The Starry Night")
      validate_extension(@entities, index, ["1889"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD")
      validate_image_base64(@entities, index, 16319)
    end

    it "validates an 'image' key that doesn't have base64 data value" do
      index = -1
      validate_name(@entities, index, "Poppy Flowers")
      validate_extension(@entities, index, ["1887"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Poppy+Flowers&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArGSi5Kzy6u0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWHkD8gsKKhXccvLLU4uKAQyfeGpMAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxBf")
      validate_image_link(@entities, index, "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS2LVpFl1El_E_rM0m2zP-Ye87b4X4mO6YwfH4dCp75iphy9tD8")
    end

    it "validates an artwork that shouldn't have the 'extensions' key" do
      index = -13
      validate_name(@entities, index, "Vase with Cornflowers and Poppies")
      expect(@entities[index].keys).to include(:name, :link, :image)
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Vase+with+Cornflowers+and+Poppies&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLi1U_XNzRMMksuT8-qyNFSyk620i_LLC5NzIlPLCpBYmYWl1iV5xdlFy9iVQxLLE5VKM8syVBwzi_KS8vJL08tKlZIzEtRCMgvKMhMLQYAwRWIIWMAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxBH")
      validate_image_link(@entities, index, "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSH-MW0OUaQuQnAfIbNb4Iff8MzOo8phqrvxDwcCYtu93Uky6J8")
    end
  end


  # Carousel Form
  context 'sandro-botticelli-artwork' do

    before do
      @main_dict = parser.extract_data('./files/sandro-botticelli-artwork.html')
      @entities = @main_dict[:artworks]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:artworks])
    end

    it "validates the count of artworks found" do
      expect(@entities.length).to eq(49)
    end


    it "validates the first artwork parsed" do
      index = 0
      validate_name(@entities, index, "The birth of Venus")
      validate_extension(@entities, index, ["1486"])
      validate_link(@entities, index, "https://www.google.com/search?sa=X&sca_esv=e882f0976fe7340d&biw=1440&bih=827&q=The+birth+of+Venus&stick=H4sIAAAAAAAAAONgFuLQz9U3yCoyTlcCs3KzSjK0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWIVCMlIVkjKLSjIU8tMUwlLzSosBdQuqVU8AAAA&ved=2ahUKEwj8sdfZifSMAxXqRfEDHemOExEQtq8DegQIMxAD")
      validate_image_base64(@entities, index, 12103)
    end


    it "validates an 'image' key that doesn't have base64 data value" do
      index = -2
      validate_name(@entities, index, "Drawings for Dante´s Divine Comedy")
      validate_extension(@entities, index, ["1495"])
      validate_link(@entities, index, "https://www.google.com/search?sa=X&sca_esv=e882f0976fe7340d&biw=1440&bih=827&q=Drawings+for+Dante%C2%B4s+Divine+Comedy&stick=H4sIAAAAAAAAAONgFuLQz9U3yCoyTlfi1U_XNzRMLi4yzjAwtdRSyk620i_LLC5NzIlPLCpBYmYWl1iV5xdlFy9iVXYpSizPzEsvVkjLL1JwScwrST20pVjBJbMsMy9VwTk_NzWlEgDDEZoNZQAAAA&ved=2ahUKEwj8sdfZifSMAxXqRfEDHemOExEQtq8DegQIMxBh")
      validate_image_link(@entities, index, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAZx9NQr6qOVVUbFF38yjn7yaxeWhirHVq-CC0RcjEfKyNCtO4")
    end
    

    it "validates an artwork that shouldn't have the 'extensions' key" do
      index = -1
      validate_name(@entities, index, "Man of Sorrows")
      expect(@entities[index].keys).to include(:name, :link, :image)
      validate_link(@entities, index, "https://www.google.com/search?sa=X&sca_esv=e882f0976fe7340d&biw=1440&bih=827&q=Man+of+Sorrows&stick=H4sIAAAAAAAAAONgFuLQz9U3yCoyTlfi1U_XNzQsKDcqLrAwz9FSyk620i_LLC5NzIlPLCpBYmYWl1iV5xdlFy9i5fNNzFPIT1MIzi8qyi8vBgAd7yfsUAAAAA&ved=2ahUKEwj8sdfZifSMAxXqRfEDHemOExEQtq8DegQIMxBj")
      validate_image_link(@entities, index, "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQcfIflbfmwJBykkip-4CBxKsPq4umFnjPtOddaM-gHslVYoS1v")
    end
  end


  # Grid Form
  context 'metallica-albums' do

    before do
      @main_dict = parser.extract_data('./files/metallica-albums.html')
      @entities = @main_dict[:albums]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:albums])
    end

    it "validates the count of artworks found" do
      expect(@entities.length).to eq(28)
    end


    it "validates the first artwork parsed" do
      index = 0
      validate_name(@entities, index, "Master of Puppets")
      validate_extension(@entities, index, ["1986"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=6ff89c181547cd34&cs=1&biw=1440&bih=827&q=Metallica+Master+of+Puppets&stick=H4sIAAAAAAAAAONgFuLQz9U3MClKLlLiArEMC1NSCiu1xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7FK-6aWJObkZCYnKvgmFpekFinkpykElBYUpJYUAwAR9teDTwAAAA&sa=X&ved=2ahUKEwiY_dHE8ICNAxUoRfEDHbGlMhgQ9OUBegQIOxAD")
      validate_image_base64(@entities, index, 4031)
    end


    it "validates an 'image' key that doesn't have base64 data value" do
      index = -1
      validate_name(@entities, index, "2007-10-27: The Bridge School Benefit, Mountain View, CA, USA")
      validate_extension(@entities, index, ["2007"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=6ff89c181547cd34&cs=1&biw=1440&bih=827&q=Metallica+2007-10-27:+The+Bridge+School+Benefit,+Mountain+View,+CA,+USA&stick=H4sIAAAAAAAAAONgFuLQz9U3MClKLlLiArGMs9KNCsy0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7G6-6aWJObkZCYnKhgZGJjrGhroGplbKYRkpCo4FWWmpKcqBCdn5OfnKDil5qWmZZboKPjml-aVJGbmKYRlppbrKDg76iiEBjsCAMiYVe57AAAA&sa=X&ved=2ahUKEwiY_dHE8ICNAxUoRfEDHbGlMhgQ9OUBegQIOxA5")
      validate_image_link(@entities, index, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBezxcSrzFPfUskB4mlORxV9POZdekYmDUQpn7Olg&s=10")
    end
    

    it "validates an artwork that shouldn't have the 'extensions' key" do
      index = 17
      validate_name(@entities, index, "Metallica Live in concert")
      expect(@entities[index].keys).to include(:name, :link, :image)
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=6ff89c181547cd34&cs=1&biw=1440&bih=827&q=Metallica+Metallica+Live+in+concert&stick=H4sIAAAAAAAAAONgFuLQz9U3MClKLlLiArHKM0qKk9O0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7Eq-6aWJObkZCYnKiBYPpllqQqZeQrJ-XnJqUUlAJbuz25XAAAA&sa=X&ved=2ahUKEwiY_dHE8ICNAxUoRfEDHbGlMhgQ9OUBegQIOxAl")
      validate_image_link(@entities, index, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqNzhKa1t_a1TpPFGHxfghdr42QiqtCCxGKVU8VKVXd6LXjLV1arIA-4&s=10")
    end
  end


  # Horizontal Gallery
  # Two different entity symbols
  context 'michelangelo' do

    before do
      @main_dict = parser.extract_data('./files/michelangelo.html')
      @artworks = @main_dict[:artworks]
      @structures = @main_dict[:structures]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:artworks, :structures])
    end

    it "validates the count of entities found" do
      expect(@artworks.length).to eq(9)
      expect(@structures.length).to eq(9)
    end

    it "validates the first artwork parsed" do
      index = 0
      validate_name(@artworks, index, "Sistine Chapel ceiling")
      validate_extension(@artworks, index, ["1512"])
      validate_link(@artworks, index, "https://www.google.com/search?sca_esv=c16ee7d0133e54f0&q=Sistine+Chapel+ceiling&stick=H4sIAAAAAAAAAONgFuLQz9U3MLUoN1XiBLGMzUqSkrWUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYxYKBnMy8VAXnjMSC1ByF5NTMnMy89B2sjADj13ouVwAAAA&sa=X&ved=2ahUKEwi3nc7Ip4ONAxU1xjgGHaUROTQQgOQBegQIQRAG")
      validate_image_base64(@artworks, index, 4967)
    end

    it "validates the first structure parsed" do
      index = 0
      validate_name(@structures, index, "Saint Peter’s Basilica")
      expect(@structures[index].keys).to include(:name, :link, :image)
      validate_link(@structures, index, "https://www.google.com/search?sca_esv=c16ee7d0133e54f0&q=St+Peter%27s+Basilica&stick=H4sIAAAAAAAAAONgFuLQz9U3MLUoN1UCs7LyKnO1lLOTrfQTi5IzMktSk0tKi1IRHKuU1OLM9LzUlEWswsElCgGpJalF6sUKTonFmTmZyYk7WBkBTPElb1QAAAA&sa=X&ved=2ahUKEwi3nc7Ip4ONAxU1xjgGHaUROTQQgOQBegQIURAG")
      validate_image_link(@structures, index, "https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqrvqU7yBTFLQWR_Iz8WApWHBaxOVF850pPCPqq2BbLNLqE3dwl80B9GM_S1UKkqxzEMs1LbqHihGgFV-8mC2crrXt8XTPd_l5A3RnE3KsyEEfDiVc5MctSxTiSVmg8cU4qnGRJ=w172-h115-k-no")
    end
  end


  # Table Form
  # Some item html's found in scripts with re
  context "the-off-season-songs" do

    before do
      @main_dict = parser.extract_data('./files/the-off-season-songs.html')
      @entities = @main_dict[:entities]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:entities])
    end

    it "validates the count of entities found" do
      expect(@entities.length).to eq(12)
    end

    it "validates the first entity parsed" do
      index = 0
      validate_name(@entities, index, "9 5 . s o u t h")
      validate_extension(@entities, index, ["3:17"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=4991a7ad233a5427&q=9+5+.+s+o+u+t+h&stick=H4sIAAAAAAAAAONgFuLRT9c3NK4qMDM3NMtW4gXxDAsNi5NzK0zytESzk630c0uLM5P1E3OSSnOtivPz0osXsfJbKpgq6CkUK-QrlCqUKGQAAB7ceNJIAAAA&sa=X&ved=2ahUKEwjd9eSZ56ONAxX8BNsEHeQQMRkQri56BAgcEAI")
      validate_image_base64(@entities, index, 2795)
    end

    it "validates an entity found in scripts" do
      index = -2
      validate_name(@entities, index, "c l o s e")
      validate_extension(@entities, index, ["2:49"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=4991a7ad233a5427&q=c+l+o+s+e&stick=H4sIAAAAAAAAAONgFuLRT9c3NK4qMDM3NMtW4gXxDPNyCwqrCpNytESzk630c0uLM5P1E3OSSnOtivPz0osXsXImK-Qo5CsUK6QCAI0YIFZCAAAA&sa=X&ved=2ahUKEwjd9eSZ56ONAxX8BNsEHeQQMRkQri56BAgcECo")
      validate_image_link(@entities, index, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3f5m7JxgtMFUiDTLZcl4R38VHvz2KE2kweJbw&s=0")
    end
  end


  # Table Form
  # Has two extensions
  # Has an item that has placeholder for it's image
  context 'metallica-songs' do

    before do
      @main_dict = parser.extract_data('./files/metallica-songs.html')
      @entities = @main_dict[:entities]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:entities])
    end

    it "validates the count of entities found" do
      expect(@entities.length).to eq(32)
    end

    it "validates the first entity parsed" do
      index = 0
      validate_name(@entities, index, "Nothing Else Matters")
      validate_extension(@entities, index, ["Metallica", "1991"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=b02fb6a0238aa473&q=metallica+nothing+else+matters&stick=H4sIAAAAAAAAAONgFuLQz9U3MClKLlLi0U_XNyw2MC3LzjMy0BL0LS3OTHYsKsksLgnJD87PS1_EKpebWpKYk5OZnKiQl1-SkZmXrpCaU5yqkJtYUpJaVAwA9AvhcE4AAAA&sa=X&ved=2ahUKEwjMtYjGnoONAxVcBNsEHcxFHqwQri56BAgmEAI")
      validate_image_base64(@entities, index, 1919)
    end

    it "validates an item that shouldn't have image" do
      index = 25
      validate_name(@entities, index, "Guitar Solo [Remasterd]")
      validate_extension(@entities, index, ["Live : Reunion Arena, Dallas, TX, 5 Feb 89", "2017"])
      validate_link(@entities, index, "https://www.google.com/search?sca_esv=b02fb6a0238aa473&q=metallica+guitar+solo+%5Bremasterd%5D&stick=H4sIAAAAAAAAAONgFuLQz9U3MClKLlLi1U_XNzRMMzI3MCsvy9AS9C0tzkx2LCrJLC4JyQ_Oz0tfxKqYm1qSmJOTmZyokF6aWZJYpFCcn5OvEF2UmptYXJJalBILAIcYwGxSAAAA&sa=X&ved=2ahUKEwjMtYjGnoONAxVcBNsEHcxFHqwQri56BAgmEGY")
      expect(@entities[index].keys).to include(:name, :extensions, :link)
    end
  end


  # List view (Different from other album queries)
  # Has only one item
  context 'hemlocke-springs-albums' do

    before do
      @main_dict = parser.extract_data('./files/hemlocke-springs-albums.html')
      @albums = @main_dict[:albums]
    end

    it "validates the entity symbols" do
      expect(@main_dict.keys).to eq([:albums])
    end

    it "validates the count of albums found" do
      expect(@albums.length).to eq(1)
    end

    it "validates the only album parsed" do
      index = 0
      validate_name(@albums, index, "Going...Going...Gone!")
      validate_extension(@albums, index, ["2023, EP"])
      validate_link(@albums, index, "https://www.google.com/search?sca_esv=21735534f6446a24&q=Hemlocke+Springs+Going...Going...Gone!&stick=H4sIAAAAAAAAAONgFuLVT9c3NCwxMk3LScs1V4Jwc4zKDcyMDdO0hHxLizOTHYtKMotLQvIdc5JKcxexqnmk5ubkJ2enKgQXFGXmpRcruOcDKT09PQSdl6oIAMrOH7JdAAAA&sa=X&ved=2ahUKEwiRgaCN2qeNAxXFcfEDHSCUCPkQri56BAg-EAM")
      validate_image_base64(@albums, index, 1895)
    end
  end
end
