class ExampleData
  # rakuten item search api (to set applicationId value)
  TEST_URL = 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120723?applicationId=&keyword=Ruby'
  
  # retriving data via api
  def self.retrieve_data(block)
    BW::HTTP.get(TEST_URL) do |response|
      data = []
      json = BW::JSON.parse(response.body.to_str)
      json['Items'].each do |item|
        attributes = item['Item']
        
        # name
        name = attributes['itemName']
        
        # thumbnail
        image_urls = attributes['smallImageUrls']
        image_url = (image_urls.size > 0 ? image_urls[0]['imageUrl'] : nil)
        
        data << {
          :name => name,
          :image_url => image_url,
        }
      end
      
      block.call(data)
    end
  end
end
