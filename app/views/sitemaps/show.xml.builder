xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url { xml.loc root_url; xml.lastmod Time.current.to_date.iso8601 }
  @categories.each do |category|
    xml.url { xml.loc category_url(category) }
  end
  @services.each do |service|
    xml.url { xml.loc service_url(service) }
  end
end
