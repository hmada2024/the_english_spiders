//lib/data/repositories/base_repository.dart
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
}