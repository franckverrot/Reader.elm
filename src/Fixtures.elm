port module Fixtures exposing (..)
{-| Fixtures

@docs makeModel
@docs noUser
-}
import Types exposing (..)
import Config exposing (..)

{-| Default model for test purpose -}
makeModel : Model
makeModel = Model noUser [
    (Feed "http://feed1" "Feed 1" [
        (Post "Hello World 1.1" "This is some content")
        , (Post "Hello World 1.2" "This is another content")
      ])
    , (Feed "http://feed2" "Feed 2" [
        (Post "Hello World 2.1" "This is some content")
        , (Post "Hello World 2.2" "This is another content")
      ])

  ] "" Config.githubClientId

{-| Default non-user -}
noUser : Maybe User
noUser = Nothing
