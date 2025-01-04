import 'package:habit_quest/common.dart';
import 'package:habit_quest/repositories/repository_structure.dart';

class AppwriteApiRepository extends StorageRepository {
  @override
  Future<void> delete() {
    return LocalStorage.instance.delete();
  }

  @override
  Future<void> initialize() {
    return LocalStorage.instance.initialize();
  }
}
