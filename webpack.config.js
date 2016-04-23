var path = require("path")

module.exports = {
  entry: "./main.js",
  output: {
    path: "./assets/javascripts",
    filename: "bundle.js"
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        loader: "elm-webpack",
        include: path.join(__dirname, "Pipeliner.elm"),
        exclude: [
          /elm-stuff/,
          /node_modules/
        ]
      }
    ],
    noParse: [/.elm$/]
  }
}
