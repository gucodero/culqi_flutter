import 'dart:convert';

class CToken {
  String? id;
  String? type;
  DateTime? creationDate;
  String? email;
  String? cardNumber;
  String? lastFour;
  bool? active;
  Iin? iin;
  Client? client;

  CToken.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    id = data['id'];
    type = data['type'];
    creationDate =
        new DateTime.fromMillisecondsSinceEpoch(data['creation_date']);
    email = data['email'];
    cardNumber = data['card_number'];
    lastFour = data['last_four'];
    active = data['active'];
    iin = Iin.fromMap(data['iin']);
    client = Client.fromMap(data['client']);
  }

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'type': '$type',
        'creationDate': '$creationDate',
        'email': '$email',
        'cardNumber': '$cardNumber',
        'lastFour': '$lastFour',
        'active': '$active',
        'iin': '${iin.toString()}',
        'client': '${client.toString()}'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Iin {
  String? bin;
  String? cardBrand;
  String? cardType;
  String? cardCategory;
  List? installmentsAllowed;
  Issuer? issuer;

  Iin.fromMap(Map<String, dynamic> data) {
    bin = data['bin'];
    cardBrand = data['card_brand'];
    cardType = data['card_type'];
    cardCategory = data['card_category'];
    installmentsAllowed = data['installments_allowed'];
    issuer = Issuer.fromMap(data['issuer']);
  }

  Map<String, dynamic> toJson() => {
        'bin': '$bin',
        'cardBrand': '$cardBrand',
        'cardType': '$cardType',
        'cardCategory': '$cardCategory',
        'installmentsAllowed': '$installmentsAllowed',
        'issuer': '${issuer.toString()}'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Issuer {
  String? name;
  String? country;
  String? countryCode;
  String? website;
  String? phoneNumber;

  Issuer.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    country = data['country'];
    countryCode = data['country_code'];
    website = data['website'];
    phoneNumber = data['phone_number'];
  }

  Map<String, dynamic> toJson() => {
        'name': '$name',
        'country': '$country',
        'countryCode': '$countryCode',
        'website': '$website',
        'phoneNumber': '$phoneNumber'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Client {
  String? ip;
  String? ipCountry;
  String? ipCountryCode;
  String? browser;
  String? deviceFingerprint;
  String? deviceType;

  Client.fromMap(Map<String, dynamic> data) {
    ip = data['ip'];
    ipCountry = data['ip_country'];
    ipCountryCode = data['ip_country_code'];
    browser = data['browser'];
    deviceFingerprint = data['device_fingerprint'];
    deviceType = data['device_type'];
  }

  Map<String, dynamic> toJson() => {
        'ip': '$ip',
        'ipCountry': '$ipCountry',
        'ipCountryCode': '$ipCountryCode',
        'browser': '$browser',
        'deviceFingerprint': '$deviceFingerprint',
        'deviceType': '$deviceType'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
