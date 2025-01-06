import 'dart:convert';

import 'package:habit_quest/common.dart';

final exploreServiceDataProvider = FutureProvider((ref) async {
  final res =
      await AppRepository.instance.remoteRepository.databases.listDocuments(
    databaseId: appwriteDatabaseId,
    collectionId: '677c023a002ed642a3d1',
    queries: [
      Query.limit(1),
    ],
  ).then((res) {
    return res.documents.first.data;
  });
  final data = res['data'] as String;
  final parsed = jsonDecode(data) as Map<String, dynamic>;
  return parsed;
});
