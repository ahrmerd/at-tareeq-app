import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';

class SectionOrInterestRepository extends Repository<SectionOrInterest> {
  @override
  String resource = 'interests';

  @override
  SectionOrInterest transformModel(data) {
    return SectionOrInterest.fromJson(data);
  }

  @override
  List<SectionOrInterest> transformModels(data) {
    return sectionOrInterestListFromJson(data);
  }
}
