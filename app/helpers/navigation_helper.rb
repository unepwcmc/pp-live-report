module NavigationHelper
  include YamlHelpers

  CONTENT_BASE_PATH = 'lib/data/content'.freeze
  FIRST_CHAPTER = 1
  LAST_CHAPTER = 11

  def fetch_chapter_links(current_chapter)
    {
      previous_ch: populate_chapter_json(current_chapter - 1),
      next_ch: populate_chapter_json(current_chapter + 1)
    }
  end

  def populate_chapter_json(number)
    return if number == FIRST_CHAPTER - 1 || number == LAST_CHAPTER + 1
    URI.join(root_url, "/chapter-#{number}")
  end
end