module ApplicationHelper
  def nav_link_class(path)
    current_page?(path) ? "nav-link nav-link-active" : "nav-link"
  end

  def status_badge_class(status)
    case status.to_s
    when "pending" then "status-badge status-badge-pending"
    when "in_progress" then "status-badge status-badge-progress"
    when "completed" then "status-badge status-badge-completed"
    when "rejected" then "status-badge status-badge-rejected"
    else "status-badge"
    end
  end

  def page_title(title = nil)
    [title, "Услуги Юриста"].compact.join(" | ")
  end

  def meta_description(text)
    text.to_s.truncate(160)
  end

  def service_schema(service)
    {
      "@context": "https://schema.org",
      "@type": "Service",
      name: service.title,
      description: meta_description(service.description),
      serviceType: service.category_name,
      offers: {
        "@type": "Offer",
        priceCurrency: "RUB",
        price: service.price
      },
      provider: {
        "@type": "LegalService",
        name: "Услуги Юриста",
        url: root_url
      },
      url: service_url(service)
    }
  end

  def section_heading(title, subtitle = nil)
    content_tag(:header, class: "section-heading") do
      concat content_tag(:h1, title, class: "section-title")
      concat content_tag(:p, subtitle, class: "section-subtitle") if subtitle.present?
    end
  end
end
