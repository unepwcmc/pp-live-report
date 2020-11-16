module NavigationHelper
  include YamlHelpers

  CONTENT_BASE_PATH = 'lib/data/content'.freeze
  FIRST_CHAPTER = 1.freeze
  LAST_CHAPTER = 10.freeze

  def fetch_chapter_links(current_chapter)
    {
      previous_ch: populate_chapter_json(current_chapter - 1),
      next_ch: populate_chapter_json(current_chapter + 1)
    }
  end

  def populate_chapter_json(chapter_number)
    return if chapter_number == ( FIRST_CHAPTER - 1 || LAST_CHAPTER + 1 )
    URI.join(root_url, "/chapter-#{chapter_number}")
  end
end