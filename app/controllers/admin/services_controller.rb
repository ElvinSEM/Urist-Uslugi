class Admin::ServicesController < Admin::CrudController
  private

  def resource_class
    Service
  end

  def collection_scope
    Service.includes(:category).ordered
  end

  def find_resource
    Service.friendly.find(params[:id])
  end

  def resource_params
    params.require(:service).permit(:category_id, :title, :description, :price_cents, :published, :position)
  end

  def resource_label
    "Услуга"
  end
end
