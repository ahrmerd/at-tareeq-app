import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';

class LectureRepository extends Repository<Lecture> {
  @override
  String resource = 'lectures';

  @override
  Lecture transformModel(data) {
    return Lecture.fromJson(data);
  }

  @override
  List<Lecture> transformModels(data) {
    return lectureListFromJson(data);
  }
}
