class SitemapsController < ActionController::Base
  def show
    @services = Service.published.ordered
    @categories = Category.order(:name)
  end
end
