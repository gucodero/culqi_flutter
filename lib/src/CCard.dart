import 'package:email_validator/email_validator.dart';

class CCard {
  static const int ANY = 0,
      VISA = 1,
      MASTER_CARD = 2,
      DINERS_CLUB = 4,
      AMERICAN_EXPRESS = 5;

  late String _cardNumber;
  String cvv;
  int expirationMonth;
  int expirationYear;
  String email;

  CCard(
      {String cardNumber = '',
      this.cvv = '',
      this.expirationMonth = 0,
      this.expirationYear = 0,
      this.email = ''}) {
    this._cardNumber = cardNumber;
  }

  String get cardNumber {
    return _cardNumber.replaceAll(' ', '');
  }

  set cardNumber(String value) {
    _cardNumber = value;
  }

  String getFormattedCardNumber(int spacing) {
    String number = cardNumber;
    List<String> parts = [];
    bool finish = false;
    for (int i = 1; i <= number.length; i++) {
      if (i % 4 == 0) {
        parts.add(number.substring(i - 4, i));
        finish = true;
      } else {
        finish = false;
      }
    }
    if (!finish) {
      int part = number.length ~/ 4;
      parts.add(number.substring(part * 4));
    }
    String separator = '';
    for (int i = 0; i < spacing; i++) separator += ' ';
    return parts.join(separator);
  }

  //luhn algorithm
  bool isCardNumberValid() {
    int size = cardNumber.length;
    //invertimos el numero de tarjeta
    String cardNumberReverse =
        String.fromCharCodes(cardNumber.runes.toList().reversed);
    try {
      int.parse(cardNumber);
    } catch (_) {
      return false;
    }
    // Sin necesidad de aplicar algoritmo
    if (size < 8) {
      return false;
    }

    int sum = 0;
    //recorremos digito por digito
    for (int i = 0; i < size; i++) {
      int digit = int.parse(cardNumberReverse[i]);
      //si la posicion es impar contando desde 0 duplicamos el valor
      if (i % 2 == 1) {
        digit *= 2;
      }

      //si el numero tiene dos digitos le restamos 9 para que vuelva a tener un digito

      sum += digit > 9 ? (digit - 9) : digit;
    }
    return sum % 10 == 0;
  }

  bool isYearValid() {
    if (expirationYear > 99) {
      return false;
    }
    return (expirationYear + 2000) >= DateTime.now().year;
  }

  bool isMonthValid() {
    return expirationMonth <= 12 && expirationMonth >= 1;
  }

  bool isExpirationDateValid() {
    if (isYearValid() && isMonthValid()) {
      if ((expirationYear + 2000) == DateTime.now().year) {
        return expirationMonth > DateTime.now().month;
      }
      return true;
    }
    return false;
  }

  bool isCcvValid() {
    try {
      int.parse(cvv);
    } catch (_) {
      return false;
    }

    return cvv.length == 3 || cvv.length == 4;
  }

  bool isEmailValid() {
    return EmailValidator.validate(email);
  }

  int getBrand() {
    try {
      int.parse(cardNumber);
    } catch (_) {
      return ANY;
    }

    String card = cardNumber;

    if (card.length >= 3) {
      int n = int.parse(card.substring(0, 3));
      if ((n >= 300 && n <= 305) || n == 309) {
        return DINERS_CLUB;
      }
    }

    if (card.length >= 2) {
      int n = int.parse(card.substring(0, 2));
      if (n == 36 || n == 38 || n == 39) {
        return DINERS_CLUB;
      } else if (n == 34 || n == 37) {
        return AMERICAN_EXPRESS;
      } else if (n >= 51 && n <= 55) {
        return MASTER_CARD;
      }
    }

    if (card.length >= 1) {
      int n = int.parse(card[0]);
      if (n == 4) {
        return VISA;
      }
    }
    return ANY;
  }

  Map<String, dynamic> toJson() => {
        'card_number': '$cardNumber',
        'cvv': '$cvv',
        'expiration_month': expirationMonth,
        'expiration_year': expirationYear + 2000,
        'email': email
      };
}
