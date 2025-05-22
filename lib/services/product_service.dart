import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://threedverse-api.onrender.com', // Cambia por tu URL real
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      
      // Verifica que la respuesta sea una lista
      if (response.data is List) {
        return response.data;
      }
      throw 'Formato de respuesta inválido';
      
    } on DioException catch (e) {
      if (e.response != null) {
        throw 'Error: ${e.response?.statusCode} - ${e.response?.data}';
      } else {
        throw 'Error de conexión: ${e.message}';
      }
    } catch (e) {
      throw 'Error inesperado: $e';
    }
  }
}