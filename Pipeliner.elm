module Pipeliner (..) where

import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Signal exposing (Address)
import Json.Decode exposing (Decoder, decodeValue, object5, (:=), int, string, list, maybe)


-- PORTS


port currentCode : Signal ( String, Json.Decode.Value )



-- MODEL


type alias Annotation =
  { row : Int
  , column : Maybe Int
  , errorType : String
  , raw : String
  , text : String
  }


annotationsDecoder : Decoder (List Annotation)
annotationsDecoder =
  Json.Decode.list
    (object5
      Annotation
      ("row" := int)
      (maybe ("column" := int))
      ("errorType" := string)
      ("raw" := string)
      ("text" := string)
    )


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
  , annotations : List Annotation
  , steps : List Step
  }


initialModel : Model
initialModel =
  { title = "Hello Pipelines!"
  , description = "Example description"
  , code = ""
  , annotations = []
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
      "grey"

    Running ->
      "yellow"

    Failed ->
      "red"

    Success ->
      "green"


mapStatusToIcon : Status -> String -> String
mapStatusToIcon status icon =
  case status of
    Running ->
      "setting loading icon"

    Failed ->
      "red warning icon"

    _ ->
      ""


stepItem : Address Action -> Step -> Html
stepItem address entry =
  let
    icon =
      (mapStatusToIcon entry.status entry.icon)

    status =
      (mapStatusToCss entry.status) ++ " card"
  in
    a
      [ class status ]
      [ div
          [ class "content" ]
          [ div
              [ class "header", contenteditable True ]
              [ text ((toString entry.id) ++ " " ++ entry.title)
              , i [ class icon ] []
              ]
          , div
              [ class "meta" ]
              [ span
                  [ class "right floated time" ]
                  [ text "Last build: 2 days ago"
                  ]
              , span
                  [ class "category" ]
                  [ text "Waiting"
                  ]
              ]
          , div
              [ class "description", contenteditable True ]
              [ p [] [ text entry.description ]
              , a
                  [ class "ui right corner label" ]
                  [ i [ class "info icon" ] []
                  ]
              ]
          , div
              [ class "extra content", contenteditable True ]
              [ text "Add description"
              , div
                  [ class "right floated author" ]
                  [ text "Author"
                  ]
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
      [ id "builds", class "eleven wide column" ]
      [ div [ class "ui three cards" ] stepItems
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


statusLog: Html
statusLog =
  div [ class "ui info message" ]
        [ div [ class "header"]
              [ text "Info Log Output"]
        , ul [ class "list" ]
             [ li [] [ text "it's good"]
             , li [] [ text "it's better"]
             ]
        ]


-- UPDATE


type Action
  = NoOp
  | Add
  | CommitCode ( String, Json.Decode.Value )
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


update : Action -> Model -> Model
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

    CommitCode ( code, annotationsJson ) ->
      { model
        | code = code
        , annotations = Result.withDefault [] (decodeValue annotationsDecoder annotationsJson)
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
            [ class "content", contenteditable True ]
            [ text model.title
            , div
                [ class "sub header", contenteditable True ]
                [ text model.description
                ]
            ]
        ]
    , hr [] []
    , div
        [ class "ui two column divided grid" ]
        [ div
            [ class "row" ]
            [ sideBar (List.any (\s -> s.status == Running) model.steps)
            , stepList address model.steps
            ]
        ]
    , div
        [ class "ui top attached tabular menu" ]
        [ a [ class "item", attribute "data-tab" "first" ]
              [ text "System Log" ]
        , a [ class "item", attribute "data-tab" "second" ]
              [ text "Build log" ]
        , a [ class "item active", attribute "data-tab" "third" ]
              [ text "Site Preview" ]
        ]
    , div
        [ class "ui bottom attached tab segment", attribute "data-tab" "first" ]
        [ pre []
          [ text "[INFO] Pipeline up and running."
          , br [] []
          , text "[INFO] Jobs waiting for action."
          , br [] []
          , text "[INFO] Code commited to Build."
          ]
        ]
    , div
        [ class "ui bottom attached tab segment", attribute "data-tab" "second" ]
        [ pre []
          [ text "[INFO] Waiting."
          ]
        ]
    , div
        [ class "ui bottom attached tab segment active", attribute "data-tab" "third" ]
        [ iframe
          [ style [ ("backgroundColor", "red")
    , ("height", "190px")
    , ("width", "100%")
    ] , srcdoc "<div>Website preview inside iframe</div><h1>No code has been deployed yet. Keep it coming!</h1>" ]
          []
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
