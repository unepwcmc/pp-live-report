class ChaptersPresenter  
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
            percent: 16.64
          } 
        ],
        target: 17,
        theme: '#29A245',
        title: 'Terrestrial',
        value: 16.64
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
            percent: 7.74
          }
        ],
        target: 10,
        theme: '#004DA8',
        title: 'Marine',
        value: 7.74
      }
    ]
  end
end