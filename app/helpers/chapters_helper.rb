module ChaptersHelper
  def gauge_charts
    [
      {
        id: 'gauge-terrestrial',
        legend: [
          {
            name: 'Current progress: 00% <TODO',
            fill: '#29A245'
          }, {
            name: 'Terrestrial target: 17%',
            fill: '#bcbcbc'
          }
        ],
        target: 17,
        theme: '#29A245',
        title: 'Terrestrial',
        value: 15 #TODO - put in latest figure
      },
      {
        id: 'gauge-marine',
        legend: [
          {
            name: 'Current progress: 00% <TODO',
            fill: '#004DA8'
          }, {
            name: 'Marine target: 10%',
            fill: '#bcbcbc'
          }
        ],
        target: 10,
        theme: '#004DA8',
        title: 'Marine',
        value: 7 #TODO - put in latest figure
      }
    ]
  end
end