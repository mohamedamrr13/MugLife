import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final Dio dio;
  Api(this.dio);
  Future<dynamic> get({required String url}) async {
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
        'There is a problem with the status code ${response.statusCode}',
      );
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    Response response = await dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      debugPrint('paying product----------------- ${response.data}');
      return response.data;
    } else {
      throw Exception(
        'There is a problem with the status code ${response.statusCode} and body is ${response.data}',
      );
    }
  }

  Future<dynamic> put({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'});
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    debugPrint('url = $url body = $body token = $token ');
    Response response = await dio.put(
      url,
      data: body,
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      debugPrint(response.data);
      return response.data;
    } else {
      throw Exception(
        'error with status code ${response.statusCode} and the body is ${response.data}',
      );
    }
  }
}
