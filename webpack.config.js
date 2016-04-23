var path = require("path");

module.exports = {
  entry: {
    bundle: [
      './main.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/assets/javascripts'),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
    ],

    noParse: /\.elm$/,
  },
};
