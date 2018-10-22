class ChaptersController < ApplicationController
  layout 'chapter'

  def chapter_1
    @chapter_number = 1
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))['title']
    @next_chapter_link = chapter_2_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-1.yml", 'r'))
  end

  def chapter_2
    @chapter_number = 2
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))['title']
    @next_chapter_link = chapter_3_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))
  end

  def chapter_3
    @chapter_number = 3
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))['title']
    @next_chapter_link = chapter_4_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))

    
    #TODO replace with real data
    @line_chart = {
      lines: [
        {
          title: "ABNJ",
          datapoints: [{ x: 1990, y: 0 }, { x: 1995, y: 10 }, { x: 2000, y: 20 }, { x: 2005, y: 30 }, { x: 2010, y: 40 }, { x: 2015, y: 50 }, { x: 2020, y: 60 }]
        },
        {
          title: "EEZ",
          datapoints: [{ x: 1990, y: 20 }, { x: 1995, y: 40 }, { x: 2000, y: 20 }, { x: 2005, y: 40 }, { x: 2010, y: 20 }, { x: 2015, y: 40 }, { x: 2020, y: 20 }]
        },
        {
          title: "Land",
          datapoints: [{ x: 1990, y: 14 }, { x: 1995, y: 23 }, { x: 2000, y: 34 }, { x: 2005, y: 56 }, { x: 2010, y: 43 }, { x: 2015, y: 23 }, { x: 2020, y: 32 }]
        }
      ]
    }
  end

  def chapter_4
    @chapter_number = 4
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))['title']
    @next_chapter_link = chapter_5_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))

    #TODO replace with real data
    @row_charts = [
      {
        title: "Ecoregions",
        charts: [
          {
            chart_title: "Terrestrial",
            rows: [
              {
                percent: 42.6,
                label: "2016"
              },
              {
                percent: 30.6,
                label: "2018"
              }
            ]
          },
          {
            chart_title: "Marine",
            rows: [
              {
                percent: 28.6,
                label: "2016"
              },
              {
                percent: 39.2,
                label: "2018"
              }
            ]
          }
        ]
      },
      {
        title: "Realms",
        charts: [
          {
            chart_title: "Terrestrial",
            rows: [
              {
                percent: 42.6,
                label: "2016"
              },
              {
                percent: 30.6,
                label: "2018"
              }
            ]
          },
          {
            chart_title: "Marine",
            rows: [
              {
                percent: 28.6,
                label: "2016"
              },
              {
                percent: 39.2,
                label: "2018"
              }
            ]
          }
        ]
      }
    ]
  end

  def chapter_5
    @chapter_number = 5
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))['title']
    @next_chapter_link = chapter_6_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))

    #TODO replace with real data and update variable name
    @stacked_row_charts = {
      legend: [
        {
          title: "1."
        },
        {
          title: "2."
        },
        {
          title: "3."
        },
        {
          title: "4."
        }
      ],
      charts: [
        {
          chart_title: "Terrestrial",
          rows: [
            {
              percent: 10,
              label: "1."
            },
            {
              percent: 30,
              label: "2."
            },
            {
              percent: 35,
              label: "3."
            },
            {
              percent: 25,
              label: "4."
            }
          ]
        },
        {
          chart_title: "Marine",
          rows: [
            {
              percent: 5,
              label: "1."
            },
            {
              percent: 25,
              label: "2."
            },
            {
              percent: 40,
              label: "3."
            },
            {
              percent: 30,
              label: "4."
            }
          ]
        }
      ]
    }

    #TODO replace with real data and update variable name
    @column_chart = [

    ]
  end

  def chapter_6
    @chapter_number = 6
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))['title']
    @next_chapter_link = chapter_7_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))
  end

  def chapter_7
    @chapter_number = 7
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))['title']
    @next_chapter_link = chapter_8_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))
  end

  def chapter_8
    @chapter_number = 8
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))['title']
    @next_chapter_link = chapter_9_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))
  end

  def chapter_9
    @chapter_number = 9
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))['title']
    @next_chapter_link = chapter_10_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))
  end

  def chater_10
    @chapter_number = 10
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))
  end
end