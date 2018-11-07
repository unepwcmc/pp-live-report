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
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-01.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Zero hunger",
        colour: "#DDA63A",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-02.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Good Health and Well-being",
        colour: "#4C9F38",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-03.png'),
        description: "The link between biodiversity and human health is increasingly recognized. By protecting ecosystems, protected areas help mitigate the spread and impact of pollution. For instance, protecting forests help regulate water flow and improve water quality. Medicines are also be derived from biodiversity. Finally, by offering recreational opportunities, protected areas also contribute to enhancing physical and mental well-being.",
        url: "http://google.com"
      },
      {
        title: "Quality education",
        colour: "#C5192D",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-04.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Gender equality",
        colour: "#FF3A21",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-05.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Clean water and sanitation",
        colour: "#26BDE2",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-06.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Affordable and clean energy",
        colour: "#FCC30B",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-07.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Decent work and economic growth",
        colour: "#A21942",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-08.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Industry, innovation and infrastructure",
        colour: "#FD6925",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-09.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Reduced inequalities",
        colour: "#DD1367",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-10.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Sustainable cites and communities",
        colour: "#FD9D24",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-11.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Responsible consumption and production",
        colour: "#BF8B2E",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-12.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Climate action",
        colour: "#3F7E44",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-13.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Life below water",
        colour: "#0A97D9",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-14.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Life on land",
        colour: "#56C02B",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-15.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Peace, justice and strong institutions",
        colour: "#00689D",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-16.png'),
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        url: "http://google.com"
      },
      {
        title: "Partnerships for the goals",
        colour: "#19486A",
        icon: ActionController::Base.helpers.image_url('icons/sdg-goal-17.png'),
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
      id: "global-area-chart",
      legend: [
        {
          title: "Proportion of cover by protected areas"
        }
      ],
      datasets: [
        {
          title: "Ocean",
          class: "marine",
          percent: 71,
          protected_areas: {
            title: "1.",
            percent: 7.44
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
          protected_areas: {
            title: "1.",
            percent: 15
          }
        }
      ]
    }

    @marine_area_chart = {
      id: "marine-area-chart",
      legend: [
        {
          title: "Proportion of cover by protected areas"
        }
      ],
      datasets: [
        {
          title: "ABNJ",
          percent: 61,
          class: "marine",
          protected_areas: {
            title: "1.",
            percent: 17.3
          }
        },
        {
          title: "EEZ",
          percent: 39,
          class: "marine",
          protected_areas: {
            title: "1.",
            percent: 1.18
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
          active: false
        },
      ]
    }

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
      commitments: [
        {
          x: 2018,
          line: true
        }
      ],
      legend: [
        {
          title: "ABNJ"
        },
        {
          title: "EEZ"
        },
        {
          title: "Land"
        },
        {
          title: "Commitments",
          line: true
        }
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
      legend: [
        {
          title: "1. ABNJ"
        },
        {
          title: "2. EEZ"
        },
        {
          title: "3. Land"
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
            theme: "green",
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
            theme: "blue",
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
            theme: "green",
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
            theme: "blue",
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
          title: "Over 60%"
        },
        {
          title: "30-60%"
        },
        {
          title: "10-30%"
        },
        {
          title: "Under 10%"
        }
      ],
      charts: [
        {
          chart_title: "Terrestrial",
          theme: "green",
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
          theme: "blue",
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