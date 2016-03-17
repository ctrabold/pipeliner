module Pipeliner where

import Html exposing (..)

main =
  div []
  [
    h1 [] [
      text "Hello, Pipelines!"
    ],
    hr [] [],
    div []
    [
      h2 [] [
        text "Build #3"
      ],
      hr [] [],
      h2 [] [
        text "Build #2"
      ],
      hr [] [],
      h2 [] [
        text "Build #1"
      ],
      hr [] []
    ]
  ]
