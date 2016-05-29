port module Types exposing (..)
import Http

type Msg = CreateFeed
         | FeedCreationFailed Http.Error
         | FeedCreationSucceeded Feed
         | NewFeedInputChanged String
         | FeedFetchFailed Http.Error
         | FeedFetchSucceeded FeedsList

type alias Feed =
  { url: String
  , name: String
  , unreadPosts: List Post
  }

type alias Post =
  { title: String
  , content: String
  }

type alias User =
  {
    email: String
  }

type alias Model =
  { currentUser: Maybe User
  , feeds: (List Feed)
  , newFeedInputString: String
  , githubClientId: Maybe String
  }

type alias FeedsList = List Feed
