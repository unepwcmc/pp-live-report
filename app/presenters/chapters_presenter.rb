class ChaptersPresenter
  def initialize
  end
  
  def gauge_charts
    [
      {
        id: 'gauge-terrestrial',
        legend: [
          {
            fill: '#bcbcbc',
            name: 'Terrestrial target: ',
            percent: 17
          },
          {
            fill: '#29A245',
            name: 'Current progress: ', 
            percent: 15 #TODO - put in latest figure
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
            fill: '#bcbcbc',
            name: 'Marine target: ',
            percent: 10
          },
          {
            fill: '#004DA8',
            name: 'Current progress: ', 
            percent: 7 #TODO - put in latest figure
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