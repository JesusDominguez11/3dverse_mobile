import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio(BaseOptions(
    baseUrl: 'https://threedverse-api.onrender.com', // IMPORTANTE: Cambia esto
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'usernameOrEmail': username,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      // Manejo detallado de errores
      if (e.type == DioExceptionType.connectionTimeout) {
        throw 'Tiempo de conexión agotado. Revisa tu conexión a internet';
      } else if (e.type == DioExceptionType.connectionError) {
        throw 'Error de conexión. Verifica la URL de la API';
      } else if (e.response != null) {
        // Error del servidor (4xx, 5xx)
        throw 'Error del servidor: ${e.response?.statusCode} - ${e.response?.data?['message']}';
      } else {
        throw 'Error desconocido: ${e.message}';
      }
    } catch (e) {
      throw 'Error inesperado: $e';
    }
  }


  // En tu archivo auth_service.dart
Future<Map<String, dynamic>> register({
  required String username,
  required String email,
  required String password,
  required String name,
}) async {
  try {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'name': name,
      },
    );
    
    if (response.data['token'] == null || response.data['user'] == null) {
      throw 'Respuesta inválida del servidor';
    }
    
    return response.data;
  } on DioException catch (e) {
    if (e.response != null) {
      final errorData = e.response?.data;
      final errorMessage = errorData['message'] ?? 'Error en el registro';
      final errorType = errorData['type'] ?? 'AuthError';
      
      throw '$errorType: $errorMessage';
    } else {
      throw 'Error de conexión: ${e.message}';
    }
  } catch (e) {
    throw 'Error inesperado: $e';
  }
}

}









