import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';

import 'repository.dart';

class LiveMessageRepository extends Repository<LiveMessage> {
  @override
  String resource = 'livemessage';

  @override
  LiveMessage transformModel(data) {
    return LiveMessage.fromJson(data);
  }

  @override
  List<LiveMessage> transformModels(data) {
    return liveMessageListFromJson(data);
  }
}
