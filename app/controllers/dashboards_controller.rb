class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @spaces = current_user.spaces
  end
end