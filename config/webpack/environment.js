const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.set(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    moment: 'moment',
    d3: 'd3',
    'd3.tip': 'd3-tip'
  })
)

module.exports = environment
