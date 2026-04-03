class ServicesController < ApplicationController
  before_action :set_service, only: :show

  def index
    add_breadcrumb "Услуги", services_path
    @filter = Search::ServicesFilter.new(search_params)
    scoped = policy_scope(Service).includes(:category).merge(Service.ordered)
    @pagy, @services = pagy(@filter.apply(scoped))
    set_meta_tags(
      title: "Юридические услуги",
      description: "Каталог юридических услуг с фильтрацией по категориям и стоимости",
      og: {
        title: "Юридические услуги",
        description: "Каталог юридических услуг с фильтрацией по категориям и стоимости",
        type: "website",
        url: services_url
      }
    )
  end

  def show
    authorize @service
    add_breadcrumb "Услуги", services_path
    add_breadcrumb @service.title, service_path(@service)
    set_meta_tags(
      title: @service.title,
      description: helpers.meta_description(@service.description),
      og: {
        title: @service.title,
        description: helpers.meta_description(@service.description),
        type: "article",
        url: service_url(@service)
      }
    )
  end

  private

  def set_service
    @service = Service.friendly.find(params[:slug])
  end

  def search_params
    params.permit(:query, :category_id, :price_from, :price_to)
  end
end
