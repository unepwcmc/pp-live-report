class ChaptersController < ApplicationController
  include RandomNumberHelper
  include YamlHelpers
  layout 'chapter'

  helper_method :map_disclaimer

  # Messy way of getting chapter number and passing it to before action!
  before_action do
    populate_case_studies(params[:action].match(/\d+/)[0].to_i)
  end


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
    @next_chapter_title = @chapters_data[1]['menu_title']
    @next_chapter_link = chapter_2_path
    @data = @chapters_data[0]

    @smallprint = 'Main sources: CBD technical note on ‘Biodiversity and the 2030 agenda for sustainable development’ and Natural Solutions briefing on ‘Protected areas helping to meet the Sustainable Development Goals’ prepared by Nigel Dudley, Natasha Ali and Kathy MacKinnon, October 2017.'

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
    @next_chapter_title = @chapters_data[2]['menu_title']
    @next_chapter_link = chapter_3_path

    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.pp_global_monthly_stats).serialize
    @data = @chapters_data[1]

    @map_1 = {
      id: "map_1",
      tiles_url: "https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch2_Fg1/VectorTileServer/tile/{z}/{y}/{x}.pbf",
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: "terrestrial-" + random_number,
              text_large: global_monthly_stats['total_land_pa_coverage_percentage'] + '%',
              text_small: "Terrestrial",
              source_layers: {poly: 'WDPA_poly_Mar2019_terrestrial', point: 'WDPA_point_Mar2019_terrestrial'},
              colour: "#86BF37"
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
                {
                  id: 'marine-' + random_number,
                  text_large: global_monthly_stats['total_ocean_pa_coverage_percentage'] + '%',
                  text_small: 'Total PA Coverage',
                  source_layers: { poly: 'WDPA_poly_Mar2019_Mar_Coast', point: 'WDPA_point_Mar2019_Mar_Coast' },
                  colour: '#133151'
                },
                {
                  id: "eez-" + random_number,
                  text_large: global_monthly_stats['national_waters_pa_coverage_percentage'] + '%',
                  text_small: "Global EEZ",
                  source_layers: {poly: 'WDPA_poly_Mar2019_EEZ', point: 'WDPA_point_Mar2019_EEZ'},
                  colour: "#6FD9F2"
                },
                {
                  id: "abnj-" + random_number,
                  text_large: global_monthly_stats['high_seas_pa_coverage_percentage'] + '%',
                  text_small: "Global ABNJ",
                  source_layers: {poly: 'WDPA_poly_Mar2019_ABNJ', point: 'WDPA_point_Mar2019_ABNJ'},
                  colour: "#207D94"
                }
              ]
          }
        ]
      }

    @global_area_chart = {
      id: 'global-area-chart',
      legend: [
        {
          title: 'Proportion of cover by protected areas'
        }
      ],
      datasets: [
        {
          title: 'Ocean',
          class: 'marine',
          percent: 71,
          cssPercent: 71,
          protected_areas: {
            title: '',
            percent: global_monthly_stats['total_ocean_pa_coverage_percentage']
          }
        },
        {
          title: 'Land',
          class: 'land',
          percent: 29,
          cssPercent: 29,
          protected_areas: {
            title: '',
            percent: global_monthly_stats['total_land_pa_coverage_percentage']
          }
        }
      ]
    }

    @marine_area_chart = {
      id: 'marine-area-chart',
      legend: [
        {
          title: 'Proportion of cover by protected areas'
        }
      ],
      datasets: [
        {
          title: 'ABNJ',
          percent: 43,
          cssPercent: 43.31, # percentage of the world [71(ocean)* 0.61(abnj)]
          class: 'abnj',
          protected_areas: {
            title: '',
            percent: global_monthly_stats['high_seas_pa_coverage_percentage']
          }
        },
        {
          title: 'EEZ',
          percent: 28,
          cssPercent: 27.69, # percentage of the world [71(ocean)* 0.39(eez)]
          class: 'eez',
          protected_areas: {
            title: '',
            percent: global_monthly_stats['national_waters_pa_coverage_percentage']
          }
        },
        {
          title: 'Land',
          class: 'land',
          percent: 29,
          cssPercent: 29,
          active: false,
          protected_areas: {
            title: '',
            percent: global_monthly_stats['total_land_pa_coverage_percentage']
          }
        }
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
        y: ['Area', '(Million km²)']
      },
      targets: [
        {
          y: 36,
          title: 'Marine target (10%)'
        },
        {
          y: 23,
          title: 'Terrestrial target (17%)'
        }
      ],
      commitments: [
        {
          x: 2018,
          line: true,
          label: %w[Future Commitments]
        }
      ],
      legend: [
        {
          title: 'ABNJ'
        },
        {
          title: 'EEZ'
        },
        {
          title: 'Land'
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
      id: 'map_3',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch2_Fg5_Oct20/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'over-ten-' + random_number,
          text_large: 'Over 10%',
          source_layers: { poly: 'Ch2_Fg5_mcat5' },
          colour: BLUE_PURPLE_SCHEME[3]
        },
        {
          id: 'six-to-ten-' + random_number,
          text_large: '6% - 10%',
          source_layers: { poly: 'Ch2_Fg5_mcat4' },
          colour: BLUE_PURPLE_SCHEME[2]
        },
        {
          id: 'three-to-six-' + random_number,
          text_large: '3% – 6%',
          source_layers: { poly: 'Ch2_Fg5_mcat3' },
          colour: BLUE_PURPLE_SCHEME[1]
        },
        {
          id: 'less-than-3-' + random_number,
          text_large: 'Under 3%',
          source_layers: { poly: 'Ch2_Fg5_mcat2' },
          colour: BLUE_PURPLE_SCHEME[0]
        },
        {
          id: 'data-deficient-' + random_number,
          text_large: 'Data deficient',
          source_layers: { poly: 'Ch2_Fg5_mcat1' },
          colour: DEFAULT_COLOUR
        }
      ]
    }
  end

  def chapter_3
    @chapter_number = 3
    @next_chapter_title = @chapters_data[3]['menu_title']
    @next_chapter_link = chapter_4_path
    @data = @chapters_data[2]
    @percentage = CsvMapParser.ch3_map1_percentage

    @map_1 = {
      id: 'kba',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch3_Fg6_Live_2020/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'inside-' + random_number,
          text_large: @percentage['Within'],
          text_small: 'Fully within Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_complete_pa_coverage' },
          colour: TRICOLOR_PALETTE[0]
        },
        {
          id: 'partial-' + random_number,
          text_large: @percentage['Partially'],
          text_small: 'Partially within Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_partial_pa_coverage' },
          colour: TRICOLOR_PALETTE[1]
        },
        {
          id: 'outside-' + random_number,
          text_large: @percentage['Outside'],
          text_small: 'Outside Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_none_pa_coverage' },
          colour: TRICOLOR_PALETTE[2]
        }
      ]
    }

    kba_data = CsvParser.kba_timeseries
    lines = []
    ['Freshwater KBAs', 'Marine KBAs', 'Terrestrial KBAs'].each do |type|
      datapoints = []
      ('2000'..'2018').each do |year|
        datapoints << { x: year, y: kba_data[year][type] }
      end
      lines << { datapoints: datapoints }
    end
    @line_chart = {
      lines: lines,
      axis: {
        y: ['Average Percentage', 'Covered']
      },
      legend: [
        {
          title: 'Freshwater'
        },
        {
          title: 'Marine'
        },
        {
          title: 'Terrestrial'
        }
      ]
    }
  end

  def chapter_4
    @chapter_number = 4
    @next_chapter_title = @chapters_data[4]['menu_title']
    @next_chapter_link = chapter_5_path
    @data = @chapters_data[3]

    @map_1 = {
      id: 'map_1',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch4_Fg8_Mar20/VectorTileServer/tile/{z}/{y}/{x}.pbf',
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
    @next_chapter_title = @chapters_data[5]['menu_title']
    @next_chapter_link = chapter_6_path
    @data = @chapters_data[4]

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

    progress_level_data = CsvParser.ch5_figure2_stats
    terrestrial = progress_level_data['Land']
    marine = progress_level_data['Marine']
    @stacked_row_charts = {
      legend: [
        {
          title: 'Over 60%'
        },
        {
          title: '30-60%'
        },
        {
          title: '10-30%'
        },
        {
          title: 'Under 10%'
        },
        {
          title: 'No Assessments'
        }
      ],
      charts: [
        {
          chart_title: 'Terrestrial',
          theme: 'green',
          rows: [
            {
              percent: terrestrial['Over 60%'].to_f.round,
              label: '1.'
            },
            {
              percent: terrestrial['30-60%'].to_f.round,
              label: '2.'
            },
            {
              percent: terrestrial['10-30%'].to_f.round,
              label: '3.'
            },
            {
              percent: terrestrial['Under 10%'].to_f.round,
              label: '4.'
            },
            {
              percent: 29,
              label: '5.'
            }
          ]
        },
        {
          chart_title: 'Marine',
          theme: 'blue',
          rows: [
            {
              percent: 16,
              label: '1.'
            },
            {
              percent: marine['30-60%'].to_f.round,
              label: '2.'
            },
            {
              percent: marine['10-30%'].to_f.round,
              label: '3.'
            },
            {
              percent: marine['Under 10%'].to_f.round,
              label: '4.'
            },
            {
              percent: marine['No Assessments'].to_f.round,
              label: '5.'
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
    @next_chapter_title = @chapters_data[6]['title']
    @next_chapter_link = chapter_7_path
    @data = @chapters_data[5]

    @column_chart = GovernanceTypesSerializer.new(CsvParser.governance_type).serialize

    country_governance_data = CsvParser.ch6_figure2_stats
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
    @next_chapter_title = @chapters_data[7]['menu_title']
    @next_chapter_link = chapter_8_path
    @data = @chapters_data[6]

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
  end

  def chapter_8
    @chapter_number = 8
    @next_chapter_title = @chapters_data[8]['menu_title']
    @next_chapter_link = chapter_9_path
    @data = @chapters_data[7]
  end

  def chapter_9
    @chapter_number = 9
    @next_chapter_title = @chapters_data[9]['menu_title']
    @next_chapter_link = chapter_10_path
    @data = @chapters_data[8]

    @map_1 = {
      id: 'map_1',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch9_Fg/VectorTileServer/tile/{z}/{y}/{x}.pbf',
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
          source_layers: { poly: 'WDPA_poly_Mar2019', point: 'WDPA_point_Mar2019' },
          colour: TRICOLOR_PALETTE[0]
        }
      ]
    }
  end

  def chapter_10
    @chapter_number = 10
    @data = @chapters_data[9]
  end

  private

  def map_disclaimer(source)
    {
      source: source,
      text: @shared_data['map_disclaimer']
  }.to_json

  CASE_STUDY_ATTRIBUTES = %w(label report authors org title text image caption source).freeze

  def populate_case_studies(chapter_number)
    # TODO: - Update case study texts
    case_study_data = @chapters_data[chapter_number - 1]['case_studies']
    return if case_study_data.nil?

    @items = case_study_data.map do |case_study|
                case_study['text'] = case_study['text'].split("\n")  
                contents = case_study_contents.merge(case_study.deep_stringify_keys)

                contents['image'] = case_study_image(case_study)
                contents
            end
  end

  def case_study_contents
    # Build a hash out of all possible keys 
    # This allows more data to be easily added to the case studies in the YML file at a later date
    # e.g. if authors or a caption for an image is needed to be inserted
    attributes = Hash.new
    CASE_STUDY_ATTRIBUTES.map { |attr| attributes[attr] = '' }
    attributes
  end

  def case_study_image(case_study)
    if case_study['image']
      URI.join(root_url, helpers.image_path("case_studies/#{case_study['image']}"))
    else
      URI.join(root_url, helpers.image_path('case_studies/fisherman_2x.png'))
    end
  end
end
