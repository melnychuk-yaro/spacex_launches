import 'package:dio/dio.dart';

import '../models/launch.dart';

class LaunchesRepository {
  static const baseUrl = 'https://api.spacexdata.com/v4';
  final Dio _dio = Dio();

  Future<List<Launch>> loadLaunches() async {
    try {
      final response = await _dio.get('$baseUrl/launches/upcoming');
      if (response.statusCode != 200) throw Exception('${response.statusCode}');
      return response.data.map<Launch>((launchMap) {
        return Launch.fromMap(launchMap);
      }).toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
