class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:slug])
    authorize @category
    @services = @category.services.published.ordered.includes(:category)
    category_description = helpers.meta_description(
      @category.description.presence || "Юридические услуги в категории #{@category.name}"
    )
    set_page_context(
      title: @category.name,
      description: category_description,
      breadcrumbs: [
        ["Услуги", services_path],
        [@category.name, category_path(@category)]
      ],
      og: { url: category_url(@category) }
    )
  end
end
