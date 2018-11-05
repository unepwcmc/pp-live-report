module ApplicationHelper
  def site_title 
    'Protected Planet Report 2018'
  end

  def site_description
    'Protected Planet Reports are biennial landmark publications that assess the state of protected areas around the world. They are based on the data contained in the World Database on Protected Areas (WDPA), jointly managed by UNEP-WCMC and IUCM, as well as other relevant resources.'
  end

  def page_title
    content_for?(:title) ? content_for(:title) : site_title
  end

  def url_encode text
    ERB::Util.url_encode(text)
  end

  def encoded_home_url
    url_encode(request.base_url)
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
end
