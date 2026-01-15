import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'moncash_utils.dart';
import 'response_model.dart';

/// Widget de paiement MonCash
///
/// Affiche une WebView pour effectuer un paiement via la passerelle MonCash
class MonCashPayment extends StatefulWidget {
  /// Montant à payer
  final double amount;

  /// ID de commande personnalisé (généré automatiquement si non fourni)
  final String? orderId;

  /// Client ID MonCash
  final String clientId;

  /// Client Secret MonCash
  final String clientSecret;

  /// Widget de chargement personnalisé
  final Widget? loadingWidget;

  /// Mode staging (true) ou production (false)
  final bool isStaging;

  const MonCashPayment({
    required this.amount,
    this.orderId,
    required this.clientId,
    required this.clientSecret,
    this.loadingWidget,
    this.isStaging = false,
    super.key,
  });

  @override
  State<MonCashPayment> createState() => _MonCashPaymentState();
}

class _MonCashPaymentState extends State<MonCashPayment> {
  late MonCash monCash;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool isLoading = true;
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  String? paymentUrl;

  @override
  void initState() {
    super.initState();

    monCash = MonCash(
      clientId: widget.clientId,
      clientSecret: widget.clientSecret,
      staging: widget.isStaging,
    );

    if (widget.orderId != null) {
      orderId = widget.orderId!;
    }

    monCash.getWebviewUrl(amount: widget.amount.toString(), orderId: orderId).then((
      value,
    ) {
      if (value != null) {
        setState(() => paymentUrl = value);
      } else {
        // Erreur lors de la génération du token
        Navigator.pop(
          context,
          PaymentResponse(
            status: paymentStatus.failed,
            message:
                "Erreur lors de la génération du token, veuillez réessayer plus tard.",
            orderId: orderId,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(
            context,
            PaymentResponse(
              status: paymentStatus.failed,
              message: "Paiement annulé par l'utilisateur.",
              orderId: orderId,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paiement MonCash'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(
                context,
                PaymentResponse(
                  status: paymentStatus.failed,
                  message: "Paiement annulé par l'utilisateur.",
                  orderId: orderId,
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            if (paymentUrl != null)
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(paymentUrl!)),
                initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) {
                  setState(() => isLoading = false);
                  log(url.toString());

                  if (url.toString().contains('transactionId')) {
                    final transactionId = Uri.parse(
                      url.toString(),
                    ).queryParameters['transactionId'];
                    log('transactionId: $transactionId');
                    Navigator.pop(
                      context,
                      PaymentResponse(
                        transactionId: transactionId,
                        orderId: orderId,
                        status: paymentStatus.success,
                        message: "Paiement réussi: $transactionId",
                      ),
                    );
                  } else if (url.toString().contains('error')) {
                    final error =
                        Uri.parse(url.toString()).queryParameters['error'] ??
                        'Erreur, veuillez réessayer plus tard';
                    log('error: $error');
                    Navigator.pop(
                      context,
                      PaymentResponse(
                        status: paymentStatus.failed,
                        message: error,
                        orderId: orderId,
                      ),
                    );
                  }
                },
              ),
            if (paymentUrl == null || isLoading)
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child:
                      widget.loadingWidget ?? const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
