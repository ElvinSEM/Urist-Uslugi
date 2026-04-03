class Admin::ServicesController < Admin::BaseController
  def index
    @services = Service.includes(:category).ordered
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.create!(service_params)
    redirect_to admin_services_path, notice: "Услуга создана"
  end

  def edit
    @service = Service.friendly.find(params[:id])
  end

  def update
    @service = Service.friendly.find(params[:id])
    @service.update!(service_params)
    redirect_to admin_services_path, notice: "Услуга обновлена"
  end

  def destroy
    Service.friendly.find(params[:id]).destroy!
    redirect_to admin_services_path, notice: "Услуга удалена"
  end

  private

  def service_params
    params.require(:service).permit(:category_id, :title, :description, :price_cents, :published, :position)
  end
end
