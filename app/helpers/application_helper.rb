module ApplicationHelper
  def nav_link_class(path)
    current_page?(path) ? "nav-link nav-link-active" : "nav-link"
  end

  def admin_nav_link_class(path, exact: false)
    active = exact ? request.path == path : request.path.start_with?(path)
    active ? "rounded-2xl border border-sky-200 bg-sky-50 px-4 py-3 font-medium text-sky-700 shadow-sm transition duration-200" : "rounded-2xl border border-transparent px-4 py-3 font-medium text-slate-600 transition duration-200 hover:border-slate-200 hover:bg-slate-50 hover:text-slate-950"
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

  def service_request_status_label(status)
    {
      "pending" => "В ожидании",
      "in_progress" => "В работе",
      "completed" => "Завершена",
      "rejected" => "Отклонена"
    }.fetch(status.to_s, status.to_s.tr("_", " ").humanize)
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

  def service_category_badge(service)
    variant = service_category_variant(service.category_name)

    content_tag(:span, class: variant[:badge_class]) do
      concat service_category_icon(variant[:icon], variant[:icon_class])
      concat content_tag(:span, service.category_name, class: variant[:label_class])
    end
  end

  def service_category_variant(category_name)
    normalized = category_name.to_s.downcase

    case normalized
    when /договор|контракт|соглаш/
      {
        icon: :document,
        badge_class: "inline-flex items-center gap-2 rounded-full border border-sky-200 bg-sky-50 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-sky-700 transition duration-300 group-hover:border-sky-300 group-hover:bg-sky-100",
        icon_class: "text-sky-600",
        label_class: "whitespace-nowrap"
      }
    when /суд|спор|арбитраж|претенз/
      {
        icon: :scales,
        badge_class: "inline-flex items-center gap-2 rounded-full border border-violet-200 bg-violet-50 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-violet-700 transition duration-300 group-hover:border-violet-300 group-hover:bg-violet-100",
        icon_class: "text-violet-600",
        label_class: "whitespace-nowrap"
      }
    when /бизнес|ооо|ип|регистрац/
      {
        icon: :briefcase,
        badge_class: "inline-flex items-center gap-2 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-emerald-700 transition duration-300 group-hover:border-emerald-300 group-hover:bg-emerald-100",
        icon_class: "text-emerald-600",
        label_class: "whitespace-nowrap"
      }
    when /недвиж|земл|строит/
      {
        icon: :building,
        badge_class: "inline-flex items-center gap-2 rounded-full border border-amber-200 bg-amber-50 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-amber-700 transition duration-300 group-hover:border-amber-300 group-hover:bg-amber-100",
        icon_class: "text-amber-600",
        label_class: "whitespace-nowrap"
      }
    else
      {
        icon: :sparkles,
        badge_class: "inline-flex items-center gap-2 rounded-full border border-slate-200 bg-slate-50 px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-slate-600 transition duration-300 group-hover:border-sky-200 group-hover:bg-sky-50 group-hover:text-sky-700",
        icon_class: "text-sky-600",
        label_class: "whitespace-nowrap"
      }
    end
  end

  def service_category_icon(name, classes = "")
    svg_classes = ["h-4 w-4 shrink-0", classes].compact.join(" ")

    icon_svg =
      case name
      when :document
        safe_join([
          tag.path(d: "M8 3h5l5 5v13H8z", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round"),
          tag.path(d: "M13 3v5h5", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round")
        ])
      when :scales
        safe_join([
          tag.path(d: "M12 3v18", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round"),
          tag.path(d: "M5 7h14", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round"),
          tag.path(d: "M7 7l-3 5h6z", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round"),
          tag.path(d: "M17 7l-3 5h6z", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round")
        ])
      when :briefcase
        safe_join([
          tag.path(d: "M10 6V5a2 2 0 0 1 4 0v1", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round"),
          tag.rect(x: "3", y: "6", width: "18", height: "13", rx: "2", fill: "none", stroke: "currentColor", "stroke-width": "2"),
          tag.path(d: "M3 11h18", fill: "none", stroke: "currentColor", "stroke-width": "2")
        ])
      when :building
        safe_join([
          tag.path(d: "M4 21V8l8-4 8 4v13", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round"),
          tag.path(d: "M9 21v-6h6v6", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round"),
          tag.path(d: "M8 12h.01M12 12h.01M16 12h.01M8 16h.01M12 16h.01M16 16h.01", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round")
        ])
      else
        safe_join([
          tag.path(d: "M13 3L4 14h7l-1 7 10-12h-7z", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linejoin": "round"),
          tag.path(d: "M16 4l4 4", fill: "none", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round")
        ])
      end

    content_tag(:svg, icon_svg, class: svg_classes, viewBox: "0 0 24 24", fill: "none", "aria-hidden": "true")
  end

  def service_pagination_nav(pagy)
    content_tag(:div, class: "inline-flex flex-wrap items-center justify-center gap-2 rounded-full border border-slate-200 bg-white p-2 shadow-sm") do
      safe_join([
        service_pagination_control(pagy.prev, service_pagination_url(pagy, :previous), "Назад", leading_icon: "←"),
        content_tag(:div, class: "hidden items-center gap-2 md:flex") do
          safe_join(pagy.series.map { |item| service_pagination_page(item, pagy) })
        end,
        content_tag(:div, "#{pagy.page} / #{pagy.last}", class: "inline-flex items-center rounded-full bg-slate-50 px-4 py-2 text-sm font-semibold text-slate-700 md:hidden"),
        service_pagination_control(pagy.next, service_pagination_url(pagy, :next), "Вперёд", trailing_icon: "→")
      ])
    end
  end

  def service_pagination_page(item, pagy)
    if item == :gap
      content_tag(:span, "…", class: "inline-flex h-10 min-w-10 items-center justify-center rounded-full px-3 text-sm font-semibold text-slate-400")
    elsif item.to_s == pagy.page.to_s
      content_tag(:span, item, class: "inline-flex h-10 min-w-10 items-center justify-center rounded-full bg-sky-600 px-3 text-sm font-semibold text-white shadow-md shadow-sky-200")
    else
      link_to item, service_pagination_url(pagy, item), class: "inline-flex h-10 min-w-10 items-center justify-center rounded-full px-3 text-sm font-semibold text-slate-600 transition duration-300 hover:bg-slate-50 hover:text-slate-950"
    end
  end

  def service_pagination_control(enabled, href, label, leading_icon: nil, trailing_icon: nil)
    classes = "inline-flex h-10 items-center gap-2 rounded-full px-4 text-sm font-semibold transition duration-300"

    content = []
    content << tag.span(leading_icon, aria: { hidden: true }) if leading_icon.present?
    content << tag.span(label)
    content << tag.span(trailing_icon, aria: { hidden: true }) if trailing_icon.present?

    if enabled
      link_to href, class: "#{classes} text-slate-600 hover:bg-slate-50 hover:text-slate-950" do
        safe_join(content)
      end
    else
      content_tag(:span, safe_join(content), class: "#{classes} cursor-not-allowed text-slate-300")
    end
  end

  def service_pagination_url(pagy, page)
    target =
      case page
      when :previous then pagy.prev
      when :next then pagy.next
      else page
      end

    return "#" if target.nil?

    page_key = pagy.options[:page_key].to_s
    query = request.query_parameters.to_h.merge(page_key => target).to_query

    "#{request.path}?#{query}"
  end
end
