# YPay Flutter Plugin

YPay Flutter Plugin позволяет интегрировать встроенные методы YandexPaySDK в ваши проекты для проведения платежей в приложении.

# Требования к подключению

Этот способ интеграции требует настройки [API](https://pay.yandex.ru/docs/ru/custom/back-index). Подробнее о способах интеграции см. [Интеграция](https://pay.yandex.ru/docs/ru/custom/).

[С чего начать интеграцию](https://pay.yandex.ru/docs/ru/quick_start)\
[Схема работы редиректов](https://pay.yandex.ru/docs/ru/custom/mobile/redirect-scheme)

Поддерживаемая версия: **Android 7.0** и выше.\
Поддерживаемая версия **iOS SDK: 14.0** и выше.

# Схема работы 

1. Пользователь нажимает на кнопку оплаты в приложении.
2. Пользователь переходит на экран платежной формы Яндекс Пэй, где отображается информация о заказе и способы оплаты:
    - список банковских карт пользователя;
    - варианты оплаты через систему быстрых платежей (СБП).
3. Пользователь выбирает способ оплаты и нажимает на кнопку подтверждения заказа.
4. Сервис Яндекс Пэй проводит платеж и возвращает результат выполнения операции.

##### Полная оплата
![Полная оплата](https://pay.yandex.ru/docs/docs-assets/yandex-pay/rev/b5d648c87f6598eb20f1e7ba9de29fd3aedebe8e/ru/custom/_assets/android-sdk-bolt-payment-flow.png)

##### Оплата в сплит
![Оплата в сплит](https://pay.yandex.ru/docs/docs-assets/yandex-pay/rev/b5d648c87f6598eb20f1e7ba9de29fd3aedebe8e/ru/custom/_assets/android-sdk-bolt-split-flow.png)


# Начало работы

Следуйте нижеприведённым инструкциям по подключению для корректной интеграции YPay Flutter Plugin в ваше приложение.

#### Подготовка Android

Перед началом интеграции нужно получить и добавить в проект несколько идентификаторов:
- [Merchant ID](https://pay.yandex.ru/docs/ru/console/settings#merchant-id)
- SHA256 Fingerprints
- Client ID (`YANDEX_CLIENT_ID`)
- Android package name (`applicationId`)

1. Получите значение хеша SHA256 Fingerprints с помощью утилиты `keytool`:
    
    ```
    keytool -list -v -alias <your-key-name> -keystore <path-to-production-keystore>
    ```
    
    После ввода команды значение хеша отобразится в блоке `Certificate fingerprints: SHA256`.
    
2. Для регистрации приложения перейдите в сервис [Яндекс OAuth](https://oauth.yandex.ru/client/new).
    
3. В поле **Название вашего сервиса** укажите название, которое будет видно пользователям на экране авторизации.
    
4. В разделе **Платформы приложения** выберите **Android-приложение** и укажите его параметры:
    
    - **Android package name** — уникальное имя приложения из `applicationId` в конфигурационном файле проекта;
    - **SHA256 Fingerprints** — значение хеша SHA256, полученное в пункте 1. **Все буквы в хеше должны быть заглавными.**
5. Убедитесь, что на [Яндекс OAuth](https://oauth.yandex.ru/client/new) у вашего приложения добавлен доступ к Яндекс Пэй. Для этого в блоке **Доступ к данным** в поле **Название доступа** выберите **Оплата через Yandex Pay**.
    
6. Нажмите кнопку **Создать приложение** и скопируйте значение поля **Client ID**.
    
7. На странице [Настройки](https://console.pay.yandex.ru/settings) личного кабинета Яндекс Пэй укажите значения Client ID, SHA256 и Android package name в полях **Client ID**, **SHA256 Fingerprint** и **Android package name** соответственно.
    
Укажите полученный Client ID в сборочном скрипте `build.gradle` в `manifestPlaceholders` в качестве значения `YANDEX_CLIENT_ID`:

```
   android {
     defaultConfig {
       manifestPlaceholders = [
         // Подставьте ваш Client ID
         YANDEX_CLIENT_ID: "12345678901234567890",
       ]
     }
   }
```
---
#### Подготовка iOS

Перед началом интеграции нужно получить и добавить в проект несколько идентификаторов:

- [Merchant ID](https://pay.yandex.ru/docs/ru/console/settings#merchant-id)
- Client ID (`YANDEX_CLIENT_ID`)
- [iOS Appid](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html)

**Получите Client ID**

1. Для регистрации приложения перейдите в сервис [Яндекс OAuth](https://oauth.yandex.ru/client/new).
    
2. В поле **Название вашего сервиса** укажите название, которое будет видно пользователям на экране авторизации.
    
3. В разделе **Платформы приложения** выберите **iOS-приложение** и укажите его параметры:
    
    - **iOS Appid** — точный идентификатор iOS-приложения, например `A1B2C3D4E5.com.domain.application`, который состоит из Prefix и Bundle ID;
    - **iOS AppStore URL** — ссылка на приложение в AppStore.
    
    Примечание
    
    Подробнее про идентификаторы iOS-приложений читайте в [документации Apple](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html).
    
4. Убедитесь, что на [Яндекс OAuth](https://oauth.yandex.ru/client/new) у вашего приложения добавлен доступ к Яндекс Пэй. Для этого в блоке **Доступ к данным** в поле **Название доступа** выберите **Оплата через Yandex Pay**.
    
5. Нажмите кнопку **Создать приложение** и скопируйте значение поля **Client ID**.
    
6. В разделе [Настройки](https://console.pay.yandex.ru/settings) личного кабинета Яндекс Пэй укажите значения Client ID и iOS Appid в полях **Client ID** и **appID для iOS** соответственно.
    

**Настройте Info.plist**

Добавьте в файл `Info.plist` строки:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>primaryyandexloginsdk</string>
    <string>secondaryyandexloginsdk</string>
</array>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>YandexLoginSDK</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>yx$(YANDEX_CLIENT_ID)</string>
        </array>
    </dict>
</array>
```

**Настройте Entitlements**

Сервис авторизации обменивается информацией с приложениями Яндекса через [Universal Links](https://developer.apple.com/ios/universal-links/).

Добавьте следующие строки в `Capability: Associated Domains` или файл `*.entitlements`:

**DEBUG-конфигурация**
```
<key>com.apple.developer.associated-domains</key>
<array>
  <string>applinks:yx$(YANDEX_CLIENT_ID).oauth.yandex.ru</string>
  <string>applinks:$(YANDEX_CLIENT_ID).merchant.applink.pay.yandex.ru</string>
  <string>applinks:$(YANDEX_CLIENT_ID).merchant.applink.sandbox.pay.yandex.ru</string>
</array>
```
**RELEASE-конфигурация**
```
<key>com.apple.developer.associated-domains</key>
<array>
  <string>applinks:yx$(YANDEX_CLIENT_ID).oauth.yandex.ru</string>
  <string>applinks:$(YANDEX_CLIENT_ID).merchant.applink.pay.yandex.ru</string>
</array>
```

# Подключение

Добавьте это в файл pubspec.yaml вашего пакета:

```yaml
dependencies:
  ypay: ^1.0.3
```

# Использование

Для ознакомления доступно example приложение с настройками проекта и двумя видами вызова формы оплаты.

**Добавление импорта:**
```dart
import 'package:ypay/ypay.dart';
``` 

**Создание экземпляра:**
```dart
final ypayPlugin = YPay.instance;
``` 

**Инициализация SDK:**
```dart
  ypayPlugin.init(
    configuration: const Configuration(
      merchantId: 'your merchant id',
      merchantName: 'Demo Merchant',
      merchantUrl: "https://example.ru/",
    ),
  );
``` 

# Вызов платежа:

Для вызова платежа необходимо передать ссылку, предварительно сформированную на сервере в соответствии с документацией API.

**Через контракт**
```dart
  _ypayPlugin.createContract(
    url: '',
    onStatusChange: (contract, result) {
      /// закрыть контракт
      contract.cancel();
      setState(() {
        _paymentResult = result.message ?? 'Unknown';
      });
    },
  );

```

**Через методы**

```dart
ypayPlugin.startPayment(url: 'your payment url');
```

**Подписка на результат платежа:**
```dart
StreamSubscription<String>? _paymentResultStreamSubscription;

final paymentResultStream = ypayPlugin.paymentResultStream();
  _paymentResultStreamSubscription = paymentResultStream.listen((element) {
  log(element);
});

```
**Варианты результата платежа:**
```markdown
"Finished with success" - успешный платеж
"Finished with cancelled event" - отмена платежа
"Finished with domain error" - ошибка платежа
"Finished when contract is null" - ошибка платежа
```

# Частые ошибки

- не реализована поддержка AppLinks в приложении;
- не установлена theme для Application и для Aсtivity в AndroidManifest.xml;
- launchMode отличается от android:launchMode="singleTask";
- в качестве Theme в android/app/src/main/res/values/styles.xml необходимо использовать Theme.MaterialComponents или Theme.AppCompat;
- MainActivity должен наследоваться от FlutterFragmentActivity() в MainActivity.kt.
