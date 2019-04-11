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

export const getFirstSymbolLayerId = map => {
  let firstSymbolId = ''

  for (const layer of map.getStyle().layers) {
    if (layer.type === 'symbol') {
      firstSymbolId = layer.id
      break
    }
  }

  return firstSymbolId
}