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
    global_data = CsvParser.global_coverage_stats
    land_percentage = global_data.select { |d| d['Type'].include?('Total for the land') }.first['PAs %']
    sea_percentage = global_data.select { |d| d['Type'].include?('Total for the sea') }.first['PAs %']
    eez_percentage = global_data.select{ |d| d['Type'].include?('Economic') }.first['PAs %']
    abnj_percentage = global_data.select{ |d| d['Type'].include?('ABNJ') }.first['PAs %']

    @mapbox = {
      source: "(Source text)",
      layers: [
        {
          title: "Terrestrial Protected Areas",
          percentage: land_percentage
        },
        {
          title: "Marine & Coastal Protected Areas",
          percentage: sea_percentage,
          sublayers: [
            {
              title: "Exclusive Economic Zones (EEZ)",
              percentage: eez_percentage
            },
            {
              title: "Areas beyond National Jurisdiction (ABNJ)",
              percentage: abnj_percentage
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
<<<<<<< HEAD
          cssPercent: 71,
=======
>>>>>>> fix timeseries data displayed
          protected_areas: {
            title: "1.",
            percent: sea_percentage
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
<<<<<<< HEAD
          cssPercent: 29,
=======
>>>>>>> fix timeseries data displayed
          protected_areas: {
            title: "1.",
            percent: land_percentage
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
<<<<<<< HEAD
          cssPercent: 43.31, #percentage of the world [71(ocean)* 0.61(abnj)]
          class: "abnj",
=======
          class: "marine",
>>>>>>> fix timeseries data displayed
          protected_areas: {
            title: "1.",
            percent: abnj_percentage
          }
        },
        {
          title: "EEZ",
          percent: 39,
<<<<<<< HEAD
          cssPercent: 27.69, #percentage of the world [71(ocean)* 0.39(abnj)]
          class: "eez",
=======
          class: "marine",
>>>>>>> fix timeseries data displayed
          protected_areas: {
            title: "1.",
            percent: eez_percentage
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
            percent: land_percentage
          }
        },
      ]
    }

    timeseries_data = CsvParser.timeseries
    lines = []
    %w[ABNJ EEZ Land].each do |type|
      datapoints = []
      ('1990'..'2018').each do |year|
        datapoints << { x: year, y: timeseries_data[year][type].round(2) }
      end
      lines << { datapoints: datapoints }
    end
    @line_chart = {
      lines: lines,
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

    kba_data = CsvParser.kba_timeseries
    lines = []
    ['Terrestrial KBAs', 'Marine KBAs', 'Freshwater KBAs'].each do |type|
      datapoints = []
      ('2000'..'2018').each do |year|
        datapoints << { x: year, y: kba_data[year][type] }
      end
      lines << { datapoints: datapoints }
    end
    @line_chart = {
      lines: lines,
      axis: {
        y: ["Area", "(Million km2)"]
      },
      legend: [
        {
          title: "Terrestrial"
        },
        {
          title: "Marine"
        },
        {
          title: "Freshwater"
        }
      ]
    }
  end

  def chapter_4
    @chapter_number = 4
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_5_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))

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
    @row_charts = CsvParser.biogeographical_regions
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

    progress_level_data = CsvParser.progress_level('Figue 11 PAME_JUL18_GROUPING.csv', 'Type')
    terrestrial = progress_level_data['Land']
    marine = progress_level_data['Marine']
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
        },
        {
          title: 'No Assessments'
        }
      ],
      charts: [
        {
          chart_title: "Terrestrial",
          theme: "green",
          rows: [
            {
              percent: terrestrial['Over 60%'],
              label: "1."
            },
            {
              percent: terrestrial['30-60%'],
              label: "2."
            },
            {
              percent: terrestrial['10-30%'],
              label: "3."
            },
            {
              percent: terrestrial['Under 10%'],
              label: "4."
            },
            {
              percent: terrestrial['No Assessments'],
              label: "5."
            }
          ]
        },
        {
          chart_title: "Marine",
          theme: "blue",
          rows: [
            {
              percent: marine['Over 60%'],
              label: "1."
            },
            {
              percent: marine['30-60%'],
              label: "2."
            },
            {
              percent: marine['10-30%'],
              label: "3."
            },
            {
              percent: marine['Under 10%'],
              label: "4."
            },
            {
              percent: marine['No Assessments'],
              label: "5."
            }
          ]
        }
      ]
    }

    column_chart_data = CsvParser.country_perc('Figure 12 PAME_JUL18_REGIONAL.csv', 'PER_PAME_COVERAGE')
    @column_chart = [
      {
        label: 'Africa',
        percent: column_chart_data['Africa']
      },
      {
        label: 'Asia & Pacific',
        percent: column_chart_data['Asia + Pacific']
      },
      {
        label: 'Europe',
        percent: column_chart_data['Europe']
      },
      {
        label: 'Latin America & Caribbean',
        percent: column_chart_data['Latin America + Caribbean']
      },
      {
        label: 'North America',
        percent: column_chart_data['North America']
      },
      {
        label: 'Polar',
        percent: column_chart_data['Polar']
      },
      {
        label: 'West Asia',
        percent: column_chart_data['West Asia']
      }
    ].to_json

    column_chart_data_2 = CsvParser.country_perc('Figure_13.csv', 'Count of PAME evaluations')
    @column_chart_2 = [
      {
        label: 'Africa',
        percent: column_chart_data_2['Africa']
      },
      {
        label: 'Asia & Pacific',
        percent: column_chart_data_2['Asia + Pacific']
      },
      {
        label: 'Europe',
        percent: column_chart_data_2['Europe']
      },
      {
        label: 'Latin America & Caribbean',
        percent: column_chart_data_2['Latin America + Caribbean']
      },
      {
        label: 'North America',
        percent: column_chart_data_2['North America']
      },
      {
        label: 'Polar',
        percent: column_chart_data_2['Polar']
      },
      {
        label: 'West Asia',
        percent: column_chart_data_2['West Asia']
      }
    ].to_json
  end

  def chapter_6
    @governance_chart = []
    @chapter_number = 6
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))['title']
    @next_chapter_link = chapter_7_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))

    governance_types_data = CsvParser.governance_type

    governance_types_data.each do |data|
      @governance_chart << {
        label: data.keys.first.to_s,
        percent: data.values.first
      }
    end
    @governance_chart = @governance_chart.to_json

    country_governance_data = CsvParser.progress_level('chapter 6 Box_10_second_figure (2).csv', 'Region')
    legend = []
    country_governance_data.first.second.keys.each do |gov|
      legend << { title: gov }
    end
    data_array = []
    country_governance_data.each do |k, hash|
      charts = {}
      rows = []
      charts[:chart_title] = k
      count = 1
      hash.each do |_, value|
        rows << {
          percent: value,
          label: "#{count}."
        }
        count += 1
      end
      charts[:rows] = rows
      data_array << charts
    end

    @stacked_row_charts = {
      theme: 'rainbow',
      legend: legend,
      charts: data_array
    }.to_json
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

    @mapbox = {
      source: "(Source text)",
      layers: [
        {
          title: 'Protected Areas'
        },
        {
          title: 'Areas of low human impact'
        }
      ]
    }
  end

  def chapter_10
    @chapter_number = 10
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))
  end
end
