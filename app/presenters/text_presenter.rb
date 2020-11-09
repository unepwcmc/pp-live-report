# frozen_string_literal: true

# Extracts logic out of views/partials/_main-text to make it less ugly
# This is because the text (in the YML files) can be an array of strings, a mixed array
# of strings/string with a sub-array of strings (to form an ordered/unordered HTML list) 
# or finally a single paragraph of text (one long string).
class TextPresenter
  def initialize(text)
    @text = text
  end

  def get_list_items(list, is_unordered_list)
    @list_items = list.values

    if is_unordered_list
      "<ul>#{individual_list_items}</ul>".html_safe
    else
      "<ol>#{individual_list_items}</ol>".html_safe
    end
  end

  def preceding_clause(text)
    text.keys[0]
  end

  def individual_list_items
    @list_items.flatten.map do |value|
      next if value.nil?

      "<li><p class=\"content__text\">#{value}</p></li>".html_safe
    end.join('')
  end
end
