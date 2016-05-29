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
        (Entry "Hello World 1.1" "This is some content")
        , (Entry "Hello World 1.2" "This is another content")
      ])
    , (Feed "http://feed2" "Feed 2" [
        (Entry "Hello World 2.1" "This is some content")
        , (Entry "Hello World 2.2" "This is another content")
      ])

  ] "" Nothing Config.githubClientId

{-| Default non-user -}
noUser : Maybe User
noUser = Nothing
