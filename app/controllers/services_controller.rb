class ServicesController < ApplicationController
  before_action :set_service, only: :show

  def index
    set_page_context(
      title: "Юридические услуги",
      description: "Каталог юридических услуг с фильтрацией по категориям и стоимости",
      breadcrumbs: [["Услуги", services_path]],
      og: { url: services_url }
    )
    @filter = Search::ServicesFilter.new(search_params)
    scoped = policy_scope(Service).includes(:category).merge(Service.ordered)
    @filtered_services = @filter.apply(scoped)
    @pagy, @services = pagy(@filtered_services)
    @service_groups = Services::AccordionBuilder.call(@filtered_services)
    @service_count = @filtered_services.count
  end

  def show
    authorize @service
    description = helpers.meta_description(@service.description)
    set_page_context(
      title: @service.title,
      description: description,
      breadcrumbs: [
        ["Услуги", services_path],
        [@service.title, service_path(@service)]
      ],
      og: {
        type: "article",
        url: service_url(@service),
        description: description
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
