module IInstagram
  class IInstagram

    attr_accessor :tag, :token, :response, :data, :photos, :max_photo_id, :partner_id, :client_id
  
    def initialize(args)
      if args
        self.client_id    = args[:client_key]
        self.token        = args[:token]
        self.tag          = args[:tag]
        self.max_photo_id = args[:max_photo_id]
        self.partner_id   = args[:partner_id]
        self.photos       = []
      end
      authenticate
    end
  
    def authenticate
      Instagram.configure do |config|
        config.client_id = client_id
        config.access_token = token
      end
    end
  
    def get_grams
      begin
        unless max_photo_id.blank?
          self.response = Instagram.tag_recent_media(tag, :max_tag_id => max_photo_id)
          # self.response = Instagram.tag_recent_media(tag, :max_id => max_photo_id)
        else
          self.response = Instagram.tag_recent_media(tag)
        end
        self.data     = self.response.data
        if self.data.count > 0
          self.data.each do |media|
            self.photos   << {
                                :i_id       => media.id,
                                :url        => media.images.standard_resolution.url,
                                :username   => media.user.username,
                                :partner_id => partner_id
                             }
          end
          self.max_photo_id = self.data.last.id
        end
      end
      self.photos.each do |ipic|
        begin
          Iphoto.create!(ipic)
        rescue Exception => e
          puts e.message
          puts e
        end
      end
      begin
        max_photo = Tag.find_by_name(tag)
        max_photo.update_attributes(:max_photo_id => max_photo_id)
        # max_photo = Setup.find_or_create_by_key_name("max_photo_id")
        # max_photo.update_attributes(:key_val => max_photo_id)          
      rescue Exception => e
        puts e.message
      end
    rescue Exception => e
      raise e
    end
  end
end