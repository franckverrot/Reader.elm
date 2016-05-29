port module Views.Feed exposing (..)
{-| Views

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Html.Events exposing (onClick, onInput)

renderPost : Post -> Html Msg
renderPost post =
  div [ class "feed-item__post-title" ] [ text post.title ]

renderFeed : Feed -> Html Msg
renderFeed feed =
  let renderedPosts = List.map renderPost feed.unreadPosts
  in div [ class "feed-item" ]
     [ div [ class "feed-item__name" ] [ text feed.name ]
     , div [ class "feed-item__url" ] [ text feed.url ]
     , div [ class "feed-item__posts" ] renderedPosts
     ]

headerView : Model -> Html Msg
headerView model =
  header [] [ div [ class "title-text" ]   [ h1 [] [ text "Reader.elm" ] ]
            , loginState model ]

loginState : Model -> Html Msg
loginState model =
  case model.currentUser of
    Nothing     ->
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
  in main' [ class "main-view" ] [
       div [ class "feed-list" ] [
        div [ class "add-feed-form" ] [ input [ onInput NewFeedInputChanged , placeholder "https://some.news/rss" ] [ text model.newFeedInputString ]
                                        , button [ onClick CreateFeed ] [ text "Add Feed" ] ]
       , div [ class "feed-items" ] renderedFeeds ] ]

githubAuthorizeUrl : String -> String
githubAuthorizeUrl clientId = "https://github.com/login/oauth/authorize?client_id=" ++ clientId ++ "&scope=user:email"

githubLogin : String -> Html Msg
githubLogin clientId = div [] [ a [ href (githubAuthorizeUrl clientId) ] [ text "Login with GitHub" ] ]
