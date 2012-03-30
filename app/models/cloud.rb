require 'flickraw'

class Cloud < ActiveRecord::Base
  FlickRaw.api_key = '2597acf933973a8f0235ed1d5fe628a0'
  FlickRaw.shared_secret = 'f99f2874b8777feb'
  def self.find_current
    latest = Cloud.order("created_at desc").limit(1).first

    if latest.nil? || latest.created_at.to_date < Date.today
      #photos = flickr.photos.search :group_id=>'89594630@N00', :tags=>'clouds, sky', :min_taken_date=>Date.yesterday, :max_taken_date=>Date.tomorrow, :sort=>"interestingness-desc", :per_page=>5
      photos = flickr.photos.search :group_id=>'73183316@N00', :min_taken_date=>Date.yesterday, :max_taken_date=>Date.tomorrow, :sort=>"interestingness-desc", :per_page=>5

      cloud = Cloud.new
      cloud.url = "http://farm#{photos.first.farm}.staticflickr.com/#{photos.first.server}/#{photos.first.id}_#{photos.first.secret}_c.jpg".to_str
      cloud.link = "http://www.flickr.com/photos/#{photos.first.owner}/#{photos.first.id}".to_str
      cloud.save
      
      latest = cloud
    end
    
    latest
  end
end
