// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      title: fields[1] as String,
      emoji: fields[2] as String,
      time: fields[4] as String,
      startDate: fields[5] as DateTime,
      frequency: fields[7] as HabitFrequency,
      paused: fields[8] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
      userId: fields[9] as String,
      description: fields[3] as String?,
      days: (fields[6] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.days)
      ..writeByte(7)
      ..write(obj.frequency)
      ..writeByte(8)
      ..write(obj.paused)
      ..writeByte(9)
      ..write(obj.userId)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitFrequencyAdapter extends TypeAdapter<HabitFrequency> {
  @override
  final int typeId = 1;

  @override
  HabitFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitFrequency.daily;
      case 1:
        return HabitFrequency.weekly;
      case 2:
        return HabitFrequency.once;
      default:
        return HabitFrequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, HabitFrequency obj) {
    switch (obj) {
      case HabitFrequency.daily:
        writer.writeByte(0);
      case HabitFrequency.weekly:
        writer.writeByte(1);
      case HabitFrequency.once:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncEntryAdapter extends TypeAdapter<SyncEntry> {
  @override
  final int typeId = 2;

  @override
  SyncEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncEntry(
      id: fields[0] as String,
      action: fields[1] as SyncAction,
      item: fields[2] as SyncItem,
      itemId: fields[3] as String,
      actionTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SyncEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.item)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.actionTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncItemAdapter extends TypeAdapter<SyncItem> {
  @override
  final int typeId = 3;

  @override
  SyncItem read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncItem.habit;
      case 1:
        return SyncItem.habitActivity;
      default:
        return SyncItem.habit;
    }
  }

  @override
  void write(BinaryWriter writer, SyncItem obj) {
    switch (obj) {
      case SyncItem.habit:
        writer.writeByte(0);
      case SyncItem.habitActivity:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncActionAdapter extends TypeAdapter<SyncAction> {
  @override
  final int typeId = 4;

  @override
  SyncAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncAction.create;
      case 1:
        return SyncAction.update;
      case 2:
        return SyncAction.delete;
      default:
        return SyncAction.create;
    }
  }

  @override
  void write(BinaryWriter writer, SyncAction obj) {
    switch (obj) {
      case SyncAction.create:
        writer.writeByte(0);
      case SyncAction.update:
        writer.writeByte(1);
      case SyncAction.delete:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitActionAdapter extends TypeAdapter<HabitAction> {
  @override
  final int typeId = 5;

  @override
  HabitAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitAction(
      id: fields[0] as String,
      habitId: fields[1] as String,
      userId: fields[2] as String,
      action: fields[3] as HabitActionType,
      updatedAt: fields[5] as DateTime,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HabitAction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitActionTypeAdapter extends TypeAdapter<HabitActionType> {
  @override
  final int typeId = 6;

  @override
  HabitActionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitActionType.done;
      case 1:
        return HabitActionType.skipped;
      default:
        return HabitActionType.done;
    }
  }

  @override
  void write(BinaryWriter writer, HabitActionType obj) {
    switch (obj) {
      case HabitActionType.done:
        writer.writeByte(0);
      case HabitActionType.skipped:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitActionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
