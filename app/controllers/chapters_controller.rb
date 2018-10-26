class ChaptersController < ApplicationController
  layout 'chapter'

  def chapter_1
    @chapter_number = 1
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))['title']
    @next_chapter_link = chapter_2_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-1.yml", 'r'))

    @smallprint="Main sources: CBD technical note on ‘Biodiversity and the 2030 agenda for sustainable development’ and Natural Solutions briefing on ‘Protected areas helping to meet the Sustainable Development Goals’ prepared by Nigel Dudley, Natasha Ali and Kathy MacKinnon, October 2017."
    
    @doughnut_chart = [
      {
        title: "No poverty",
        colour: "#E5243B",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Zero hunger",
        colour: "#DDA63A",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Good Health and Well-being",
        colour: "#4C9F38",
        description: "The link between biodiversity and human health is increasingly recognized. By protecting ecosystems, protected areas help mitigate the spread and impact of pollution. For instance, protecting forests help regulate water flow and improve water quality. Medicines are also be derived from biodiversity. Finally, by offering recreational opportunities, protected areas also contribute to enhancing physical and mental well-being.",
        url: "http://google.com"
      },
      {
        title: "Quality education",
        colour: "#C5192D",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Gender equality",
        colour: "#FF3A21",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Clean water and sanitation",
        colour: "#26BDE2",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Affordable and clean energy",
        colour: "#FCC30B",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Decent work and economic growth",
        colour: "#A21942",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Industry, innovation and infrastructure",
        colour: "#FD6925",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Reduced inequalities",
        colour: "#DD1367",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Sustainable cites and communities",
        colour: "#FD9D24",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Responsible consumption and production",
        colour: "#BF8B2E",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Climate action",
        colour: "#3F7E44",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Life below water",
        colour: "#0A97D9",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Life on land",
        colour: "#56C02B",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Peace, justice and strong institutions",
        colour: "#00689D",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Partnerships for the goals",
        colour: "#19486A",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      }
    ].to_json
  end

  def chapter_2
    @chapter_number = 2
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))['title']
    @next_chapter_link = chapter_3_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))

    @global_area_chart = {
      datasets: [
        {
          title: "Ocean",
          class: "marine",
          percent: 70
        },
        {
          title: "Land",
          class: "land",
          percent: 30
        }
      ]
    }

    @pa_area_chart = {
      legend: [
        {
          title: "1. Proportion of cover by protected areas"
        }
      ],
      datasets: [
        {
          title: "ABNJ",
          percent: 30,
          class: "marine",
          protected_areas: {
            title: "1.",
            percent: 5
          }
        },
        {
          title: "EEZ",
          percent: 40,
          class: "marine",
          protected_areas: {
            title: "1.",
            percent: 10
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 30,
          protected_areas: {
            title: "1.",
            percent: 20
          }
        },
      ]
    }
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
          datapoints: [{ x: 1990, y: 0 }, { x: 1995, y: 10 }, { x: 2000, y: 20 }, { x: 2005, y: 30 }, { x: 2010, y: 40 }, { x: 2015, y: 50 }, { x: 2020, y: 60 }]
        },
        {
          datapoints: [{ x: 1990, y: 20 }, { x: 1995, y: 40 }, { x: 2000, y: 20 }, { x: 2005, y: 40 }, { x: 2010, y: 20 }, { x: 2015, y: 40 }, { x: 2020, y: 20 }]
        },
        {
          datapoints: [{ x: 1990, y: 14 }, { x: 1995, y: 23 }, { x: 2000, y: 34 }, { x: 2005, y: 56 }, { x: 2010, y: 43 }, { x: 2015, y: 23 }, { x: 2020, y: 32 }]
        }
      ],
      targets: [
        { 
          y: 40,
          title: "Marine target (10%)"
        },
        {
          y: 36,
          title: "Terrestrial target (17%)"
        }
      ],
      legend: [
        {
          title: "1. ABNJ"
        },
        {
          title: "2. EEZ"
        },
        {
          title: "3. Land"
        },
        {
          title: "4. Commitments"
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

    @column_chart = [
      {
        label: 'Africa',
        percent: 76
      },
      {
        label: 'Asia & Pacific',
        percent: 87
      },
      {
        label: 'Europe',
        percent: 43
      },
      {
        label: 'Latin America & Caribbean',
        percent: 20
      },
      {
        label: 'North America',
        percent: 46
      },
      {
        label: 'Polar',
        percent: 53
      },
      {
        label: 'West Asia',
        percent: 45
      },
    ].to_json
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