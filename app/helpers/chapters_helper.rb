module ChaptersHelper
  def get_csv_url filename
    URI.join(root_url, "/file/#{filename}")
  end
end