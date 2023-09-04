import 'package:at_tareeq/app/data/models/playlist.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';

class PlaylistRepository extends Repository<Playlist> {
  @override
  String resource = 'playlists';

  @override
  Playlist transformModel(data) {
    return Playlist.fromJson(data);
    // return Lecture.fromJson(data);
  }

  @override
  List<Playlist> transformModels(data) {
    return playlistListFromJson(data);
  }
}
