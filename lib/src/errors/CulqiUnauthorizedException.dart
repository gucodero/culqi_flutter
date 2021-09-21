import 'dart:convert';

class CulqiUnauthorizedException implements Exception{

  String? type;
  String? userMessage;
  String? merchantMessage;

  CulqiUnauthorizedException.fromJson(String json){
    Map<String, dynamic> data = jsonDecode(json);
    type = data['type'];
    userMessage = data['user_message'];
    merchantMessage = data['merchant_message'];
  }

  Map<String, dynamic> toJson() => {
    'type' : '$type', 
    'user_message' : '$userMessage', 
    'merchant_message' : '$merchantMessage'
  };

  @override
  String toString() {
    return toJson().toString();
  }

}