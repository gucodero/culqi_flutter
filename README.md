# culqi_flutter

<a href="https://github.com/gucodero/culqi_flutter">
    <img src="https://i.ibb.co/R4ZN8Yz/culqi-flutter-logo.png"/>
</a>

## Resumen

Es una librería para flutter que implementa la creación de token en la pasarela de pagos Culqi.
Este repositorio no es oficial, por lo que no es mantenida por el equipo de desarrollo de Culqi.

## Características

* Proporciona una clase que gestiona los datos de la tarjeta.
* Brinda diferentes validaciones para evitar problemas innecesarios al enviar los datos bancarios a los servidores de Culqi.
* Implementa las excepciones arrojadas por la API de Culqi.
* Proporciona una clase con los datos generados por la API de Culqi al generar el token.

## Uso

Agregue esta línea a su archivo pubspec.yaml

```yaml

    dependencies:
        culqi_flutter: ^1.0.0

```

Importe el paquete de esta manera

```dart

    import 'package:culqi_flutter/culqi_flutter.dart';

```

Primero deberá pedir al usuario los datos de su tarjeta mediante un formulario para luego instanciar un objeto de la clase "CCard"

```dart

    CCard card = CCard(
      cardNumber: '4111 1111 1111 1111',
      expirationMonth: 09,
      expirationYear: 20,
      cvv: '123',
      email: 'test@test.com'
    );

```

Recuerda que la clase CCard tiene métodos que te ayudarán a validar los datos antes de enviarlo a la API de Culqi: 

* isCardNumberValid() return bool
* isYearValid() return bool
* isMonthValid() return bool
* isExpirationDateValid() return bool
* isCcvValid() return bool
* isEmailValid() return bool
* getBrand() return int - ejemplo

```dart

    Switch(card.getBrand()){
        case CCard.DINERS_CLUB:
            break;
        case CCard.AMERICAN_EXPRESS:
            break;
        case CCard.MASTER_CARD:
            break;
        case CCard.VISA:
            break;
        default:
            // no se detecta la marca de la tarjeta
            break;
    }

```

Para enviar los datos de la tarjeta hacemos uso del método asíncrono "createToken":

```dart

    createToken(card: card, apiKey: "sk_test_UTCQSGcXW8bCyU59").then((CToken token){
        //su token
        print(token.id);
    }).catchError((error){
        try{
            throw error;
        } on CulqiBadRequestException catch(ex){
            print(ex.cause);
        } on CulqiUnknownException catch(ex){
            //codigo de error del servidor
            print(ex.cause);
        }
    });

```

Si utiliza aync/await su código se vería de la siguiente manera:

```dart

    try{
        CToken token = await createToken(card: card, apiKey: "sk_test_UTCQSGcXW8bCyU59");
        //su token
        print(token.id);
    } on CulqiBadRequestException catch(ex){
        print(ex.cause);
    } on CulqiUnknownException catch(ex){
        //codigo de error del servidor
        print(ex.cause);
    }

```

## LICENCIA

```

MIT License

Copyright (c) 2020 Gucodero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```