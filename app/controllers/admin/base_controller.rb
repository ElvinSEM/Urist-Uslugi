class Admin::BaseController < ApplicationController
  include AdminAccess

  layout "admin"

  # before_action :authenticate_user!
end
