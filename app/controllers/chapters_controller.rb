class ChaptersController < ApplicationController
  include Helpers
  include ApplicationHelper
  layout 'chapter'

  def chapter_1
    @chapter_number = 1
    @chapter_last_updated = 'May 2019'
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
    @chapter_last_updated = 'May 2019'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_3_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-2.yml", 'r'))
    global_data = CsvParser.global_coverage_stats
    land_percentage = global_data.select { |d| d['Type'].include?('Total for the land') }.first['PAs %']
    sea_percentage = global_data.select { |d| d['Type'].include?('Total for the sea') }.first['PAs %']
    eez_percentage = global_data.select{ |d| d['Type'].include?('Economic') }.first['PAs %']
    abnj_percentage = global_data.select{ |d| d['Type'].include?('ABNJ') }.first['PAs %']

    @map_1 = {
      id: "map_1",
      tiles_url: "https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch2_Fg1/VectorTileServer/tile/{z}/{y}/{x}.pbf",
      layers: [
        {
          id: "terrestrial-" + random_number,
          text_large: land_percentage + '%',
          text_small: "Terrestrial Protected Areas",
          source_layers: {poly: 'WDPA_poly_Mar2019_terrestrial', point: 'WDPA_point_Mar2019_terrestrial'},
          colour: "#86BF37"
        },
        {
          id: "marine-" + random_number,
          text_large: sea_percentage + '%',
          text_small: "Marine & Coastal Protected Areas",
          source_layers: {poly: 'WDPA_poly_Mar2019_Mar_Coast', point: 'WDPA_point_Mar2019_Mar_Coast'},
          colour: "#133151",
          sublayers: [
            {
              id: "eez-" + random_number,
              text_large: eez_percentage + '%',
              text_small: "Exclusive Economic Zones (EEZ)",
              source_layers: {poly: 'WDPA_poly_Mar2019_EEZ', point: 'WDPA_point_Mar2019_EEZ'},
              colour: "#6FD9F2"
            },
            {
              id: "abnj-" + random_number,
              text_large: abnj_percentage + '%',
              text_small: "Areas beyond National Jurisdiction (ABNJ)",
              source_layers: {poly: 'WDPA_poly_Mar2019_ABNJ', point: 'WDPA_point_Mar2019_ABNJ'},
              colour: "#207D94"
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
            percent: sea_percentage
          }
        },
        {
          title: "Land",
          class: "land",
          percent: 29,
          cssPercent: 29,
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
          percent: 43,
          cssPercent: 43.31, #percentage of the world [71(ocean)* 0.61(abnj)]
          class: "abnj",
          protected_areas: {
            title: "1.",
            percent: abnj_percentage
          }
        },
        {
          title: "EEZ",
          percent: 28,
          cssPercent: 27.69, #percentage of the world [71(ocean)* 0.39(eez)]
          class: "eez",
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
      ('1990'..'2020').each do |year|
        datapoints << { x: year, y: timeseries_data[year][type].round(2) }
      end
      lines << { datapoints: datapoints }
    end
    @line_chart = {
      lines: lines,
      axis: {
        y: ["Area", "(Million km²)"]
      },
      targets: [
        {
          y: 36,
          title: "Marine target (10%)"
        },
        {
          y: 23,
          title: "Terrestrial target (17%)"
        }
      ],
      commitments: [
        {
          x: 2018,
          line: true,
          label: ["Future", "Commitments"]
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
        }
      ]
    }

    @map_2 = {
      countries: CsvMapParser.categ_country_stats('Monthly_PA_National_Coverage_Jan19_categorical.csv'),
      legend: [
        { title: 'Data deficient', value: 'default' },
        { title: 'Under 5%', value: 1 },
        { title: '5% - 10%', value: 2 },
        { title: '10% - 17%', value: 3 },
        { title: 'Over 17%', value: 4 }
      ],
      palette: [
        '#B3CDE3',
        '#3F67AC',
        '#8856A7',
        '#810F7C'
      ]
    }

    @map_3 = {
      id: "map_3",
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'over-ten-' + random_number,
          text_large: 'Over 10%',
          source_layers: { poly: 'Ch2_Fg5_Mar' },
          filter_id: 6,
          colour: '#453385'
        },
        {
          id: 'six-to-ten-' + random_number,
          text_large: '6% - 10%',
          source_layers: { poly: 'Ch2_Fg5_Mar' },
          filter_id: 5,
          colour: '#64579a'
        },
        {
          id: 'three-to-six-' + random_number,
          text_large: '3% – 6%',
          source_layers: { poly: 'Ch2_Fg5_Mar' },
          filter_id: 4,
          colour: '#8479af'
        },
        {
          id: 'less-than-3-' + random_number,
          text_large: 'Under 3%',
          source_layers: { poly: 'Ch2_Fg5_Mar' },
          filter_id: 3,
          colour: '#a59cc4'
        },
        {
          id: 'data-deficient-' + random_number,
          text_large: 'Data deficient',
          source_layers: { poly: 'Ch2_Fg5_Mar' },
          filter_id: 2,
          colour: '#A6A6A6'
        }
      ]
    }
  end

  def chapter_3
    @chapter_number = 3
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_4_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-3.yml", 'r'))
    @percentage = CsvMapParser.percentage_stats('Ch3_map_percentage.csv')

    @map_1 = {
      id: 'kba',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch3_Fg6/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'inside-' + random_number,
          text_large: @percentage['Within'],
          text_small: "Fully within Protected Areas",
          source_layers: { poly: 'KBAs_fully_within' },
          colour: '#2179a7',
        },
        {
          id: 'partial-' + random_number,
          text_large: @percentage['Partially'],
          text_small: "Partially within Protected Areas",
          source_layers: { poly: 'KBAs_partially_within' },
          colour: '#86bf37',
        },
        {
          id: 'outside-' + random_number,
          text_large: @percentage['Outside'],
          text_small: "Outside Protected Areas",
          source_layers: { poly: 'KBAs_not_within' },
          colour: '#E9624D',
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
        y: ["Area", "(Million km²)"]
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
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_5_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-4.yml", 'r'))

    @map_1 = {
      id: "map_1",
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch4_Fg8/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: 'under-5' + random_number,
              text_large: 'Under 5%',
              colour: '#a59cc4',
              source_layers: { poly: 'Ch4_Fg8_tcat1_noATA' }
            },
            {
              id: 'five-to-ten' + random_number,
              text_large: '5% - 10%',
              colour: '#8479af',
              source_layers: { poly: 'Ch4_Fg8_tcat2' }
            },
            {
              id: 'ten-to-seventeen' + random_number,
              text_large: '10% - 17%',
              colour: '#64579a',
              source_layers: { poly: 'Ch4_Fg8_tcat3' }
            },
            {
              id: 'over-seventeen' + random_number,
              text_large: 'Over 17%',
              colour: '#453385',
              source_layers: { poly: 'Ch4_Fg8_tcat4' }
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'under-3' + random_number,
              text_large: 'Under 3%',
              colour: '#a59cc4',
              source_layers: { poly: 'Ch4_Fg8_mcat5' }
            },
            {
              id: 'three-to-six' + random_number,
              text_large: '3% - 6%',
              colour: '#8479af',
              source_layers: { poly: 'Ch4_Fg8_mcat6' }
            },
            {
              id: 'six-to-ten' + random_number,
              text_large: '6% - 10%',
              colour: '#64579a',
              source_layers: { poly: 'Ch4_Fg8_mcat7' }
            },
            {
              id: 'over-ten' + random_number,
              text_large: 'Over 10%',
              colour: '#453385',
              source_layers: { poly: 'Ch4_Fg8_mcat8' }
            }
          ]
        },
        {
          title: 'Province',
          layers: [
            {
              id: 'under-3' + random_number,
              text_large: 'Under 3%',
              colour: '#a59cc4',
              source_layers: { poly: 'Ch4_Fg8_mcat9' }
            },
            {
              id: 'three-to-six' + random_number,
              text_large: '3% - 6%',
              colour: '#8479af',
              source_layers: { poly: 'Ch4_Fg8_mcat10' }
            },
            {
              id: 'six-to-ten' + random_number,
              text_large: '6% - 10%',
              colour: '#64579a',
              source_layers: { poly: 'Ch4_Fg8_mcat11' }
            },
            {
              id: 'over-ten' + random_number,
              text_large: 'Over 10%',
              colour: '#453385',
              source_layers: { poly: 'Ch4_Fg8_mcat12' }
            }
          ]
        }
      ]
    }

    @map_2 = {
      id: 'map_2',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch4_Fg9/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: 'under-ten' + random_number,
              text_large: 'Under -10%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 2,
              colour: '#A6A6A6'
            },
            {
              id: 'ten-to-five' + random_number,
              text_large: '-10% - -5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 3,
              colour: '#a59cc4'
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% - 0%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 4,
              colour: '#8479af'
            },
            {
              id: 'zero-to-five' + random_number,
              text_large: '0% - +5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 5,
              colour: '#64579a'
            },
            {
              id: 'over-five' + random_number,
              text_large: 'Over +5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 6,
              colour: '#453385'
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'under-five' + random_number,
              text_large: 'Under -5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 2,
              colour: '#A6A6A6'
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% - 0%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 3,
              colour: '#a59cc4'
            },
            {
              id: 'zero-to-two' + random_number,
              text_large: '0% - +2.5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 4,
              colour: '#8479af'
            },
            {
              id: 'two-to-five' + random_number,
              text_large: '2.5% - +5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 5,
              colour: '#64579a'
            },
            {
              id: 'over-five' + random_number,
              text_large: 'Over +5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 6,
              colour: '#453385'
            }
          ]
        },
        {
          title: 'Province',
          layers: [
            {
              id: 'under-five' + random_number,
              text_large: 'Under -5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 2,
              colour: '#A6A6A6'
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% - 0%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 3,
              colour: '#a59cc4'
            },
            {
              id: 'zero-to-two' + random_number,
              text_large: '0% - +2.5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 4,
              colour: '#8479af'
            },
            {
              id: 'two-to-five' + random_number,
              text_large: '+2.5% - +5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 5,
              colour: '#64579a'
            },
            {
              id: 'over-five' + random_number,
              text_large: 'Over +5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 6,
              colour: '#453385'
            }
          ]
        }
      ]
    }

    @row_charts = CsvParser.biogeographical_regions
  end

  def chapter_5
    @chapter_number = 5
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_6_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))

    @map = {
      countries: CsvMapParser.categ_country_stats('Ch5_Figure_10_categorical.csv'),
      legend: [
        { title: 'No Assessments', value: 'default' },
        { title: 'Under 10%', value: 1 },
        { title: '10% - 30%', value: 2 },
        { title: '30% - 60%', value: 3 },
        { title: 'Over 60%', value: 4 }
      ],
      palette: [
        '#B3CDE3',
        '#3F67AC',
        '#8856A7',
        '#810F7C'
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
              percent: terrestrial['Over 60%'].to_f.round,
              label: "1."
            },
            {
              percent: terrestrial['30-60%'].to_f.round,
              label: "2."
            },
            {
              percent: terrestrial['10-30%'].to_f.round,
              label: "3."
            },
            {
              percent: terrestrial['Under 10%'].to_f.round,
              label: "4."
            },
            {
              percent: 29,
              label: "5."
            }
          ]
        },
        {
          chart_title: "Marine",
          theme: "blue",
          rows: [
            {
              percent: 16,
              label: "1."
            },
            {
              percent: marine['30-60%'].to_f.round,
              label: "2."
            },
            {
              percent: marine['10-30%'].to_f.round,
              label: "3."
            },
            {
              percent: marine['Under 10%'].to_f.round,
              label: "4."
            },
            {
              percent: marine['No Assessments'].to_f.round,
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
        percent: column_chart_data['Africa'],
        value: "#{column_chart_data['Africa']}%"
      },
      {
        label: 'Asia & Pacific',
        percent: column_chart_data['Asia + Pacific'],
        value: "#{column_chart_data['Asia + Pacific']}%"
      },
      {
        label: 'Europe',
        percent: column_chart_data['Europe'],
        value: "#{column_chart_data['Europe']}%"
      },
      {
        label: 'Latin America & Caribbean',
        percent: column_chart_data['Latin America + Caribbean'],
        value: "#{column_chart_data['Latin America + Caribbean']}%"
      },
      {
        label: 'North America',
        percent: column_chart_data['North America'],
        value: "#{column_chart_data['North America']}%"
      },
      {
        label: 'Polar',
        percent: column_chart_data['Polar'],
        value: "#{column_chart_data['Polar']}%"
      },
      {
        label: 'West Asia',
        percent: column_chart_data['West Asia'],
        value: "#{column_chart_data['West Asia']}%"
      }
    ].to_json

    column_chart_data_2 = CsvParser.country_perc('Figure_13.csv', 'Count of PAME evaluations')
    column_chart_data_2.each{|key,value| column_chart_data_2[key] = commaify(value.to_i)}
    # byebug
    @column_chart_2 = [
      {
        label: 'Africa',
        percent: 13,
        value: column_chart_data_2['Africa']
      },
      {
        label: 'Asia & Pacific',
        percent: 38,
        value: column_chart_data_2['Asia + Pacific']
      },
      {
        label: 'Europe',
        percent: 92,
        value: column_chart_data_2['Europe']
      },
      {
        label: 'Latin America & Caribbean',
        percent: 14,
        value: column_chart_data_2['Latin America + Caribbean']
      },
      {
        label: 'North America',
        percent: 0.089,
        value: column_chart_data_2['North America']
      },
      {
        label: 'Polar',
        percent: 0,
        value: column_chart_data_2['Polar']
      },
      {
        label: 'West Asia',
        percent: 0.033,
        value: column_chart_data_2['West Asia']
      }
    ].to_json
  end

  def chapter_6
    values = ['194,836', '7,632', '13,105', '1,377', '21,613']
    @column_chart = []
    @chapter_number = 6
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))['title']
    @next_chapter_link = chapter_7_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))

    governance_types_data = CsvParser.governance_type

    governance_types_data.each_with_index do |data, index|
      @column_chart << {
        label: data.keys.first.to_s,
        value: values[index],
        percent: data.values.first
      }
    end
    @column_chart = @column_chart.to_json

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
          percent: value.round(1),
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
    }
  end

  def chapter_7
    @chapter_number = 7
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_8_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))

    @map_1 = {
      countries: CsvMapParser.categ_country_stats('Ch7_Figure_14_categorical.csv'),
      legend: [
        { title: 'Under 4%', value: 'default' },
        { title: '4% - 8%', value: 1 },
        { title: '8% - 12%', value: 2 },
        { title: '12% - 17%', value: 3 },
        { title: '17% - 25%', value: 4 },
        { title: 'Over 25%', value: 5 }
      ],
      palette: [
        '#B3CDE3',
        '#3F67AC',
        '#8856A7',
        '#810F7C',
        '#3F006B'
      ]
    }

    @map_2 = {
      countries: CsvMapParser.categ_country_stats('Ch7_Figure_15_AB_categorical.csv'),
      legend: [
        { title: 'A1. General increase of PA coverage', value: 1 },
        { title: 'A2. Targeted designation of connecting PAs', value: 2 },
        { title: 'B1 + B2. Permeability of unprotected lands (B1) and coordinated management of adjacent PAs (B2)', value: 3 },
        { title: 'B1. Permeability of unprotected lands between PAs', value: 4 },
        { title: 'B2. Coordinated management of adjacent PAs in the country', value: 5 },
        { title: 'B3. No specific priority other than PA management effectiveness for connectivity', value: 6 },
      ],
      palette: ['#2179A7', '#53CCF7', '#9A014F', '#E9624D', '#F7BA02', '#86BF37', '#423781']
    }

    @map_3 = {
      countries: CsvMapParser.categ_country_stats('Ch7_Figure_15_C_categorical.csv'),
      legend: [
        { title: 'C. Coordinated management of transboundary PA linkages', value: 7 }
      ],
      palette: ['#2179A7', '#53CCF7', '#9A014F', '#E9624D', '#F7BA02', '#86BF37', '#423781']
    }
  end

  def chapter_8
    @chapter_number = 8
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_9_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-8.yml", 'r'))
  end

  def chapter_9
    @chapter_number = 9
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_10_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-9.yml", 'r'))

    @map_1 = {
      id: "map_1",
      tiles_url: "https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch9_Fg/VectorTileServer/tile/{z}/{y}/{x}.pbf",
      layers: [
        {
          id: 'wild' + random_number,
          text_small: 'Wild',
          source_layers: { poly: 'LWPv2_Low_Impact_wild' },
          colour: '#2179a7'
        },
        {
          id: 'not-wild' + random_number,
          text_small: 'Not wild',
          source_layers: { poly: 'LWPv2_Low_Impact_notwild' },
          colour: '#E9624D'
        },
        {
          id: 'protected-areas' + random_number,
          text_small: 'Protected areas',
          source_layers: {poly: 'WDPA_poly_Mar2019', point: 'WDPA_point_Mar2019'},
          colour: '#86bf37'
        }
      ]
    }
  end

  def chapter_10
    @chapter_number = 10
    @chapter_last_updated = 'July 2018'
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-10.yml", 'r'))
  end
end
