class Admin::CrudController < Admin::BaseController
  before_action :set_resource, only: %i[edit update destroy]
  helper_method :resource, :resources, :resource_label, :resource_name, :resources_label

  def index
    @resources = collection_scope
    assign_collection_instance
  end

  def new
    @resource = resource_class.new
    assign_resource_instance
  end

  def create
    @resource = resource_class.new(resource_params)
    assign_resource_instance

    if @resource.save
      redirect_to collection_path, notice: "#{resource_label} создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if resource.update(resource_params)
      redirect_to collection_path, notice: "#{resource_label} обновлена"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    resource.destroy!
    redirect_to collection_path, notice: "#{resource_label} удалена"
  end

  private

  def collection_scope
    resource_class.all
  end

  def set_resource
    @resource = find_resource
    assign_resource_instance
  end

  def find_resource
    collection_scope.find(params[:id])
  end

  def assign_resource_instance
    instance_variable_set("@#{resource_name}", @resource)
  end

  def assign_collection_instance
    instance_variable_set("@#{resource_collection_name}", @resources)
  end

  def resource_name
    resource_class.model_name.param_key
  end

  def resource_collection_name
    resource_class.model_name.collection
  end

  def resources_label
    resource_class.model_name.human(count: 2)
  end

  def resource_label
    resource_class.model_name.human
  end

  def collection_path
    send("admin_#{resource_collection_name}_path")
  end

  def resource_path(record)
    send("admin_#{resource_name}_path", record)
  end

  def resource_params
    raise NotImplementedError, "Define resource_params in #{self.class.name}"
  end

  def resource_class
    raise NotImplementedError, "Define resource_class in #{self.class.name}"
  end

  def resource
    @resource
  end

  def resources
    @resources
  end
end
