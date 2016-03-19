module Pipeliner where

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

-- MODEL

type Status
  = Running
  | Failed
  | Passed
  | Waiting

type alias Job =
  { code: String
  , status: Status
  , id: Int
  , title: String
  , description: String
  }

type alias Stage =
  { title: String
  , jobs: List Job
  }

type alias Model =
  { title: String
  , code: String
  , stages: List Stage
  }

initialModel : Model
initialModel =
  { title = "Hello, Pipelines!"
  , code = ""
  , stages =
    [
      { title = "Stage 1"
      , jobs =
        [
          { code = ""
          , status = Passed
          , id = 1
          , title = "Build 1"
          , description = "Description"
          }
        ]
      },
      { title = "Stage 2"
      , jobs =
        [
          { code = ""
          , status = Passed
          , id = 1
          , title = "Build 1"
          , description = "Description"
          }
        ]
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
      text initialModel.title
    ],
    hr [] [],
    div [ class "pipeline-container"] [
      div [ class "pipeline-sidebar" ]
      [
        div [id "editor", class "pipeline-sidebar__editor" ] []
      , button [ id "commit", class "ui green button inverted" ] [ text "Commit" ]
      ]
    , div [ id "builds", class "pipeline-builds" ]
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
