module.exports = {
  entry: "./main.js",
  output: {
    path: __dirname + '/assets/javascripts',
    filename: "bundle.js"
  },
  module: {
    loaders: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack'
    }]
  }
};

