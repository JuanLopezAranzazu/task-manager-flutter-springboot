import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// ─── Servicios ───────────────────────────────────────────────────────────────

final storageServiceProvider = Provider<StorageService>(
  (_) => StorageService(),
);

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.read(storageServiceProvider)),
);

// ─── Auth ─────────────────────────────────────────────────────────────────────

class AuthState {
  final User? user;
  final bool isLoading;
  final bool isChecking; // carga inicial (splash)
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isChecking = true,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isChecking,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        isChecking: isChecking ?? this.isChecking,
        error: clearError ? null : error ?? this.error,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final StorageService _storage;

  AuthNotifier(this._api, this._storage) : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final hasToken = await _storage.hasToken();
    state = state.copyWith(isChecking: false, clearUser: !hasToken);
    // Podríamos llamar /auth/me aquí si quisiéramos hidratar el user
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final json = await _api.login(email, password);
      final auth = AuthResponse.fromJson(json);
      await _storage.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
      );
      state = state.copyWith(user: auth.user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final json = await _api.register(name, email, password);
      final auth = AuthResponse.fromJson(json);
      await _storage.saveTokens(
        accessToken: auth.accessToken,
        refreshToken: auth.refreshToken,
      );
      state = state.copyWith(user: auth.user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    state = const AuthState(isChecking: false);
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.read(apiServiceProvider),
    ref.read(storageServiceProvider),
  ),
);

// ─── Tasks ────────────────────────────────────────────────────────────────────

class TasksState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final int page;
  final bool hasMore;

  const TasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.page = 0,
    this.hasMore = true,
  });

  TasksState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
    int? page,
    bool? hasMore,
    bool clearError = false,
  }) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
      );

  // Stats
  int get total => tasks.length;
  int get pending => tasks.where((t) => t.status == TaskStatus.pending).length;
  int get inProgress =>
      tasks.where((t) => t.status == TaskStatus.inProgress).length;
  int get completed =>
      tasks.where((t) => t.status == TaskStatus.completed).length;
}

class TasksNotifier extends StateNotifier<TasksState> {
  final ApiService _api;

  TasksNotifier(this._api) : super(const TasksState());

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      state = const TasksState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }
    try {
      final json = await _api.getTasks();
      final data = json['data'] as Map<String, dynamic>;
      final content = (data['content'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        tasks: content,
        isLoading: false,
        hasMore: !(data['last'] as bool? ?? true),
        page: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    final nextPage = state.page + 1;
    state = state.copyWith(isLoading: true);
    try {
      final json = await _api.getTasks(page: nextPage);
      final data = json['data'] as Map<String, dynamic>;
      final more = (data['content'] as List)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(
        tasks: [...state.tasks, ...more],
        isLoading: false,
        page: nextPage,
        hasMore: !(data['last'] as bool? ?? true),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> create({
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        if (description?.isNotEmpty == true) 'description': description,
        'priority': priority.apiValue,
        if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
      };
      final json = await _api.createTask(body);
      final task = Task.fromJson(json);
      state = state.copyWith(tasks: [task, ...state.tasks]);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> update({
    required int id,
    required String title,
    String? description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        if (description?.isNotEmpty == true) 'description': description,
        'status': status.apiValue,
        'priority': priority.apiValue,
        if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
      };
      final json = await _api.updateTask(id, body);
      final updated = Task.fromJson(json);
      state = state.copyWith(
        tasks: state.tasks.map((t) => t.id == id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> changeStatus(int id, TaskStatus status) async {
    try {
      final json = await _api.updateTaskStatus(id, status.apiValue);
      final updated = Task.fromJson(json);
      state = state.copyWith(
        tasks: state.tasks.map((t) => t.id == id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _api.deleteTask(id);
      state =
          state.copyWith(tasks: state.tasks.where((t) => t.id != id).toList());
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(ref.read(apiServiceProvider)),
);
