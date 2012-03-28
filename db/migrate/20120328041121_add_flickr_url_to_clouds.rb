class AddFlickrUrlToClouds < ActiveRecord::Migration
  def change
    add_column :clouds, :link, :string
  end
end
