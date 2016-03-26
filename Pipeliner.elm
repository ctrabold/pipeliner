module Pipeliner (..) where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Address)


-- PORTS


port currentCode : Signal String



-- MODEL


type Status
  = Running
  | Failed
  | Success
  | Waiting


type alias Step =
  { code : String
  , status : Status
  , title : String
  , description : String
  , icon : String
  , id : Int
  }


step : String -> String -> Int -> String -> Status -> Step
step title description id icon status =
  { code = ""
  , status = status
  , title = title
  , description = description
  , icon = icon
  , id = id
  }


type alias Model =
  { title : String
  , description : String
  , code : String
  , steps : List Step
  }


initialModel : Model
initialModel =
  { title = "Hello Pipelines!"
  , description = "Example description"
  , code = ""
  , steps =
      [ step "Build" "Compile & Unit tests" 1 "" Waiting
      , step "Deployment DEV" "via SSH to DEV" 2 "send" Waiting
      , step "Testing DEV" "Running automated tests" 3 "unhide" Waiting
      , step "Deployment SIT" "Running automated User Acceptance Tests" 4 "warning" Waiting
      ]
  }


mapStatusToCss : Status -> String
mapStatusToCss status =
  case status of
    Waiting ->
      "disabled"

    Running ->
      "active"

    Failed ->
      "failed"

    Success ->
      "completed"


mapStatusToIcon : Status -> String -> String
mapStatusToIcon status icon =
  case status of
    Running ->
      "setting loading"

    Failed ->
      "red " ++ icon

    _ ->
      icon


stepItem : Address Action -> Step -> Html
stepItem address entry =
  let
    icon =
      (mapStatusToIcon entry.status entry.icon) ++ " icon"

    status =
      (mapStatusToCss entry.status) ++ " step"
  in
    a
      [ class status ]
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
      [ id "builds", class "nine wide column" ]
      [ div [ class "ui tablet stackable large steps" ] stepItems
      , text " "
      , button
          [ class "circular ui icon button", onClick address Add ]
          [ i [ class "icon plus" ] []
          ]
      , button
          [ class "circular ui icon button", onClick address Remove ]
          [ i [ class "icon minus" ] []
          ]
      ]


sideBar : Bool -> Html
sideBar pipelineRunning =
  let
    buttonClass =
      case pipelineRunning of
        True ->
          "ui button loading"

        _ ->
          "ui green button inverted"
  in
    div
      [ class "five wide column" ]
      [ div
          [ class "pipeline-sidebar" ]
          [ div [ id "editor", class "pipeline-sidebar__editor" ] []
          , button [ id "commit", class buttonClass, disabled pipelineRunning ] [ text "Commit" ]
          ]
      ]



-- UPDATE


type Action
  = NoOp
  | Add
  | CommitCode String
  | Remove
  | Sort


startPipeline : String -> List Step -> List Step
startPipeline code steps =
  case steps of
    [] ->
      []

    s :: steps ->
      { code = code
      , status = Running
      , title = s.title
      , description = s.description
      , icon = s.icon
      , id = s.id
      }
        :: steps


update action model =
  case action of
    NoOp ->
      model

    Sort ->
      { model | steps = List.sortBy .id model.steps }

    Remove ->
      { model
        | code = ""
        , steps = Array.toList (Array.slice 0 -1 (Array.fromList model.steps))
      }

    Add ->
      let
        currentId =
          List.maximum (List.map .id model.steps)

        newId =
          (Maybe.withDefault 0 currentId) + 1

        entryToAdd =
          step ("Job" ++ (toString newId)) "" newId "setting" Waiting
      in
        { model
          | code = ""
          , steps = Array.toList (Array.push entryToAdd (Array.fromList model.steps))
        }

    CommitCode code ->
      { model
        | code = code
        , steps = startPipeline code model.steps
      }



-- VIEW


view : Address Action -> Model -> Html
view address model =
  div
    []
    [ h1
        [ class "ui header" ]
        [ i [ class "settings icon" ] []
        , div
            [ class "content" ]
            [ text model.title
            , div
                [ class "sub header" ]
                [ text model.description
                ]
            ]
        ]
    , hr [] []
    , div
        [ class "ui two column grid" ]
        [ sideBar (List.any (\s -> s.status == Running) model.steps)
        , stepList address model.steps
        ]
    ]



-- SIGNALS


inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions : Signal Action
actions =
  Signal.merge inbox.signal (Signal.map CommitCode currentCode)


model : Signal Model
model =
  Signal.foldp update initialModel actions


main : Signal Html
main =
  Signal.map (view inbox.address) model
