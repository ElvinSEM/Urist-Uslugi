module PageContext
  extend ActiveSupport::Concern

  private

  def set_page_context(title:, description:, breadcrumbs: [], og: {})
    breadcrumbs.each do |crumb|
      add_breadcrumb(*crumb)
    end

    set_meta_tags(
      title: title,
      description: description,
      og: meta_og(title: title, description: description, overrides: og)
    )
  end

  def meta_og(title:, description:, overrides: {})
    {
      title: title,
      description: description,
      type: "website",
      url: request.url
    }.merge(overrides || {})
  end
end
