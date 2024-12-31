import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'moncash_utils.dart';
import 'response_model.dart';

class MonCashPayment extends StatefulWidget {
  final double amount;
  final String? orderId;
  final String clientId;
  final String clientSecret;
  final Widget? loadingWidget;
  final bool isStaging;
  const MonCashPayment(
      {required this.amount,
      this.orderId,
      required this.clientId,
      required this.clientSecret,
      this.loadingWidget,
      this.isStaging = false,
      Key? key})
      : super(key: key);

  @override
  _MonCashPaymentState createState() => _MonCashPaymentState();
}

class _MonCashPaymentState extends State<MonCashPayment> {
  late final WebViewController _webViewController;
  String paymentUrl = "";
  bool _isLoading = true;
  bool _hasError = false;
  late MonCash monCash;
  bool isLoading = true;
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  @override
  void initState() {
    monCash = MonCash(clientId: widget.clientId, clientSecret: widget.clientSecret, staging: widget.isStaging);
    if (widget.orderId != null) {
      orderId = widget.orderId!;
    }
    monCash.getWebviewUrl(amount: widget.amount.toString(), orderId: orderId).then((value) {
      if (value != null) {
        setState(() => paymentUrl = value);
      } else {
        Navigator.pop(
            context,
            PaymentResponse(
                status: paymentStatus.failed, message: "Error in generating token, Please try again later.."));
      }
    });

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://' +paymentUrl));
    print(paymentUrl);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (paymentUrl != "")
            WebViewWidget(controller: _webViewController),
          if (paymentUrl == "" || isLoading)
            Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(child: widget.loadingWidget ?? const CircularProgressIndicator()))
        ],
      ),
    );
  }
}
