port module Views.Feed exposing (..)
{-| Views

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Html.Events exposing (onClick, onInput)

renderEntry : Entry -> Html Msg
renderEntry post =
  div [ class "feed-item__post" ]
    [ a [ href post.link, class "feed-item__post-title" ] [ text post.title ]
    ]

renderFeed : Feed -> Html Msg
renderFeed feed =
  let renderedEntries = List.map renderEntry feed.entries
  in div [ class "feed-item" ]
     [ span [ class "feed-item__name" ] [ text feed.name ]
     , span [] [ text " " ]
     , a [ href "#", class "feed-item__selector", onClick (FeedSelected feed) ] [ text ">>" ]
     --, div [ class "feed-item__posts" ] renderedEntries
     ]

headerView : Model -> Html Msg
headerView model =
  header [] [ div [ class "title-text" ]   [ h1 [] [ text "Reader.elm" ] ]
            , loginState model ]

loginState : Model -> Html Msg
loginState model =
  case model.currentUser of
    Nothing ->
      case model.githubClientId of
        Nothing          -> div [ class "user-profile" ] [ text "No login permitted" ]
        (Just clientId) -> div [ class "user-profile" ] [ githubLogin clientId ]
    (Just user) -> div [ ] [ text user.email ]

footerView : Model -> Html Msg
footerView model =
  footer [] [ text "Reader.elm -- Copyright Franck Verrot 2016" ]

mainView : Model -> Html Msg
mainView model =
  let renderedFeeds = List.map renderFeed model.feeds
  in main' [ class "main-view" ] [ div [ class "feed-list" ] [
                                     div [ class "add-feed-form" ] [ input [ onInput NewFeedInputChanged , placeholder "https://some.news/rss" ] [ text model.newFeedInputString ]
                                                                   , button [ onClick CreateFeed ] [ text "Add Feed" ] ]
                                   , div [ class "feed-items" ] renderedFeeds ]
                                 , entryListView model ]

entryListView : Model -> Html Msg
entryListView model =
  case model.currentFeed of
    Nothing -> div [] [text "Please select a feed!"]
    (Just feed) ->
      let renderedEntries = List.map renderEntry feed.entries
      in div [ class "post-list" ] [ h3 [] [ text feed.name ]
                                   , div [] renderedEntries ]

githubAuthorizeUrl : String -> String
githubAuthorizeUrl clientId = "https://github.com/login/oauth/authorize?client_id=" ++ clientId ++ "&scope=user:email"

githubLogin : String -> Html Msg
githubLogin clientId = div [] [ a [ href (githubAuthorizeUrl clientId) ] [ text "Login with GitHub" ] ]
