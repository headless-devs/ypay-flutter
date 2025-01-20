import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ypay/ypay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YandexPay demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'YandexPay demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _paymentResult = 'Unknown';
  final _ypayPlugin = YPay.instance;

  void startPayment() {
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
  }

  @override
  void initState() {
    try {
      _ypayPlugin.init(
          configuration: const Configuration(
        merchantId: 'merchantId',
        merchantName: 'merchantName',
        merchantUrl: "merchantUrl",
      ));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: startPayment,
              child: const Text('Start Payment'),
            ),
            const SizedBox(height: 20),
            Text(_paymentResult),
          ],
        ),
      ),
    );
  }
}
