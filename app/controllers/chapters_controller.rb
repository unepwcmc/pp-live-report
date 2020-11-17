class ChaptersController < ApplicationController
  include RandomNumberHelper
  include YamlHelpers
  layout 'chapter'

  CASE_STUDY_ATTRIBUTES = %w(label report authors org title text image caption source).freeze
  LANGUAGES = { 
    'ar': 'العربية',
    'es': 'Español',
    'en': 'English',
    'fr': 'Français',
    'ru': 'Русский',
    'zh': '中文'
  }.freeze

  helper_method :chapter_number

  before_action :load_summary_text
  
  # Messy way of getting chapter number and passing it to before action!
  before_action do
    populate_case_studies(chapter_number)
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

  def chapter_number
    raise NoNumberError unless params[:action].match?(/\d+/)
    params[:action].match(/\d+/)[0].to_i
  end

  def chapter_1
    @presenter = ChaptersPresenter.new

    @data = @chapters_data[0]
    @gauge_charts = @presenter.gauge_charts
  end

  def chapter_2
    @data = @chapters_data[1]

    @doughnut_chart = @data['doughnut_chart_data'].map do |item|
      {
        'title': item['title'],
        'colour': item['colour'],
        'icon': ActionController::Base.helpers.image_url(item['icon']),
        'description': item['description'],
        'url': item['url']
      }
    end
  end

  def chapter_3
    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.pp_global_monthly_stats).serialize
    @data = @chapters_data[2]

    @map_1 = {
      id: 'map_1',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch2_Fg1/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'terrestrial-' + random_number,
          text_large: global_monthly_stats['total_land_pa_coverage_percentage'] + '%',
          text_small: 'of terrestrial areas',
          source_layers: { poly: 'WDPA_poly_Mar2019_terrestrial', point: 'WDPA_point_Mar2019_terrestrial' },
          colour: '#86BF37'
        },
        {
          id: 'marine-' + random_number,
          text_large: global_monthly_stats['total_ocean_pa_coverage_percentage'] + '%',
          text_small: 'of marine areas',
          source_layers: { poly: 'WDPA_poly_Mar2019_Mar_Coast', point: 'WDPA_point_Mar2019_Mar_Coast' },
          colour: '#133151',
          sublayers: [
            {
              id: 'eez-' + random_number,
              text_large: global_monthly_stats['national_waters_pa_coverage_percentage'] + '%',
              text_small: 'of the global EEZ',
              source_layers: { poly: 'WDPA_poly_Mar2019_EEZ', point: 'WDPA_point_Mar2019_EEZ' },
              colour: '#6FD9F2'
            },
            {
              id: 'abnj-' + random_number,
              text_large: global_monthly_stats['high_seas_pa_coverage_percentage'] + '%',
              text_small: 'of global ABNJ',
              source_layers: { poly: 'WDPA_poly_Mar2019_ABNJ', point: 'WDPA_point_Mar2019_ABNJ' },
              colour: '#207D94'
            }
          ]
        }
      ]
    }

    @map_2 = {
      countries: CsvMapParser.ch3_map2_categorical,
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

    timeseries_data = CsvParser.timeseries
    types = ['ABNJ', 'EEZ', 'Land']
    lines = ('1990'..'2020').map do |year|
      { "x": Time.new(year.to_i).strftime("%Y-%m-%d") }.merge!({
        "1": timeseries_data[year][types[0]].round(2), 
        "2": timeseries_data[year][types[1]].round(2), 
        "3": timeseries_data[year][types[2]].round(2)
      })
    end
    @line_chart = {
      datapoints: lines,
      units: 'Area (Million km²)',
      legend: types,
      yTargets: [
        { name: 'Marine target (10%)', position: 36 }, 
        { name: 'Terrestrial target (17%)', position: 23 }
      ]
    }.to_json
  end

  def chapter_4
    @data = @chapters_data[3]
    @percentage = CsvMapParser.ch4_map1_percentage

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

    @row_charts = CsvParser.biogeographical_regions

    kba_data = CsvParser.kba_timeseries
    types = ['Freshwater KBAs', 'Marine KBAs', 'Terrestrial KBAs']
    lines = ('2000'..'2018').map do |year|
      { "x": Time.new(year.to_i).strftime("%Y-%m-%d") }.merge!({
        "1": kba_data[year][types[0]], 
        "2": kba_data[year][types[1]], 
        "3": kba_data[year][types[2]] 
      })
    end
    @line_chart = {
      datapoints: lines,
      units: 'Average percentage covered %',
      legend: types.map { |t| t.gsub(/(KBAs)/, '').squish }
    }.to_json
  end

  def chapter_5
    @data = @chapters_data[4]

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

    kba_data = CsvParser.kba_timeseries
    lines = []
    [ 'Freshwater KBAs', 'Marine KBAs','Terrestrial KBAs' ].each do |type|
      datapoints = []
      ('2000'..'2018').each do |year|
        datapoints << { x: year, y: kba_data[year][type] }
      end
      lines << { datapoints: datapoints }
    end
    @line_chart = {
      lines: lines,
      axis: {
        y: ["Average Percentage", "Covered"]
      },
      legend: [
        {
          title: "Freshwater"
        },
        {
          title: "Marine"
        },
        {
          title: "Terrestrial"
        },
      ]
    }
  end

  def chapter_6
    @data = @chapters_data[5]

    @map = {
      countries: CsvMapParser.ch6_map_categorical,
      legend: [
        { title: 'No Assessments', value: 'default' },
        { title: 'Under 10%', value: 1 },
        { title: '10% - 30%', value: 2 },
        { title: '30% - 60%', value: 3 },
        { title: 'Over 60%', value: 4 }
      ],
      palette: BLUE_PURPLE_SCHEME
    }
  end

  def chapter_7
    @data = @chapters_data[6]
  end

  def chapter_8
    @data = @chapters_data[7]

    # TODO - May need to remove or change map style from infographic to interactive
    @map_1 = {
      countries: CsvMapParser.ch8_map1_categorical,
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
      countries: CsvMapParser.ch8_map2_categorical,
      legend: [
        { title: 'A1. General increase of PA coverage', value: 1 },
        { title: 'A2. Targeted designation of connecting PAs', value: 2 },
        { title: 'B1 + B2. Permeability of unprotected lands (B1) and coordinated management of adjacent PAs (B2)', value: 3 },
        { title: 'B1. Permeability of unprotected lands between PAs', value: 4 },
        { title: 'B2. Coordinated management of adjacent PAs in the country', value: 5 },
        { title: 'B3. No specific priority other than PA management effectiveness for connectivity', value: 6 }
      ],
      palette: ['#2179A7', '#53CCF7', '#a50f15', '#de2d26', '#fb6a4a', '#fcae91', '#423781']
    }

    @map_3 = {
      countries: CsvMapParser.ch8_map3_categorical,
      legend: [
        { title: 'C. Coordinated management of transboundary PA linkages', value: 7 }
      ],
      palette: Array.new(7, '#423781')
    }
  end

  def chapter_9
    @data = @chapters_data[8]
  end

  def chapter_10
    @data = @chapters_data[9]
  end

  def chapter_11
    @data = @chapters_data[10]
  end

  private

  def load_summary_text 
    # TODO - need actual summary text in different languages 
    summaries_path = 'config/locales/summary'.freeze

    @summaries = Dir.children(summaries_path).sort.map do |locale|
      yml = YAML.load_file(File.join(Rails.root, summaries_path, locale))
      locale_iso = locale.split('.')[0]
      
      {
        title: yml["#{locale_iso}"]['summary']['title'],
        text: yml["#{locale_iso}"]['summary']['text'],
        locale: { title: LANGUAGES[locale_iso.to_sym], iso: locale_iso }
      }
    end.to_json
  end
  
  def populate_case_studies(chapter_number)
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
