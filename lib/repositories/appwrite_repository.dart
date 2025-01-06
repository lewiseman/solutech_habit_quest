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
  Future<List<Habit>> getHabits(String userId) async {
    final res = await databases.listDocuments(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitsCID,
      queries: [
        Query.equal('user_id', userId),
      ],
    ).then((res) {
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

  @override
  Future<void> createHabits(List<Habit> habits) async {
    for (final habit in habits) {
      await createHabit(habit);
    }
  }

  @override
  Future<void> deleteHabits(List<String> habitIds) async {
    for (final id in habitIds) {
      await deleteHabit(id);
    }
  }

  @override
  Future<void> updateHabits(List<Habit> habits) async {
    for (final habit in habits) {
      await updateHabit(habit);
    }
  }

  @override
  Future<HabitAction> createHabitAction(HabitAction action) async {
    final data = action.toJson()..remove('id');
    final res = await databases.createDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitActionsCID,
      documentId: action.id,
      data: data,
    );
    final newHabit = HabitAction.fromJson(res.data);

    return newHabit;
  }

  @override
  Future<void> createHabitActions(List<HabitAction> actions) async {
    for (final action in actions) {
      await createHabitAction(action);
    }
  }

  @override
  Future<void> deleteHabitAction(String actionId) async {
    await databases.deleteDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitActionsCID,
      documentId: actionId,
    );
  }

  @override
  Future<void> deleteHabitActions(List<String> actionIds) async {
    for (final id in actionIds) {
      await deleteHabitAction(id);
    }
  }

  @override
  Future<HabitAction> updateHabitAction(HabitAction action) async {
    final data = action.toJson()..remove('id');
    final res = await databases.updateDocument(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitActionsCID,
      documentId: action.id,
      data: data,
    );
    final updatedHabitAction = HabitAction.fromJson(res.data);
    return updatedHabitAction;
  }

  @override
  Future<void> updateHabitActions(List<HabitAction> actions) async {
    for (final action in actions) {
      await updateHabitAction(action);
    }
  }

  @override
  Future<List<HabitAction>> getHabitActions(String userId) async {
    final res = await databases.listDocuments(
      databaseId: appwriteDatabaseId,
      collectionId: appwriteHabitActionsCID,
      queries: [
        Query.equal('user_id', userId),
      ],
    ).then((res) {
      return res.documents.map((e) => HabitAction.fromJson(e.data)).toList();
    });
    return res;
  }

  @override
  Future<HabitAction?> getHabitAction(String habitId) {
    // TODO: implement getHabitAction
    throw UnimplementedError();
  }
}
