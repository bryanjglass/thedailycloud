class CloudController < ApplicationController
  def index
    @cloud = Cloud.find_current
  end
end
