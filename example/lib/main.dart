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
      theme: ThemeData(primarySwatch: Colors.blue),
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
  bool isLoading = false;
  bool paymentSuccess = false;

  void initiatePayment() async {
    setState(() => isLoading = true);

    PaymentResponse? data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonCashPayment(
          isStaging: true,
          amount: 100.0,
          clientId: "YOUR_CLIENT_ID", // Remplacer par votre vrai Client ID
          clientSecret:
              "YOUR_CLIENT_SECRET", // Remplacer par votre vrai Client Secret
          loadingWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Redirection vers la passerelle de paiement..."),
            ],
          ),
        ),
      ),
    );

    setState(() => isLoading = false);

    if (data != null &&
        data.status == paymentStatus.success &&
        data.transactionId != null) {
      setState(() => paymentSuccess = true);

      // ignore: avoid_print
      print(
        "Paiement réussi! Transaction ID: ${data.transactionId}, Order ID: ${data.orderId}",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Paiement réussi! ID: ${data.transactionId}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Paiement échoué
      final errorMessage = data?.message ?? "Erreur inconnue";

      // ignore: avoid_print
      print("Paiement échoué: $errorMessage");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Paiement échoué: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MonCash Payment Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Démonstration de paiement MonCash',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (paymentSuccess)
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isLoading ? null : initiatePayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Payer 100 HTG', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
