module PostsHelper
  def blog_image_tag(post, **options)
    image_tag(blog_image_source(post), **options)
  end

  def blog_image_source(post)
    path = post.image_path.presence || "blog/placeholder.svg"

    full_path = Rails.root.join("app/assets/images/#{path}")

    if File.exist?(full_path)
      path
    else
      "blog/placeholder.svg"
    end
  end

  private

  def blog_asset_exists?(relative_path)
    Rails.root.join("app/assets/images", relative_path.delete_prefix("/")).exist?
  end
end
