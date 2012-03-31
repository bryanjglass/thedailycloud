namespace :cloud do

  desc "Fetch the next daily cloud from flickr"
  task :fetch => :environment do
    puts "Fetching latest cloud from flickr..."
    @photo = Cloud.fetch_current_photo
    puts "found photo: #{Cloud.photo_url(@photo)}"
    puts "done."
  end

  desc "Insert the next daily cloud into the database"
  task :update => [:environment, :fetch] do
    puts "Inserting cloud into database..."
    @cloud = Cloud.new
    @cloud.url = Cloud.photo_url(@photo)
    @cloud.link = Cloud.photo_link(@photo)
    @cloud.save
    puts "done."
  end

  desc "Add a comment to the next daily cloud's flickr page"
  task :comment => [:environment, :update] do
    puts "Adding comment to flickr page (#{Cloud.photo_link(@photo)})..."
    Cloud.write_comment(@photo)
    puts "done."
  end
end