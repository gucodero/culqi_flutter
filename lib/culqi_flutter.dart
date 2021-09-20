library culqi_flutter;

export 'src/CCard.dart';
export 'src/CToken.dart';
export 'src/errors/CulqiBadRequestException.dart';
export 'src/errors/CulqiUnknownException.dart';

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:culqi_flutter/src/CCard.dart';
import 'package:culqi_flutter/src/CToken.dart';
import 'package:culqi_flutter/src/errors/CulqiBadRequestException.dart';
import 'package:culqi_flutter/src/errors/CulqiUnknownException.dart';

const String _URL_BASE_SECURE = 'https://secure.culqi.com/v2';
const String _URL_TOKENS = '/tokens/';

Future<CToken> createToken(
    {required CCard card, required String apiKey}) async {
  Uri _uri = Uri.https(_URL_BASE_SECURE, _URL_TOKENS);
  http.Response response = await http.post(_uri,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': "Bearer $apiKey"
      },
      body: jsonEncode(card.toJson()));
  switch (response.statusCode) {
    case 201:
      return CToken.fromJson(response.body);
    case 400:
      throw CulqiBadRequestException.fromJson(response.body);
    default:
      throw CulqiUnknownException(
          response.statusCode.toString(), response.body);
  }
}
