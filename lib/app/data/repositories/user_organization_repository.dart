import 'package:at_tareeq/app/data/models/user.dart';

import 'repository.dart';

class UserOrOrganizationTepository extends Repository<User> {
  @override
  String resource = 'users';

  @override
  User transformModel(data) {
    print(data);

    return User.fromJson(data);
  }

  @override
  List<User> transformModels(data) {
    print(data);
    return userListFromJson(data);
  }
}
