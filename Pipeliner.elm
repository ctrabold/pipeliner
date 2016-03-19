module Pipeliner where

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Build =
  { code: String
  , status: Bool
  , id: Int
  , steps: List BuildStep
  }

type alias BuildStep =
  { title: String
  , description: String
  }

type alias Model =
  { code: String
  , builds: List Build
  }

initialModel : Model
initialModel =
  { code = ""
  , builds =
    [
      { id = 1
      , code = ""
      , status = True
      , steps = []
      }
    ]
  }


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


view : Html
view =
  div []
  [
    h1 [] [
      text "Hello, Pipelines!"
    ],
    textarea [ id "codepad" ] [],
    button [ id "submit" ] [ text "Submit" ],
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


main : Html
main =
  view
