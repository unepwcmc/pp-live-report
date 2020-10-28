module NavigationHelper
  include YamlHelpers

  CONTENT_BASE_PATH = 'lib/data/content'.freeze
  FIRST_CHAPTER = 1.freeze
  LAST_CHAPTER = 10.freeze

  def previous_chapter(current_chapter)
    return false if current_chapter == FIRST_CHAPTER
    previous_ch_number = current_chapter - 1
    previous_ch = load_yaml("#{CONTENT_BASE_PATH}/chapter-#{previous_ch_number}.yml")

    populate_chapter_json(previous_ch_number)
  end

  def next_chapter(current_chapter)
    return false if current_chapter == LAST_CHAPTER
    next_ch_number = current_chapter + 1
    next_ch = load_yaml("#{CONTENT_BASE_PATH}/chapter-#{next_ch_number}.yml")

    populate_chapter_json(next_ch_number)
  end

  def populate_chapter_json(ch_number)
    URI.join(root_url, "/chapter-#{ch_number}")
  end
end