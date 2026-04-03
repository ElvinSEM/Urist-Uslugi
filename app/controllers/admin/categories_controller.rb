class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create!(category_params)
    redirect_to admin_categories_path, notice: "Категория создана"
  end

  def edit
    @category = Category.friendly.find(params[:id])
  end

  def update
    @category = Category.friendly.find(params[:id])
    @category.update!(category_params)
    redirect_to admin_categories_path, notice: "Категория обновлена"
  end

  def destroy
    Category.friendly.find(params[:id]).destroy!
    redirect_to admin_categories_path, notice: "Категория удалена"
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
