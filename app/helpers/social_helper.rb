module SocialHelper
  def social_image
    image_url('social.png')
  end

  def social_image_alt
    'Protect Planet Live Report Homepage'
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

  def social_sharing_links
    I18n.t('social.share').keys.map(&:to_s).map do |social_medium|
    {
      url: I18n.t("social.share.#{social_medium}.url", url: url_encode(request.url) ),
      title: I18n.t("social.share.#{social_medium}.title"),
      customClass: "social__icon--#{social_medium}",
    }
    end.to_json
  end
end