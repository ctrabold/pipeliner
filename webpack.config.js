module.exports = {
  entry: "./main.js",
  output: {
    path: "./assets/javascripts",
    filename: "bundle.js"
  },
  module: {
    loaders: [{
      test: /\.elm$/,
      include: [
        "./Pipeliner.elm"
      ],
      loader: "elm-webpack"
    }],
    noParse: [/.elm$/]
  }
};
