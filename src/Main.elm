port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (program)
import Http exposing (..)
import Json.Decode as Json exposing ((:=), string, list, at)
import Task exposing (..)
import Array exposing (toList)
import Maybe exposing (..)
import Config exposing (..)

import Fixtures exposing (..)
import Types exposing (..)
import Views.Feed exposing (..)

init : (Model, Cmd Msg)
init = (makeModel, getFeeds)

main =
  program { init = init
          , view = view
          , update = update
          , subscriptions = \_ -> Sub.none
        }

css : String -> Html Msg
css path =
    node "link" [ rel "stylesheet", href path ] []

cssUrl = "http://localhost:8080/src/css/style.css"
view model =
  div [ class "faux-main" ] [ css cssUrl
                       , Views.Feed.headerView model
                       , Views.Feed.mainView model
                       , Views.Feed.footerView model
                       ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CreateFeed ->
      (model, addFeed model.newFeedInputString)
    FeedCreationFailed error ->
      ({ model | newFeedInputString = "" }, Cmd.none)
    FeedCreationSucceeded feed ->
      ({ model | newFeedInputString = "", feeds = feed :: model.feeds }, Cmd.none)
    NewFeedInputChanged val ->
      ({ model | newFeedInputString = val }, Cmd.none)
    FeedFetchFailed error ->
      (model, Cmd.none)
    FeedFetchSucceeded feeds ->
      ({ model | feeds = feeds }, Cmd.none)
    FeedSelected feed ->
      ({ model | currentFeed = Just feed }, Cmd.none)

addFeed : String -> Cmd Msg
addFeed feedUrl =
  let response = Http.send defaultSettings (postNewFeedRequest feedUrl)
      feed = fromJson feedDecoder response
  in
     Task.perform FeedCreationFailed FeedCreationSucceeded feed

corsHeaders : List (String, String)
corsHeaders = [ ("Origin", "http://localhost:8000")
              , ("Access-Control-Request-Method", "POST")
              , ("Access-Control-Request-Headers", "X-Custom-Header") ]

jsonHeaders : List (String, String)
jsonHeaders = [ ("Content-Type", "application/json")
              , ("Accept", "application/json") ]

postNewFeedRequest : String -> Request
postNewFeedRequest feedUrl =
  let url = "\"" ++ feedUrl ++ "\""
      body = """{ "feed" : { "url": """ ++ url ++ """ } }"""
  in { verb = "POST"
     , headers = jsonHeaders
     , url = Config.feedsRESTUrl
     , body = Http.string body
     }

getAllFeedsRequest : String -> Request
getAllFeedsRequest feedUrl =
  { verb = "GET"
  , headers = jsonHeaders
  , url = Config.feedsRESTUrl
  , body = empty }

feedDecoder : Json.Decoder Feed
feedDecoder =
  let makeFeed a b = Feed a b []
  in  "feed" := (Json.object2 makeFeed
                   ("url"  := Json.string)
                   ("name" := Json.string))

getFeeds : Cmd Msg
getFeeds =
  --let fetchFeed = Http.get feedsDecoder feedsRESTUrl
  let response  = Http.send defaultSettings (getAllFeedsRequest feedsRESTUrl)
      fetchFeed = fromJson feedsDecoder response
  in
     Task.perform FeedFetchFailed FeedFetchSucceeded fetchFeed

feedsDecoder : Json.Decoder FeedList
feedsDecoder =
  let makeFeed a b = Feed a b []
      entry = Json.object2 Entry
                ("title" := Json.string)
                ("link" := Json.string)
      feed = Json.object3 Feed
                ("url" := Json.string)
                ("name" := Json.string)
                ("entries" := Json.list entry)
  in
     "feeds" := Json.list feed
