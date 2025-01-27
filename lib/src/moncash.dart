import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'moncash_utils.dart';
import 'response_model.dart';

class MonCashPayment extends StatefulWidget {
  final double amount;
  final String? orderId;
  final String clientId;
  final String clientSecret;
  final Widget? loadingWidget;
  final bool isStaging;

  const MonCashPayment({
    required this.amount,
    this.orderId,
    required this.clientId,
    required this.clientSecret,
    this.loadingWidget,
    this.isStaging = false,
    Key? key,
  }) : super(key: key);

  @override
  _MonCashPaymentState createState() => _MonCashPaymentState();
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

    monCash.getWebviewUrl(amount: widget.amount.toString(), orderId: orderId).then((value) {
      int count = 0;
      if (value != null) {
        setState(() => paymentUrl = value);
      } else {
        Navigator.popUntil(context,(route){
          PaymentResponse(
            status: paymentStatus.failed,
            message: "Error in generating token, Please try again later.",
          );
          count++;
          return count == 2;
        }

        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int count = 0;
        Navigator.popUntil(
          context,(route){
          PaymentResponse(
            status: paymentStatus.failed,
            message: "Payment cancelled by user.",
            orderId: orderId,
          );
          count++;
          return count == 2;
        }

        );
        return Future.value(false); // Empêche la fermeture automatique
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (paymentUrl != null)
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(paymentUrl!)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) {
                  setState(() => isLoading = false);
                  log(url.toString());

                  if (url.toString().contains('transactionId')) {
                    final transactionId = Uri.parse(url.toString()).queryParameters['transactionId'];
                    log('transactionId: $transactionId');
                    int count = 0;
                    Navigator.popUntil(context,(route){
                      PaymentResponse(
                        transanctionId: transactionId,
                        orderId: orderId,
                        status: paymentStatus.success,
                        message: "Payment Successful $transactionId",
                      );
                      count++;
                      return count == 2;
                    }

                    );
                  } else if (url.toString().contains('error')) {
                    final error = Uri.parse(url.toString()).queryParameters['error'] ?? 'Error, Please Try Again Later';
                    log('error: $error');
                    int count = 0;
                    Navigator.popUntil(context,(route){
                      PaymentResponse(
                        status: paymentStatus.failed,
                        message: error,
                        orderId: orderId,
                      );
                      count++;
                      return count == 2;
                    }
                    );
                  }
                },
              ),
            if (paymentUrl == null || isLoading)
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: widget.loadingWidget ?? const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
