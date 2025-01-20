import 'dart:async';

import 'package:flutter/services.dart';

import '../ypay.dart';

/// Обработка результата оплаты
typedef YPayTransactionCallback = void Function(YPayContract contract, YPayResult result);

/// Контракт оплаты для работы с YPay
class YPayContract {
  /// Конструктор контракта
  YPayContract({
    required this.url,
    required this.ypay,
    required this.onStatusChange,
  });

  /// Создает контракт, ссылаясь на [YPay.instance]
  factory YPayContract.create({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) {
    return YPayContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
    )..init();
  }

  /// Ссылка на оплату
  final String url;

  /// YPay API
  final YPay ypay;

  /// Обработка результата оплаты
  ///
  /// При получении статуса вызывать метод [cancel]
  final YPayTransactionCallback onStatusChange;

  YPayResult? _currentResult;

  /// Текущий результат оплаты
  YPayResult? get currentResult => _currentResult;

  /// Ссылка на подписку на поток результатов оплаты с помощью YPay
  ///
  /// StreamSubscription - это объект, который представляет собой ссылку на
  /// фактический поток данных. Это нужно, чтобы можно было отменить
  /// подписку, когда больше не нужна.
  /// Без этой ссылки поток данных будет продолжать
  /// поступать даже после того, как объект,
  /// который его подписался, будет уничтожен.
  ///
  /// На данной ссылке мы будем вызывать метод cancel(), чтобы отменить
  /// подписку, когда мы больше не хотим получать данные о статусе оплаты.
  StreamSubscription<String>? _paymentResultStreamSubscription;

  /// Инициализация подписки на поток результатов оплаты с помощью YPay
  ///
  /// Это метод инициализирует подписку на поток данных об оплате с помощью
  /// YPay. Он создает поток данных, который будет передавать сообщения об
  /// статусе оплаты. Затем, он подписывается на этот поток данных, и каждый
  /// раз, когда он получает новое сообщение, вызывает функцию onStatusChange,
  /// передавая ей текущий объект YPayContract и текущий результат оплаты.
  /// Также, он сохраняет ссылку на текущую подписку, чтобы потом можно было
  /// ее отменить.
  void init() {
    try {
      final paymentResultStream = ypay.paymentResultStream();
      _paymentResultStreamSubscription = paymentResultStream.listen((element) {
        _currentResult = YPayResult.fromMessage(element);
        onStatusChange(this, currentResult!);
      });
    } on PlatformException {
      _currentResult = YPayResult.failed;
      onStatusChange(this, currentResult!);
    }
  }

  /// Запуск оплаты
  void pay() {
    ypay.startPayment(url: url);
  }

  /// Закрыть контракт
  void cancel() {
    _paymentResultStreamSubscription?.cancel();
  }
}

/// Результат оплаты
class YPayResult {
  /// Конструктор
  const YPayResult({
    required this.message,
    required this.status,
  });

  /// Чтение результата оплаты на основе ответа
  factory YPayResult.fromMessage(String? message) {
    YPayStatus status = YPayStatus.none;
    if (message == null) {
      status = YPayStatus.none;
    } else if (message.contains('success')) {
      status = YPayStatus.success;
    } else if (message.contains('cancelled')) {
      status = YPayStatus.cancelled;
    } else if (message.contains('error')) {
      status = YPayStatus.failure;
    }
    return YPayResult(
      message: message,
      status: status,
    );
  }

  /// Сообщение
  final String? message;

  /// Статус
  final YPayStatus status;

  /// Результат [YPayStatus.failure]
  static const YPayResult failed = YPayResult(
    message: 'Finished with domain error',
    status: YPayStatus.failure,
  );

  /// Результат [YPayStatus.none]
  static const YPayResult none = YPayResult(
    message: 'Finished when contract is null',
    status: YPayStatus.none,
  );

  /// Результат [YPayStatus.success]
  static const YPayResult success = YPayResult(
    message: 'Finished with success',
    status: YPayStatus.success,
  );

  /// Результат [YPayStatus.cancelled]
  static const YPayResult cancelled = YPayResult(
    message: 'Finished with cancelled event',
    status: YPayStatus.cancelled,
  );
}

/// Статус оплаты
enum YPayStatus {
  /// 'Finished when contract is null'
  none,

  /// 'Finished with success'
  success,

  /// 'Finished with cancelled event'
  cancelled,

  /// 'Finished with domain error'
  failure
}
