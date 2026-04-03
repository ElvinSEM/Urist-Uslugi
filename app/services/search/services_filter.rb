module Search
  class ServicesFilter
    def initialize(params)
      @params = params.to_h.symbolize_keys
    end

    def apply(scope)
      result = scope
      result = result.where(category_id: params[:category_id]) if params[:category_id].present?
      result = result.priced_from(params[:price_from])
      result = result.priced_to(params[:price_to])
      result = result.where("services.title ILIKE :q OR services.description ILIKE :q", q: "%#{params[:query]}%") if params[:query].present?
      result
    end

    private

    attr_reader :params
  end
end
