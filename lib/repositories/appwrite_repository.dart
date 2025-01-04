import 'package:habit_quest/common.dart';
import 'package:habit_quest/repositories/repository_structure.dart';

class AppwriteRepository extends StorageRepository {
  final databases = Databases(appwriteClient);
  @override
  Future<void> delete() {
    return LocalStorage.instance.delete();
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

  Future deleteHabit(Habit habit) async {
    await databases.deleteDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      documentId: habit.id,
    );
  }
}
