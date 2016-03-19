module Pipeliner (..) where

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type Status
  = Running
  | Failed
  | Passed
  | Waiting


type alias Step =
  { code : String
  , status : Status
  , title : String
  , description : String
  , icon : String
  , id : Int
  }


step : String -> String -> Int -> String -> Step
step title description id icon =
  { code = ""
  , status = Waiting
  , title = title
  , description = description
  , icon = icon
  , id = id
  }


type alias Model =
  { title : String
  , code : String
  , steps : List Step
  }


initialModel : Model
initialModel =
  { title = "Hello, Pipelines!"
  , code = ""
  , steps =
      [ step "Build" "Copile & Unit tests" 2 "loading setting"
      , step "Deploy" "via SSH to DEV" 3 "send"
      , step "Test" "Running automated UAT" 1 "unhide"
      ]
  }


stepItem : Step -> Html
stepItem entry =
  let
    icon =
      entry.icon ++ " icon"
  in
    a
      [ class "inactive step" ]
      [ i [ class icon ] []
      , div
          [ class "content" ]
          [ div
              [ class "title" ]
              [ text entry.title
              ]
          , div
              [ class "description" ]
              [ text entry.description
              ]
          ]
      ]


stepList : List Step -> Html
stepList steps =
  div
    [ id "builds", class "pipeline-builds" ]
    [ div [ class "ui large steps" ] (List.map stepItem steps)
    , text " "
    , button
        [ class "circular ui icon button" ]
        [ i [ class "icon plus" ] []
        ]
    ]


sideBar : Html
sideBar =
  div
    [ class "pipeline-sidebar" ]
    [ div [ id "editor", class "pipeline-sidebar__editor" ] []
    , button [ id "commit", class "ui green button inverted" ] [ text "Commit" ]
    ]



-- VIEW


view : Model -> Html
view model =
  div
    []
    [ h1
        []
        [ text model.title
        ]
    , hr [] []
    , div
        [ class "pipeline-container" ]
        [ sideBar
        , stepList model.steps
        ]
    ]


main : Html
main =
  view initialModel
