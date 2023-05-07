// class LivestreamStatus {
//   static const notStarted = 1;
//   static const started = 2;
//   static const finished = 3;
// }

enum LivestreamStatus {
  notStarted(notStartedValue),
  started(startedValue),
  finished(finishedValue);

  static const notStartedValue = 1;
  static const startedValue = 2;
  static const finishedValue = 3;

  static String statusString(LivestreamStatus livestreamStatus) {
    switch (livestreamStatus) {
      case LivestreamStatus.started:
        return 'is Live';
      case LivestreamStatus.notStarted:
        return 'Not Started';
      case LivestreamStatus.finished:
        return 'Finished';
    }
  }

  bool isStarted() {
    if (value == startedValue) {
      return true;
    }
    return false;
  }

  bool isNotStarted() {
    if (value == notStartedValue) {
      return true;
    }
    return false;
  }

  bool isEnded() {
    if (value == finishedValue) {
      return true;
    }
    return false;
  }

  String getString() {
    switch (value) {
      case LivestreamStatus.notStartedValue:
        return 'Not Started';
      case LivestreamStatus.startedValue:
        return 'is Live';
      case LivestreamStatus.finishedValue:
        return 'Finished';
      default:
        return 'unknown';
    }
  }

  static LivestreamStatus fromInt(int status) {
    switch (status) {
      case LivestreamStatus.notStartedValue:
        return LivestreamStatus.notStarted;
      case LivestreamStatus.startedValue:
        return LivestreamStatus.started;
      case LivestreamStatus.finishedValue:
        return LivestreamStatus.finished;
      default:
        return LivestreamStatus.notStarted;
    }
  }

  const LivestreamStatus(this.value);
  final num value;
}
