import 'package:hive_ce_flutter/hive_flutter.dart';

enum SyncAction { create, update, delete }

enum SyncItem { habit, habitActivity }

class SyncEntry extends HiveObject {
  SyncEntry({
    required this.id,
    required this.action,
    required this.item,
    required this.itemId,
    required this.actionTime,
  });

  final String id;
  final SyncAction action;
  final SyncItem item;
  final String itemId;
  final DateTime actionTime;
}
