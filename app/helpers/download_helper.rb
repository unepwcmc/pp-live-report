module DownloadHelper
  def download_links_array
    [
      { url: 'pdf/Protected_Planet_Report_2018.pdf', title: '2018 report' }
    ].to_json
  end
end