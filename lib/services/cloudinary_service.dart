import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shatter_vcs/config/network_exception.dart';

class CloudinaryService {
  final _dio = Dio();

  Future<Either<String, NetworkException>> uploadImage(File image) async {
    try {
      final presetName = await dotenv.env['PRESET_NAME'];
      final cloudName = await dotenv.env['CLOUD_NAME'];
      final url = 'https://api.cloudinary.com/v1_1/${cloudName}/upload';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'upload_preset': presetName,
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'X-Requested-With': 'XMLHttpRequest'},
        ),
      );
      // print(response.data);
      return left(response.data['secure_url']);
    } catch (e) {
      print(e);
      return right(NetworkException("Error Uploading Message", 500));
    }
  }
}
