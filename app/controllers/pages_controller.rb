class PagesController < ApplicationController
  def map
    @overlay = (params[:overlay] || 'sessions').inquiry
  end
end
