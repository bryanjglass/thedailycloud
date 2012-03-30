require 'flickraw'
require 'fastimage'

class Cloud < ActiveRecord::Base
  FlickRaw.api_key = '2597acf933973a8f0235ed1d5fe628a0'
  FlickRaw.shared_secret = 'f99f2874b8777feb'
  def self.find_current
    latest = Cloud.order("created_at desc").limit(1).first

    if latest.nil? || latest.created_at.to_date < Date.today
      begin

        #fetch latest from flickr
        photos = flickr.photos.search :group_id=>'73183316@N00', :tags=>'clouds', :min_taken_date=>Date.yesterday, :max_taken_date=>Date.tomorrow, :sort=>"interestingness-desc", :per_page=>20
        #photos = flickr.photos.search :group_id=>'89594630@N00', :tags=>'clouds, sky', :min_taken_date=>Date.yesterday, :max_taken_date=>Date.tomorrow, :sort=>"interestingness-desc", :per_page=>5

        # find the first landscape oriented photo
        photos.each do |p|
          size = FastImage.size("http://farm#{p.farm}.staticflickr.com/#{p.server}/#{p.id}_#{p.secret}_c.jpg")
          if size[0] > size[1]
          @photo = p
          break
          end
        end

        # insert a new cloud
        cloud = Cloud.new
        cloud.url = "http://farm#{@photo.farm}.staticflickr.com/#{@photo.server}/#{@photo.id}_#{@photo.secret}_c.jpg".to_str
        cloud.link = "http://www.flickr.com/photos/#{@photo.owner}/#{@photo.id}".to_str
        cloud.save

        latest = cloud
      rescue Exception => e
        logger.error e.message
      end
    end

    latest
  end
end
