import 'package:example/key.dart';
import 'package:flutter/material.dart';
import 'package:moncash_flutter/moncash_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moncash Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MonCashPayment(
      isStaging: true,
      amount: 100,
      clientId: clientId,
      clientSecret: clientSecret,
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Text("Redirecting to payment gateway..."),
        ],
      ),
    );
  }
}
