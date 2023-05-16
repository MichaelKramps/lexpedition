enum ErrorDefinition { 
  noError,
  levelFetchError,
  peerConnectionError
}

String getErrorMessage(ErrorDefinition error) {
  switch (error) {
    case ErrorDefinition.levelFetchError:
      return "There was a problem retrieving a puzzle at this time.  Verify you are connected to the internet and try again.  If the problem persists try again later.";
    default:
      return "Something went wrong, please try again.";
  }
}