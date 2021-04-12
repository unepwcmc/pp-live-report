class ChaptersController < ApplicationController
  include RandomNumberHelper
  include YamlHelpers
  include ChaptersHelper
  layout 'chapter'

  helper_method :chapter_number
  helper_method :map_disclaimer

  # Messy way of getting chapter number and passing it to before action!
  before_action do
    populate_case_studies(chapter_number)
  end
  
  CASE_STUDY_ATTRIBUTES = {
                            label: '',
                            report: '',
                            authors: '',
                            org: '',
                            title: '',
                            text: '',
                            image: '',
                            caption: '',
                            source: ''
                          }.freeze

  DEFAULT_COLOUR = '#A6A6A6'.freeze
  TRICOLOR_PALETTE = [
    '#66c2a5',
    '#8da0cb',
    '#fc8d62'
  ].freeze
  PURPLE_SCHEME = [
    '#B3CDE3',
    '#8c96c6',
    '#8856A7',
    '#810F7C',
    '#4d004b'
  ].freeze
  BLUE_SCHEME = [
    '#0D7AE7',
    '#0844B2',
    '#4863A0',
    '#163B65',
    '#00174B'
  ].freeze
  GREEN_SCHEME = [
    '#C4D6AD',
    '#87BF37',
    '#68853F',
    '#333E23',
    '#1c260d',
  ].freeze
  LANGUAGES = { 
    'ar': 'العربية',
    'es': 'Español',
    'en': 'English',
    'fr': 'Français',
    'ru': 'Русский',
    'zh': '中文'
  }.freeze

  def chapter_1
    @summaries = load_summary_text
    @data = @chapters_data[0]
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
    @presenter = ChaptersPresenter.new
    @gauge_charts = @presenter.gauge_charts

    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.pp_global_monthly_stats).serialize
    @data = @chapters_data[2]

    @map_1 = {
      id: 'map_1',
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/wdpa_prot_planet_live/VectorTileServer/tile/{z}/{y}/{x}',
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: 'terrestrial-' + random_number,
              text_large: 'All terrestrial',
              # type: 'raster_tile',
              source_layers: { poly: 'land_pas' },
              colour: '#86BF37'
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'marine-' + random_number,
              text_large: 'All marine',
              # type: 'raster_tile',
              source_layers: { poly: 'marine_pas' },
              colour: '#133151'
            },
            {
              id: 'eez-' + random_number,
              text_large: 'National waters',
              # type: 'raster_tile',
              source_layers: { poly: 'eez_pas' },
              colour: '#6FD9F2'
            },
            {
              id: 'abnj-' + random_number,
              text_large: 'Areas beyond national jurisdiction',
              # type: 'raster_tile',
              source_layers: { poly: 'abnj_pas' },
              colour: '#207D94'
            }
          ]
        }
      ]
    }

    @map_2 = {
      id: 'map_2',
      csv_url: get_csv_url(CSV_CH3_MAP_PA_NATIONAL),
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/nat_cov_pas_merc/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tiles_url_oecm: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/nat_cov_pas_merc_oecm/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: 'terrestrial-data-deficient-' + random_number,
              text_large: 'Data deficient',
              source_layers: { poly: 'land_nat_cov_cat1' },
              colour: DEFAULT_COLOUR
            },
            {
              id: 'terrestrial-less-than-3-' + random_number,
              text_large: 'Under 3%',
              source_layers: { poly: 'land_nat_cov_cat2' },
              colour: GREEN_SCHEME[0]
            },
            {
              id: 'terrestrial-three-to-six-' + random_number,
              text_large: '3% – 6%',
              source_layers: { poly: 'land_nat_cov_cat3' },
              colour: GREEN_SCHEME[1]
            },
            {
              id: 'terrestrial-six-to-ten-' + random_number,
              text_large: '6% - 10%',
              source_layers: { poly: 'land_nat_cov_cat4' },
              colour: GREEN_SCHEME[2]
            },
            {
              id: 'terrestrial-over-ten-' + random_number,
              text_large: 'Over 10%',
              source_layers: { poly: 'land_nat_cov_cat5' },
              colour: GREEN_SCHEME[3]
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'marine-data-deficient-' + random_number,
              text_large: 'Data deficient',
              source_layers: { poly: 'sea_nat_cov_cat1' },
              colour: DEFAULT_COLOUR
            },
            {
              id: 'marine-less-than-3-' + random_number,
              text_large: 'Under 3%',
              source_layers: { poly: 'sea_nat_cov_cat2' },
              colour: BLUE_SCHEME[0]
            },
            {
              id: 'marine-three-to-six-' + random_number,
              text_large: '3% – 6%',
              source_layers: { poly: 'sea_nat_cov_cat3' },
              colour: BLUE_SCHEME[1]
            },
            {
              id: 'marine-six-to-ten-' + random_number,
              text_large: '6% - 10%',
              source_layers: { poly: 'sea_nat_cov_cat4' },
              colour: BLUE_SCHEME[2]
            },
            {
              id: 'marine-over-ten-' + random_number,
              text_large: 'Over 10%',
              source_layers: { poly: 'sea_nat_cov_cat5' },
              colour: BLUE_SCHEME[3]
            }
          ]
        }
      ]
    }

    timeseries_data = CsvParser.timeseries
    types = %w[Land Marine]
    lines = ('1990'..'2020').map do |year|
      { "x": Time.new(year.to_i).strftime('%Y-%m-%d') }
      .merge!({
        "1": timeseries_data[year][types[0]].round(2),
        "2": timeseries_data[year][types[1]].round(2),
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

    @line_chart_csv_url = get_csv_url(CSV_CH3_TIMESERIES)
  end

  def chapter_4
    @data = @chapters_data[3]

    @map = {
      id: 'ecoregions',
      csv_url: get_csv_url(CSV_CH4_MAP_ECOREGIONS),
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/ecoregions_merc/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tiles_url_oecm: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/ecoregions_merc_oecm/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tabs: [
        {
          title: 'Terrestrial',
          layers: [
            {
              id: 'id-less-than-5-' + random_number,
              text_large: '< 5%',
              source_layers: { poly: 'teow_cat1' },
              colour: GREEN_SCHEME[0]
            },
            {
              id: 'id-between-5-and-10' + random_number,
              text_large: '5 - 10%',
              source_layers: { poly: 'teow_cat2' },
              colour: GREEN_SCHEME[1]
            },
            {
              id: 'id-between-10-and-17' + random_number,
              text_large: '10 - 17%',
              source_layers: { poly: 'teow_cat3' },
              colour: GREEN_SCHEME[2]
            },
            {
              id: 'id-greater-than-17' + random_number,
              text_large: '> 17%',
              source_layers: { poly: 'teow_cat4' },
              colour: GREEN_SCHEME[3]
            }
          ]
        },
        {
          title: 'Marine',
          layers: [
            {
              id: 'id-less-than-3-' + random_number,
              text_large: '< 3%',
              source_layers: { poly: 'meow_cat1' },
              colour: BLUE_SCHEME[0]
            },
            {
              id: 'id-between-3-and-6' + random_number,
              text_large: '3 - 6%',
              source_layers: { poly: 'meow_cat2' },
              colour: BLUE_SCHEME[1]
            },
            {
              id: 'id-between-6-and-10' + random_number,
              text_large: '6 - 10%',
              source_layers: { poly: 'meow_cat3' },
              colour: BLUE_SCHEME[2]
            },
            {
              id: 'id-greater-than-10' + random_number,
              text_large: '> 10%',
              source_layers: { poly: 'meow_cat4' },
              colour: BLUE_SCHEME[3]
            }
          ]
        },
        {
          title: 'Pelagic',
          layers: [
            {
              id: 'id-less-than-3-' + random_number,
              text_large: '< 3%',
              source_layers: { poly: 'meow_cat1' },
              colour: BLUE_SCHEME[0]
            },
            {
              id: 'id-between-3-and-6' + random_number,
              text_large: '3 - 6%',
              source_layers: { poly: 'meow_cat2' },
              colour: BLUE_SCHEME[1]
            },
            {
              id: 'id-between-6-and-10' + random_number,
              text_large: '6 - 10%',
              source_layers: { poly: 'meow_cat3' },
              colour: BLUE_SCHEME[2]
            },
            {
              id: 'id-greater-than-10' + random_number,
              text_large: '> 10%',
              source_layers: { poly: 'meow_cat4' },
              colour: BLUE_SCHEME[3]
            }
          ]
        }
      ]
    }

    @row_charts = CsvParser.biogeographical_regions
    @row_charts_csv_url = get_csv_url(CSV_CH4_ECOREGIONS)
  end

  def chapter_5
    @data = @chapters_data[4]

    @map_1 = {
      id: 'kba',
      csv_url: get_csv_url(CSV_CH5_MAP_KBA_OCEM_OVERLAP),
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/PP_Live_Ch3_Fg6_Live_2020/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'inside-' + random_number,
          text_large: 'Fully within Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_complete_pa_coverage' },
          colour: TRICOLOR_PALETTE[0]
        },
        {
          id: 'partial-' + random_number,
          text_large: 'Partially within Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_partial_pa_coverage' },
          colour: TRICOLOR_PALETTE[1]
        },
        {
          id: 'outside-' + random_number,
          text_large: 'Outside Protected Areas',
          source_layers: { poly: 'KBAs_2019_02_none_pa_coverage' },
          colour: TRICOLOR_PALETTE[2]
        }
      ]
    }

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

  def chapter_6
    @data = @chapters_data[5]
  end

  def chapter_7
    @data = @chapters_data[6]
  end

  def chapter_8
    @data = @chapters_data[7]
    
    @map_1 = {
      id: 'map_1',
      csv_url: get_csv_url(CSV_CH8_NATIONAL_CONNECTIVITY),
      tiles_url: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/protconn_merc/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      tiles_url_oecm: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/protconn_merc_oecm/VectorTileServer/tile/{z}/{y}/{x}.pbf',
      layers: [
        {
          id: 'data-deficient-' + random_number,
          text_large: 'Data deficient',
          source_layers: { poly: 'protconn_cat1_merc' },
          colour: DEFAULT_COLOUR
        },
        {
          id: 'less-than-5-' + random_number,
          text_large: '< 5%',
          source_layers: { poly: 'protconn_cat2_merc' },
          colour: GREEN_SCHEME[0]
        },
        {
          id: 'five-to-ten-' + random_number,
          text_large: '5% - 10%',
          source_layers: { poly: 'protconn_cat3_merc' },
          colour: GREEN_SCHEME[1]
        },
        {
          id: 'ten-to-seventeen-' + random_number,
          text_large: '10% - 17%',
          source_layers: { poly: 'protconn_cat4_merc' },
          colour: GREEN_SCHEME[2]
        },
        {
          id: 'greater-than-seventeen-' + random_number,
          text_large: '> 17%',
          source_layers: { poly: 'protconn_cat5_merc' },
          colour: GREEN_SCHEME[3]
        }
      ]
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

  def map_disclaimer(source)
    {
      title: 'Map Disclaimer',
      source: source,
      text: @shared_data['map_disclaimer']
    }.to_json
  end

  private

  def load_summary_text
    # TODO: - need actual summary text in different languages
    summaries_path = 'config/locales/summary'.freeze

    Dir.children(summaries_path).sort.map do |locale|
      yml = YAML.load_file(File.join(Rails.root, summaries_path, locale))
      locale_iso = locale.split('.')[0]

      {
        title: yml[locale_iso.to_s]['summary']['title'],
        text: yml[locale_iso.to_s]['summary']['text'],
        locale: { title: LANGUAGES[locale_iso.to_sym], iso: locale_iso }
      }
    end.to_json
  end
  
  def populate_case_studies(chapter_number)
    case_study_data = @chapters_data[chapter_number - 1]['case_studies']
    return if case_study_data.nil?

    case_study_contents = CASE_STUDY_ATTRIBUTES

    @items = case_study_data.map do |case_study|
      if case_study['title'] == 'References'
        case_study['text'] = @shared_data['references']
      else
        case_study['text'] = case_study['text'].split("\n")
      end

      contents = case_study_contents.merge(case_study.deep_stringify_keys)

      contents['image'] = case_study_image(case_study)
      contents
    end
  end

  def case_study_image(case_study)
    if case_study['image']
      URI.join(root_url, helpers.image_path("case_studies/#{case_study['image']}"))
    end
  end

  def chapter_number
    raise NoNumberError unless params[:action].match?(/\d+/)
    params[:action].match(/\d+/)[0].to_i
  end
end
