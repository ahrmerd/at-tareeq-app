import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';

class LectureRepository extends Repository<Lecture> {
  @override
  String resource = 'lectures';

  @override
  Lecture transformModel(data) {
    return Lecture.fromJson(data);
  }

  static Future<void> deleteLecture(Lecture lecture) async {
    await Dependancies.http.delete('lectures/${lecture.id}');
  }

  @override
  List<Lecture> transformModels(data) {
    return lectureListFromJson(data);
  }
}
