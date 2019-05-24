export const getLayerIdFromMapboxLayerId = mapboxLayerId => 
  mapboxLayerId.replace(/(-poly|-point)$/, '')

export const getMapboxLayerId = (layer, layerType) => layer.id + '-' + layerType

export const getMapboxLayerIds = layer => {
  const ids = []

  Object.keys(layer.source_layers).forEach(layerType => {
    ids.push(getMapboxLayerId(layer, layerType))
  })

  return ids
}

export const getFirstTopLayerId = map => {
  let firstBoundaryId = ''
  let firstSymbolId = ''

  for (const layer of map.getStyle().layers) {
    if (layer.id.match('admin') && layer.id.match('boundaries')) {
      firstBoundaryId = layer.id
      break
    } else if (layer.type === 'symbol') {
      firstSymbolId = layer.id
    }
  }
  return firstBoundaryId || firstSymbolId
}