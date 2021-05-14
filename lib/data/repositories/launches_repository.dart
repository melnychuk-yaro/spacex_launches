import 'dart:io';

import 'package:dio/dio.dart';

import '../../logic/services/failure.dart';
import '../models/launch.dart';

class LaunchesRepository {
  static const baseUrl = 'https://api.spacexdata.com/v4';
  final Dio _dio = Dio();

  Future<List<Launch>> loadLaunches() async {
    try {
      final response = await _dio.get('$baseUrl/launches/upcoming');
      if (response.statusCode != 200) throw Failure('${response.statusCode}');
      return response.data
          .map<Launch>((launchMap) => Launch.fromMap(launchMap))
          .toList();
    } on SocketException {
      throw Failure('No internet conneciton.');
    } on HttpException {
      throw Failure('Couldn\'t find movies.');
    } on FormatException {
      throw Failure('Bad response format.');
    }
  }
}
