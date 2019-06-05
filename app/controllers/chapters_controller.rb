class ChaptersController < ApplicationController
  include Helpers
  layout 'chapter'

  DEFAULT_COLOUR = '#A6A6A6'.freeze
  TRICOLOR_PALETTE = [
    '#66c2a5',
    '#8da0cb',
    '#fc8d62'
  ].freeze
  BLUE_PURPLE_SCHEME = [
    '#B3CDE3',
    '#8c96c6',
    '#8856A7',
    '#810F7C',
    '#4d004b'
  ].freeze

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
    @chapter_last_updated = 'June 2019'
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
          text_small: "of terrestrial areas",
          source_layers: {poly: 'WDPA_poly_Mar2019_terrestrial', point: 'WDPA_point_Mar2019_terrestrial'},
          colour: "#86BF37"
        },
        {
          id: "marine-" + random_number,
          text_large: sea_percentage + '%',
          text_small: "of marine areas",
          source_layers: {poly: 'WDPA_poly_Mar2019_Mar_Coast', point: 'WDPA_point_Mar2019_Mar_Coast'},
          colour: "#133151",
          sublayers: [
            {
              id: "eez-" + random_number,
              text_large: eez_percentage + '%',
              text_small: "of the global EEZ",
              source_layers: {poly: 'WDPA_poly_Mar2019_EEZ', point: 'WDPA_point_Mar2019_EEZ'},
              colour: "#6FD9F2"
            },
            {
              id: "abnj-" + random_number,
              text_large: abnj_percentage + '%',
              text_small: "of global ABNJ",
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
      countries: CsvMapParser.ch2_map2_categorical,
      legend: [
        { title: 'Data deficient', value: 'default' },
        { title: 'Under 5%', value: 1 },
        { title: '5% - 10%', value: 2 },
        { title: '10% - 17%', value: 3 },
        { title: 'Over 17%', value: 4 }
      ],
      palette: BLUE_PURPLE_SCHEME
    }

    @map_3 = {
      id: "map_3",
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch2_Fg5_June19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'over-ten-' + random_number,
          text_large: 'Over 10%',
          source_layers: { poly: 'ch2_eez_coverage' },
          filter_id: 6,
          colour: BLUE_PURPLE_SCHEME[3]
        },
        {
          id: 'six-to-ten-' + random_number,
          text_large: '6% - 10%',
          source_layers: { poly: 'ch2_eez_coverage' },
          filter_id: 5,
          colour: BLUE_PURPLE_SCHEME[2]
        },
        {
          id: 'three-to-six-' + random_number,
          text_large: '3% – 6%',
          source_layers: { poly: 'ch2_eez_coverage' },
          filter_id: 4,
          colour: BLUE_PURPLE_SCHEME[1]
        },
        {
          id: 'less-than-3-' + random_number,
          text_large: 'Under 3%',
          source_layers: { poly: 'ch2_eez_coverage' },
          filter_id: 3,
          colour: BLUE_PURPLE_SCHEME[0]
        },
        {
          id: 'data-deficient-' + random_number,
          text_large: 'Data deficient',
          source_layers: { poly: 'ch2_eez_coverage' },
          filter_id: 2,
          colour: DEFAULT_COLOUR
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
    @percentage = CsvMapParser.ch3_map1_percentage

    @map_1 = {
      id: 'kba',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch3_Fg6/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'inside-' + random_number,
          text_large: @percentage['Within'],
          text_small: "Fully within Protected Areas",
          source_layers: { poly: 'KBAs_fully_within' },
          colour: TRICOLOR_PALETTE[0],
        },
        {
          id: 'partial-' + random_number,
          text_large: @percentage['Partially'],
          text_small: "Partially within Protected Areas",
          source_layers: { poly: 'KBAs_partially_within' },
          colour: TRICOLOR_PALETTE[1],
        },
        {
          id: 'outside-' + random_number,
          text_large: @percentage['Outside'],
          text_small: "Outside Protected Areas",
          source_layers: { poly: 'KBAs_not_within' },
          colour: TRICOLOR_PALETTE[2],
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
              id: 'over-seventeen' + random_number,
              text_large: 'Over 17%',
              colour: BLUE_PURPLE_SCHEME[3],
              source_layers: { poly: 'Ch4_Fg8_tcat4' }
            },
            {
              id: 'ten-to-seventeen' + random_number,
              text_large: '10% - 17%',
              colour: BLUE_PURPLE_SCHEME[2],
              source_layers: { poly: 'Ch4_Fg8_tcat3' }
            },
            {
              id: 'five-to-ten' + random_number,
              text_large: '5% - 10%',
              colour: BLUE_PURPLE_SCHEME[1],
              source_layers: { poly: 'Ch4_Fg8_tcat2' }
            },
            {
              id: 'under-5' + random_number,
              text_large: 'Under 5%',
              colour: BLUE_PURPLE_SCHEME[0],
              source_layers: { poly: 'Ch4_Fg8_tcat1_noATA' }
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'over-ten' + random_number,
              text_large: 'Over 10%',
              colour: BLUE_PURPLE_SCHEME[3],
              source_layers: { poly: 'Ch4_Fg8_mcat8' }
            },
            {
              id: 'six-to-ten' + random_number,
              text_large: '6% - 10%',
              colour: BLUE_PURPLE_SCHEME[2],
              source_layers: { poly: 'Ch4_Fg8_mcat7' }
            },
            {
              id: 'three-to-six' + random_number,
              text_large: '3% - 6%',
              colour: BLUE_PURPLE_SCHEME[1],
              source_layers: { poly: 'Ch4_Fg8_mcat6' }
            },
            {
              id: 'under-3' + random_number,
              text_large: 'Under 3%',
              colour: BLUE_PURPLE_SCHEME[0],
              source_layers: { poly: 'Ch4_Fg8_mcat5' }
            }
          ]
        },
        {
          title: 'Province',
          layers: [
            {
              id: 'over-ten' + random_number,
              text_large: 'Over 10%',
              colour: BLUE_PURPLE_SCHEME[3],
              source_layers: { poly: 'Ch4_Fg8_mcat12' }
            },
            {
              id: 'six-to-ten' + random_number,
              text_large: '6% - 10%',
              colour: BLUE_PURPLE_SCHEME[2],
              source_layers: { poly: 'Ch4_Fg8_mcat11' }
            },
            {
              id: 'three-to-six' + random_number,
              text_large: '3% - 6%',
              colour: BLUE_PURPLE_SCHEME[1],
              source_layers: { poly: 'Ch4_Fg8_mcat10' }
            },
            {
              id: 'under-3' + random_number,
              text_large: 'Under 3%',
              colour: BLUE_PURPLE_SCHEME[0],
              source_layers: { poly: 'Ch4_Fg8_mcat9' }
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
              id: 'over-five' + random_number,
              text_large: 'Over 5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 6,
              colour: BLUE_PURPLE_SCHEME[3]
            },
            {
              id: 'zero-to-five' + random_number,
              text_large: '0% to 5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 5,
              colour: BLUE_PURPLE_SCHEME[2]
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% to 0%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 4,
              colour: BLUE_PURPLE_SCHEME[1]
            },
            {
              id: 'ten-to-five' + random_number,
              text_large: '-10% to -5%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 3,
              colour: BLUE_PURPLE_SCHEME[0]
            },
            {
              id: 'under-ten' + random_number,
              text_large: 'Under -10%',
              source_layers: { poly: 'wwf_terr_ecos_PA_perc_join_CHANGE' },
              filter_id: 2,
              colour: DEFAULT_COLOUR
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'over-five' + random_number,
              text_large: 'Over 5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 6,
              colour: BLUE_PURPLE_SCHEME[3]
            },
            {
              id: 'two-to-five' + random_number,
              text_large: '2.5% to 5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 5,
              colour: BLUE_PURPLE_SCHEME[2]
            },
            {
              id: 'zero-to-two' + random_number,
              text_large: '0% to 2.5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 4,
              colour: BLUE_PURPLE_SCHEME[1]
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% to 0%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 3,
              colour: BLUE_PURPLE_SCHEME[0]
            },
            {
              id: 'under-five' + random_number,
              text_large: 'Under -5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_MEOWonly_PA_perc_join_CHANGE' },
              filter_id: 2,
              colour: DEFAULT_COLOUR
            }
          ]
        },
        {
          title: 'Province',
          layers: [
            {
              id: 'over-five' + random_number,
              text_large: 'Over 5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 6,
              colour: BLUE_PURPLE_SCHEME[3]
            },
            {
              id: 'two-to-five' + random_number,
              text_large: '2.5% to 5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 5,
              colour: BLUE_PURPLE_SCHEME[2]
            },
            {
              id: 'zero-to-two' + random_number,
              text_large: '0% to 2.5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 4,
              colour: BLUE_PURPLE_SCHEME[1]
            },
            {
              id: 'five-to-zero' + random_number,
              text_large: '-5% to 0%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 3,
              colour: BLUE_PURPLE_SCHEME[0]
            },
            {
              id: 'under-five' + random_number,
              text_large: 'Under -5%',
              source_layers: { poly: 'WCMC_036_MEOW_PPOW_2007_2012_NoCoast_PPOWonly_PA_perc_join_Change' },
              filter_id: 2,
              colour: DEFAULT_COLOUR
            }
          ]
        }
      ]
    }

    @row_charts = CsvParser.biogeographical_regions
  end

  def chapter_5
    @chapter_number = 5
    @chapter_last_updated = 'June 2019'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))['menu_title']
    @next_chapter_link = chapter_6_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-5.yml", 'r'))

    @map = {
      countries: CsvMapParser.ch5_map_categorical,
      legend: [
        { title: 'No Assessments', value: 'default' },
        { title: 'Under 10%', value: 1 },
        { title: '10% - 30%', value: 2 },
        { title: '30% - 60%', value: 3 },
        { title: 'Over 60%', value: 4 }
      ],
      palette: BLUE_PURPLE_SCHEME
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

    @column_chart = PerPameCoverageSerializer.new(CsvParser.per_pame_coverage).serialize
    @column_chart_2 = CountOfPameEvaluationsSerializer.new(CsvParser.count_of_pame_evaluations).serialize
  end

  def chapter_6
    @chapter_number = 6
    @chapter_last_updated = 'July 2018'
    @next_chapter_title = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-7.yml", 'r'))['title']
    @next_chapter_link = chapter_7_path
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-6.yml", 'r'))
    
    @column_chart = GovernanceTypesSerializer.new(CsvParser.governance_type).serialize

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
      countries: CsvMapParser.ch7_map1_categorical,
      legend: [
        { title: 'Under 4%', value: 'default' },
        { title: '4% - 8%', value: 1 },
        { title: '8% - 12%', value: 2 },
        { title: '12% - 17%', value: 3 },
        { title: '17% - 25%', value: 4 },
        { title: 'Over 25%', value: 5 }
      ],
      palette: BLUE_PURPLE_SCHEME
    }

    @map_2 = {
      countries: CsvMapParser.ch7_map2_categorical,
      legend: [
        { title: 'A1. General increase of PA coverage', value: 1 },
        { title: 'A2. Targeted designation of connecting PAs', value: 2 },
        { title: 'B1 + B2. Permeability of unprotected lands (B1) and coordinated management of adjacent PAs (B2)', value: 3 },
        { title: 'B1. Permeability of unprotected lands between PAs', value: 4 },
        { title: 'B2. Coordinated management of adjacent PAs in the country', value: 5 },
        { title: 'B3. No specific priority other than PA management effectiveness for connectivity', value: 6 },
      ],
      palette: ['#2179A7', '#53CCF7', '#a50f15', '#de2d26', '#fb6a4a', '#fcae91', '#423781']
    }

    @map_3 = {
      countries: CsvMapParser.ch7_map3_categorical,
      legend: [
        { title: 'C. Coordinated management of transboundary PA linkages', value: 7 }
      ],
      palette: Array.new(7, '#423781')
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
          id: 'not-wild' + random_number,
          text_small: 'Not wild',
          source_layers: { poly: 'LWPv2_Low_Impact_notwild' },
          colour: TRICOLOR_PALETTE[2]
        },
        {
          id: 'wild' + random_number,
          text_small: 'Wild',
          source_layers: { poly: 'LWPv2_Low_Impact_wild' },
          colour: TRICOLOR_PALETTE[1]
        },
        {
          id: 'protected-areas' + random_number,
          text_small: 'Protected areas',
          source_layers: {poly: 'WDPA_poly_Mar2019', point: 'WDPA_point_Mar2019'},
          colour: TRICOLOR_PALETTE[0]
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
