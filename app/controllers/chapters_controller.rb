class ChaptersController < ApplicationController
  layout 'chapter'

  def chapter_1
    @chapter_number = 1
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_2_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-1.yml", 'r'))

    @smallprint="Main sources: CBD technical note on ‘Biodiversity and the 2030 agenda for sustainable development’ and Natural Solutions briefing on ‘Protected areas helping to meet the Sustainable Development Goals’ prepared by Nigel Dudley, Natasha Ali and Kathy MacKinnon, October 2017."

    doughnut_chart = @data['doughnut_chart_data']
    @doughnut_chart = []

    doughnut_chart.each do |item|
      @doughnut_chart.push({
        'title': item['title'],
        'colour': item['colour'],
        'icon': ActionController::Base.helpers.image_url(item['icon']),
        'description': item['description'],
        'url': item['url']
      })
    end
  end

  def chapter_2
    @chapter_number = 2
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_3_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))

    @mapbox = {
      source: "(Source text)",
      layers: [
        {
          title: "Terrestrial Protected Areas",
          percentage: 10
        },
        {
          title: "Marine & Coastal Protected Areas",
          percentage: 10,
          sublayers: [
            {
              title: "Exclusive Economic Zones (EEZ)",
              percentage: 10,
            },
            {
              title: "Areas beyond National Jurisdiction (ABNJ)",
              percentage: 10,
            }
          ]
        }
      ]
    }

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
          cssPercent: 71,
          protected_areas: {
            title: "1.",
            percent: 7.44
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
          cssPercent: 29,
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
          cssPercent: 43.31, #percentage of the world [71(ocean)* 0.61(abnj)]
          class: "abnj",
          protected_areas: {
            title: "1.",
            percent: 17.3
          }
        },
        {
          title: "EEZ",
          percent: 39,
          cssPercent: 27.69, #percentage of the world [71(ocean)* 0.39(abnj)]
          class: "eez",
          protected_areas: {
            title: "1.",
            percent: 1.18
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
          cssPercent: 29,
          active: false,
          protected_areas: {
            title: "1.",
            percent: 15
          }
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
      axis: {
        y: ["Area", "(Million km2)"]
      },
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
          line: true,
          label: "4"
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

    @map = {
      legend: [
        {
          title: 'Data deficient'
        },
        {
          title: '0 - 10%'
        },
        {
          title: '10% - 50%'
        },
        {
          title: '50% - 100%'
        }
      ]
    }
  end

  def chapter_3
    @chapter_number = 3
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_4_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))

    @mapbox = {
      source: "(Source text)",
      layers: [
        {
          title: "Fully within Protected Area's",
          percentage: 10
        },
        {
          title: "Partially within Protected Area's",
          percentage: 10
        },
        {
          title: "Outside Protected Area's",
          percentage: 10
        }
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
      axis: {
        y: ["Area", "(Million km2)"]
      },
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
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))['menu_title']
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

    @map = {
      legend: [
        {
          title: 'Data deficient'
        },
        {
          title: '0 - 10%'
        },
        {
          title: '10% - 50%'
        },
        {
          title: '50% - 100%'
        }
      ]
    }
  end

  def chapter_5
    @chapter_number = 5
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_6_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))

    @map = {
      legend: [
        {
          title: 'Data deficient'
        },
        {
          title: '0 - 10%'
        },
        {
          title: '10% - 50%'
        },
        {
          title: '50% - 100%'
        }
      ]
    }

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
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))['menu_title']
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
      theme: 'rainbow',
      legend: [
        {
          title: "Government "
        },
        {
          title: "Indigenous peoples and local communties"
        },
        {
          title: "Shared"
        },
        {
          title: "Not Reported"
        }
      ],
      charts: [
        {
          chart_title: "ABNJ",
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
          chart_title: "West Asia",
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
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_8_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))

    @mapbox = {
      source: "(Source text)",
      layers: [
        {
          title: '<4'
        },
        {
          title: '<4% - 8%'
        },
        {
          title: '<8% - 12%'
        },
        {
          title: '<12% - 17%'
        },
        {
          title: '<17% - 25%'
        },
        {
          title: '>25%'
        }
      ]
    }

    @map = {
      legend: [
        {
          title: 'Data deficient'
        },
        {
          title: '0 - 10%'
        },
        {
          title: '10% - 50%'
        },
        {
          title: '50% - 100%'
        }
      ]
    }
  end

  def chapter_8
    @chapter_number = 8
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_9_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))
  end

  def chapter_9
    @chapter_number = 9
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_10_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))
  end

  def chapter_10
    @chapter_number = 10
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))
  end
end
