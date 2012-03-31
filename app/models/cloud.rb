require 'flickraw'
require 'fastimage'

class Cloud < ActiveRecord::Base
  FlickRaw.api_key = '2597acf933973a8f0235ed1d5fe628a0'
  FlickRaw.shared_secret = 'f99f2874b8777feb'
  flickr.access_token = '72157629710823089-414132c7c3aafdc6'
  flickr.access_secret = 'e0b35a64869d3716'
  
  def self.find_current
    Cloud.order("created_at desc").limit(1).first
  end

  def self.fetch_current_photo
    photos = self.fetch_photos(28)

    # find the first landscape oriented photo
    photos.each do |p|
      size = FastImage.size(self.photo_url(p))
      if size[0] > size[1]
      return p
      end
    end

    photos.first
  end

  def self.fetch_photos(days_ago)
    begin_date = days_ago.days.ago.to_date
    end_date = (days_ago-1).days.ago.to_date

    #photos = flickr.photos.search :group_id=>'89594630@N00', :tags=>'clouds, sky', :min_taken_date=>Date.yesterday, :max_taken_date=>Date.tomorrow, :sort=>"interestingness-desc", :per_page=>5
    photos = flickr.photos.search :group_id=>'73183316@N00', :tags=>'clouds', :min_taken_date=>begin_date, :max_taken_date=>end_date, :sort=>"interestingness-desc", :per_page=>20
  end

  def self.photo_url(photo)
    "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_c.jpg".to_str
  end

  def self.photo_link(photo)
    "http://www.flickr.com/photos/#{photo.owner}/#{photo.id}".to_str
  end

  def self.write_comment(photo)
    begin
      login = flickr.test.login
      puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
      flickr.photos.comments.addComment :photo_id=>photo.id, :comment_text=>"Congratulations!  This photo is being featured on http://www.TheDailyCloud.com today!"
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
  end
end
