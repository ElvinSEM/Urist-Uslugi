class Admin::CategoriesController < Admin::CrudController
  private

  def resource_class
    Category
  end

  def collection_scope
    Category.order(:name)
  end

  def resource_params
    params.require(:category).permit(:name, :description)
  end

  def resource_label
    "Категория"
  end
end
