class SyncState {
  const SyncState();
}

class LoadingSyncState extends SyncState {
  const LoadingSyncState();
}

class SyncedSyncState extends SyncState {
  SyncedSyncState(this.time);
  final DateTime time;
}

class ErrorSyncState extends SyncState {
  ErrorSyncState(this.error);

  final String error;
}
