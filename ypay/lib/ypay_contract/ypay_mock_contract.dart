import '../ypay.dart';

/// Mock YPay contract
class YPayMockContract extends YPayContract {
  /// Конструктор контракта, с ожидаемым результатом
  YPayMockContract({
    required super.url,
    required super.ypay,
    required super.onStatusChange,
    required this.result,
  });

  /// Создает контракт с ожидаемым результатом, ссылаясь на [YPay.instance]
  factory YPayMockContract.create({
    required String url,
    required YPayTransactionCallback onStatusChange,
    required YPayResult? result,
  }) {
    return YPayMockContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
      result: result,
    );
  }

  /// Создает контракт с ожидаемым результатом [YPayStatus.success]
  factory YPayMockContract.createSuccess({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) {
    return YPayMockContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
      result: YPayResult.success,
    );
  }

  /// Создает контракт с ожидаемым результатом [YPayStatus.failed]
  factory YPayMockContract.createFailed({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) {
    return YPayMockContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
      result: YPayResult.failed,
    );
  }

  /// Создает контракт с ожидаемым результатом [YPayStatus.none]
  factory YPayMockContract.createNone({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) {
    return YPayMockContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
      result: YPayResult.none,
    );
  }

  /// Создает контракт без результата
  factory YPayMockContract.createEmpty({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) {
    return YPayMockContract(
      url: url,
      ypay: YPay.instance,
      onStatusChange: onStatusChange,
      result: null,
    );
  }

  /// Ожидаемый результат
  final YPayResult? result;

  @override
  void pay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (result == null) {
        return;
      }
      onStatusChange(this, result!);
    });
  }
}
