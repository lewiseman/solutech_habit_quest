import 'package:habit_quest/common.dart';
import 'package:habit_quest/repositories/models/repository_structure.dart';

class AppwriteRepository extends StorageRepository {
  final databases = Databases(appwriteClient);
  @override
  Future<void> delete() {
    return CacheStorage.instance.delete();
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

  @override
  Future<Habit> createHabit(Habit habit) async {
    final data = habit.toJson()..remove('id');
    final res = await databases.createDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      documentId: habit.id,
      data: data,
    );
    final newHabit = Habit.fromJson(res.data);

    return newHabit;
  }

  @override
  Future<List<Habit>> getHabits() async {
    final res = await databases
        .listDocuments(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
    )
        .then((res) {
      return res.documents.map((e) => Habit.fromJson(e.data)).toList();
    });
    return res;
  }

  @override
  Future<Habit> updateHabit(Habit habit) async {
    final data = habit.toJson()..remove('id');
    final res = await databases.updateDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      documentId: habit.id,
      data: data,
    );
    final updatedHabit = Habit.fromJson(res.data);
    return updatedHabit;
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await databases.deleteDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      documentId: habitId,
    );
  }

  @override
  Future<Habit?> getHabit(String id) async {
    final res = await databases
        .getDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      documentId: id,
    )
        .then((res) {
      return Habit.fromJson(res.data);
    });
    return res;
  }
}
