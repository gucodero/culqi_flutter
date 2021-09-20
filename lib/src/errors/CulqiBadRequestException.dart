import 'dart:convert';

class CulqiBadRequestException implements Exception{

  String? type;
  String? code;
  String? cause;
  String? message;
  String? param;

  CulqiBadRequestException.fromJson(String json){
    Map<String, dynamic> data = jsonDecode(json);
    type = data['type'];
    code = data['code'];
    cause = data['merchant_message'];
    message = data['user_message'];
    param = data['param'];
  }

  Map<String, dynamic> toJson() => {
    'type' : '$type', 
    'code' : '$code', 
    'cause' : '$cause', 
    'message' : '$message', 
    'param' : '$param'
  };

  @override
  String toString() {
    return toJson().toString();
  }

}