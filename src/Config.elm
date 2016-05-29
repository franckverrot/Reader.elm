port module Config exposing (..)
{-| Config data

@docs githubClientId
-}
{-| REST endpoint for the feeds API-}
feedsRESTUrl : String
feedsRESTUrl = "http://localhost:4000/feeds"

{-| Default client ID used for this app -}
githubClientId : Maybe String
githubClientId = Just "627c66b952436ef1f92b"
