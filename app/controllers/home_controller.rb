class HomeController < ApplicationController

  before_action :authorize
  layout 'dashboard'

  def index
  end
end
