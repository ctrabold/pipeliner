module Pipeliner (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Address)
import StartApp.Simple as StartApp


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


stepItem : Address Action -> Step -> Html
stepItem address entry =
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


stepList : Address Action -> List Step -> Html
stepList address steps =
  let
    stepItems =
      List.map (stepItem address) steps
  in
    div
      [ id "builds", class "pipeline-builds" ]
      [ div [ class "ui large steps" ] stepItems
      , text " "
      , button
          [ class "circular ui icon button", onClick address Add ]
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



-- UPDATE


type Action
  = NoOp
  | Add


update action model =
  case action of
    NoOp ->
      model

    Add ->
      let
        currentId = List.maximum (List.map .id model.steps)
        newId = currentId
        entryToAdd =
          step "Buildx" "" 8 "setting"
      in
        { model
          | code = ""
          , steps = entryToAdd :: model.steps
        }



-- VIEW


view : Address Action -> Model -> Html
view address model =
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
        , stepList address model.steps
        ]
    ]


main : Signal Html
main =
  StartApp.start
    { model = initialModel
    , view = view
    , update = update
    }
