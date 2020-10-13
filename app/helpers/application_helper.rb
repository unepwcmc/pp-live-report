module ApplicationHelper
  include ActionView::Helpers::NumberHelper
  include YamlHelpers
  
  def site_title 
    'Protected Planet Digital Report'
  end

  def site_description
    'Protected Planet Digital Report assesses the state of protected areas around the world.'
  end

  def page_title
    content_for?(:title) ? content_for(:title) : site_title
  end

  def title_meta_tag(page_title)  
    page_title == nil ? site_title: "#{page_title} | #{site_title}" 
  end

  def url_encode text
    ERB::Util.url_encode(text)
  end

  def encoded_home_url
    url_encode(request.base_url)
  end

 

  def active_nav_item?(test_path)
    request.fullpath == test_path
  end

  def commaify(number)
    number_with_delimiter(number, delimeter: ',')
  end

  def style_background_image filename
    if filename == nil then return '' end

    style = ''

    if asset_exists?(filename)
      url = image_url(filename)
      style = 'style="background-image: url(' + url + ');"'.html_safe
    end

    style
  end

  def asset_exists?(path)
    if Rails.env.staging? || Rails.env.production?
      Rails.application.assets_manifest.assets[path].present?
    else
      Rails.application.assets.resolve(path).present?
    end
  end
end
