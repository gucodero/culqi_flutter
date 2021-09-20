import 'package:flutter_test/flutter_test.dart';
import 'package:culqi_flutter/culqi_flutter.dart';

void main() {
  test('Is card number valid', () {
    CCard card = CCard(cardNumber: '4557 880 ');
    expect(card.isCardNumberValid(), false);
    card.cardNumber = '4557 8805 8520';
    expect(card.isCardNumberValid(), false);
    card.cardNumber = '4557 8805 8520 8147';
    expect(card.isCardNumberValid(), true);
    card.cardNumber = '4557 8805 8520 8146';
    expect(card.isCardNumberValid(), false);
    card.cardNumber = '4557 8805 852A 8146';
    expect(card.isCardNumberValid(), false);
  });

  test('Is year valid', () {
    CCard card = CCard(expirationYear: 10);
    expect(card.isYearValid(), false);
    card.expirationYear = 1;
    expect(card.isYearValid(), false);
    card.expirationYear = 19;
    expect(card.isYearValid(), false);
    card.expirationYear = 123;
    expect(card.isYearValid(), false);
    card.expirationYear = 20;
    expect(card.isYearValid(), false);
    card.expirationYear = 22;
    expect(card.isYearValid(), true);
  });

  test('Is Month valid', () {
    CCard card = CCard(expirationMonth: 0);
    expect(card.isMonthValid(), false);
    card.expirationMonth = 1;
    expect(card.isMonthValid(), true);
    card.expirationMonth = 12;
    expect(card.isMonthValid(), true);
    card.expirationMonth = 13;
    expect(card.isMonthValid(), false);
    card.expirationMonth = 5;
    expect(card.isMonthValid(), true);
  });

  test('Is expiration date valid', () {
    CCard card = CCard(expirationYear: 0, expirationMonth: 0);
    expect(card.isExpirationDateValid(), false);
    card.expirationMonth = DateTime.now().month + 1;
    card.expirationYear = DateTime.now().year - 2000;
    expect(card.isExpirationDateValid(), true);
    card.expirationMonth = 12;
    card.expirationYear = DateTime.now().year - 2001;
    expect(card.isExpirationDateValid(), false);
    card.expirationMonth = DateTime.now().month;
    card.expirationYear = DateTime.now().year - 1999;
    expect(card.isExpirationDateValid(), true);
    card.expirationMonth = DateTime.now().month;
    card.expirationYear = DateTime.now().year;
    expect(card.isExpirationDateValid(), false);
  });

  test('Is cvv valid', () {
    CCard card = CCard(cvv: 'as');
    expect(card.isCcvValid(), false);
    card.cvv = '';
    expect(card.isCcvValid(), false);
    card.cvv = '1';
    expect(card.isCcvValid(), false);
    card.cvv = 'a23';
    expect(card.isCcvValid(), false);
    card.cvv = '13';
    expect(card.isCcvValid(), false);
    card.cvv = '123';
    expect(card.isCcvValid(), true);
    card.cvv = '1234';
    expect(card.isCcvValid(), true);
    card.cvv = '12345';
    expect(card.isCcvValid(), false);
  });

  test('Get brand', () {
    CCard card = CCard(cardNumber: '3000');
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '305';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '302';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '309';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '36047';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '38047';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '39';
    expect(card.getBrand(), CCard.DINERS_CLUB);
    card.cardNumber = '34512';
    expect(card.getBrand(), CCard.AMERICAN_EXPRESS);
    card.cardNumber = '3712';
    expect(card.getBrand(), CCard.AMERICAN_EXPRESS);
    card.cardNumber = '5152';
    expect(card.getBrand(), CCard.MASTER_CARD);
    card.cardNumber = '5523';
    expect(card.getBrand(), CCard.MASTER_CARD);
    card.cardNumber = '45578805';
    expect(card.getBrand(), CCard.VISA);
    card.cardNumber = '4';
    expect(card.getBrand(), CCard.VISA);
    card.cardNumber = '128';
    expect(card.getBrand(), CCard.ANY);
  });

  String testApiKey = "sk_test_UTCQSGcXW8bCyU59";

  test('Create Token', () async {
    // Referencia de tarjetas de prueba:
    // https://docs.culqi.com/#/desarrollo/tarjetas
    // Caso exitoso:
    CCard card = CCard(
        cardNumber: '4111 1111 1111 1111',
        expirationMonth: 09,
        expirationYear: 25,
        cvv: '123',
        email: 'pablo@hotmail.com');
    expect(await createToken(card: card, apiKey: testApiKey),
        isInstanceOf<CToken>());
    // Caso: sin correo
    card = CCard(
      cardNumber: '4111 1111 1111 1111',
      expirationMonth: 09,
      expirationYear: 25,
      cvv: '123',
    );
    expect(() async => await createToken(card: card, apiKey: testApiKey),
        throwsA(isInstanceOf<CulqiBadRequestException>()));
    // Caso: con tarjeta errada
    card = CCard(
        cardNumber: '4111 1111 1111',
        expirationMonth: 09,
        expirationYear: 22,
        cvv: '123',
        email: 'pablo@hotmail.com');
    expect(() async => await createToken(card: card, apiKey: testApiKey),
        throwsA(isInstanceOf<CulqiBadRequestException>()));
  });

  test('Create token fail por tarjeta robada o perdida', () async {
    // Todos estos deberían fallar en el servidor de
    // culqi pero por alguna razón funcionan:
    // Caso: tarjeta robada
    CCard card = CCard(
        cardNumber: '4000 0200 0000 0000',
        expirationMonth: 10,
        expirationYear: 25,
        cvv: '354',
        email: 'pablo@hotmail.com');
    expect(await createToken(card: card, apiKey: testApiKey),
        isInstanceOf<CToken>());
    // expect(() async => await createToken(card: card, apiKey: testApiKey),
    //     throwsA(isInstanceOf<CulqiBadRequestException>()));
    // Caso: tarjeta perdida
    card = CCard(
        cardNumber: '4000 0300 0000 0009',
        expirationMonth: 08,
        expirationYear: 25,
        cvv: '836',
        email: 'pablo@hotmail.com');
    expect(await createToken(card: card, apiKey: testApiKey),
        isInstanceOf<CToken>());
    // expect(() async => await createToken(card: card, apiKey: testApiKey),
    //     throwsA(isInstanceOf<CulqiBadRequestException>()));
    // Caso: fondos insuficientes
    card = CCard(
        cardNumber: '4000 0400 0000 0008',
        expirationMonth: 03,
        expirationYear: 25,
        cvv: '295',
        email: 'pablo@hotmail.com');
    expect(await createToken(card: card, apiKey: testApiKey),
        isInstanceOf<CToken>());
    // expect(await createToken(card: card, apiKey: testApiKey),
    //     isInstanceOf<CToken>());
  });
}
