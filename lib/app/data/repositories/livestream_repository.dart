import 'package:at_tareeq/app/data/models/livestream.dart';

import 'repository.dart';

class LivestreamRepository extends Repository<Livestream> {
  @override
  String resource = 'livesstreams';

  @override
  Livestream transformModel(data) {
    return Livestream.fromJson(data);
  }

  @override
  List<Livestream> transformModels(data) {
    return livestreamListFromJson(data);
  }
}
