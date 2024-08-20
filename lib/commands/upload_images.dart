import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToS3(Uint8List data, String fileName) async {
  dynamic res;
  try {
    String apiGatewayUrl = dotenv.env['API_GATEWAY_URL']!;
    if (apiGatewayUrl.isEmpty) {
      print('API_GATEWAY_URL is not set');
      return null;
    }
    res = await http.post(
      Uri.parse('$apiGatewayUrl/upload'),
      body: jsonEncode(<String, dynamic>{
        'fileName': fileName,
        'fileContent': base64Encode(data),
      }),
    );
    print(res.body);
    if (res.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  } on Exception catch (e) {
    log(e.toString());
    return null;
  }
  return jsonDecode(res.body)['url'];
}
