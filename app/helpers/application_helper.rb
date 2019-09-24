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

  def social_image
    image_url('social.jpg')
  end

  def social_image_alt
    'Guanaco Torres del Paine Chile Gregoire Dubois'
  end

  def create_sharing_facebook_link
    title = url_encode('Share ' + page_title + ' on Facebook')
    url = encoded_home_url
    href = 'https://facebook.com/sharer/sharer.php?u=' + url

    link_to '', href, title: title, class: 'social__icon social__icon--facebook', target: '_blank'
  end

  def create_sharing_twitter_link
    title = url_encode('Share ' + page_title + ' on Twitter')
    text = url_encode('Protected Planet Report 2018')
    url = encoded_home_url
    href = 'https://twitter.com/intent/tweet/?text=' + text + '&url=' + url
    
    link_to '', href, title: title, class: 'social__icon social__icon--twitter', target: '_blank'
  end

  def create_sharing_email_link
    title = url_encode('Share ' + page_title + ' via Email')
    url = encoded_home_url
    subject = url_encode(site_title)
    body = site_description + url_encode("\n\n") + url
    href = 'mailto:?subject=' + subject + '&body=' + body

    link_to '', href, title: title, class: 'social__icon social__icon--email', target: '_self'
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
    puts filename
    if asset_exists?(filename)
      url = image_url(filename)
      puts url
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
