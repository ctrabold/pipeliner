module Pipeliner where

import Html exposing (..)
import Html.Attributes exposing (..)

buildStep : String -> String -> Html
buildStep title description =
  a [ class "active step"]
  [
    i [ class "truck icon" ] [],
    div [ class "content"]
    [
      div [ class "title"] [
        text title
      ],
      div [ class "description"] [
        text description
      ]
    ]
  ]


main : Html
main =
  div []
  [
    h1 [] [
      text "Hello, Pipelines!"
    ],
    hr [] [],
    div [ id "container" ] [
      div []
      [
        div [id "editor"] []
      , button [ id "commit" ] [ text "Commit" ]
      ]
    , div [ id "builds"]
      [
        div [ class "ui steps"]
        [
          buildStep "Build #3" "Build description",
          buildStep "Build #3" "Build description"
        ],
        hr [] [],
        div [ class "ui steps"]
        [
          buildStep "Build #2" "Build description"
        ],
        hr [] [],
        div [ class "ui steps"]
        [
          buildStep "Build #1" "Build description"
        ],
        hr [] []
      ]
    ]
  ]
