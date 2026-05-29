class PagesController < ApplicationController
  def home
    @services = Service.published.ordered.includes(:category)
    @featured_services = @services.limit(6)
    @featured_posts = Post.published.recent_first.limit(3)
    @service_request = ServiceRequest.new(service_id: @services.first&.id)

    set_page_context(
      title: "Юридическая помощь онлайн",
      description: "Современный сервис юридических услуг с быстрым подбором решений и онлайн-заявкой.",
      og: { url: root_url }
    )
  end
end
