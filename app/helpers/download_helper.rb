module DownloadHelper
  PDF_DIR = 'public'

  def download_links_array
    Dir.glob('**/*.pdf', base: PDF_DIR).each do |pdf|
      {
        url: pdf,
        title: "#{pdf.match(/\d+/)[0]} Report"
      }
    end.to_json 
  end
end