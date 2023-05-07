enum LibraryType {
  history,
  playLater,
  favorite,
  ;

  String getTitle() {
    switch (this) {
      case LibraryType.history:
        return 'History';
      case LibraryType.playLater:
        return 'Play Later';
      case LibraryType.favorite:
        return 'Favorite';
    }
  }
}
