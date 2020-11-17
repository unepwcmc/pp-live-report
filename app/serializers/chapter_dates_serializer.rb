class ChapterDatesSerializer

  def initialize(dates)
    @dates = dates
  end

  def serialize
    @dates.keys.each do |chapter|
      ['last_updated', 'next_updated'].each do |date_type|
        chapter_dates = @dates[chapter]
        date = Date.strptime(chapter_dates[date_type], '%b-%y')

        chapter_dates[date_type] = date.strftime('%B %Y')
        chapter_dates["#{date_type}_year"] = date.strftime('%Y')
      end
    end

    @dates['home'] = @dates['chapter_3']

    @dates
  end
end