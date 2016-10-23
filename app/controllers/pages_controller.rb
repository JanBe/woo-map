class PagesController < ApplicationController
  def map
    @overlay = (params[:overlay] || 'marker').inquiry
  end
end
