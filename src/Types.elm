port module Types exposing (..)
import Http

type Msg = CreateFeed
         | FeedCreationFailed Http.Error
         | FeedCreationSucceeded Feed
         | NewFeedInputChanged String
         | FeedFetchFailed Http.Error
         | FeedFetchSucceeded FeedList
         | FeedSelected Feed

type alias Feed =
  { url: String
  , name: String
  , entries: (List Entry)
  }

type alias Entry =
  { title: String
  , link: String
  }

type alias User =
  {
    email: String
  }

type alias Model =
  { currentUser: Maybe User
  , feeds: (List Feed)
  , newFeedInputString: String
  , currentFeed: Maybe Feed
  , githubClientId: Maybe String
  }

type alias FeedList = List Feed
type alias EntryList = List Entry
