import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

class ApiService {
  late final Dio _dio;
  final StorageService _storage;

  ApiService(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _attachToken,
      onError: _handleError,
    ));
  }

  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );
          final data = response.data['data'] as Map<String, dynamic>;
          await _storage.saveTokens(
            accessToken: data['accessToken'] as String,
            refreshToken: data['refreshToken'] as String,
          );
          error.requestOptions.headers['Authorization'] =
              'Bearer ${data['accessToken']}';
          final retried = await _dio.fetch(error.requestOptions);
          handler.resolve(retried);
          return;
        } catch (_) {
          await _storage.clear();
        }
      }
    }
    handler.next(error);
  }

  // Helpers
  Map<String, dynamic> _extractData(Response response) {
    final body = response.data as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>? ?? body;
  }

  String _errorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) return data['message']?.toString() ?? 'Error desconocido';
    return switch (e.type) {
      DioExceptionType.connectionError => 'Sin conexión a internet',
      DioExceptionType.connectionTimeout => 'Tiempo de espera agotado',
      _ => 'Error del servidor (${e.response?.statusCode})',
    };
  }

  // ─── Auth ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  // ─── Tasks ───────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getTasks({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final res = await _dio.get(
        '/tasks',
        queryParameters: {'page': page, 'size': size, 'direction': 'desc'},
      );
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/tasks', data: body);
      return _extractData(res);
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<Map<String, dynamic>> updateTask(
    int id,
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _dio.put('/tasks/$id', data: body);
      return _extractData(res);
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<Map<String, dynamic>> updateTaskStatus(
    int id,
    String status,
  ) async {
    try {
      final res =
          await _dio.patch('/tasks/$id/status', data: {'status': status});
      return _extractData(res);
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/tasks/$id');
    } on DioException catch (e) {
      throw _errorMessage(e);
    }
  }
}
