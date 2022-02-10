

<p align="center">
<h1>
Flutter Moncash Payment Plugin
</h1>

</p>
<p align="center">
	<a href="https://pub.dev/packages/infinite_scroll_pagination" rel="noopener" target="_blank"><img src="https://img.shields.io/pub/v/infinite_scroll_pagination.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/EdsonBueno/infinite_scroll_pagination/actions" rel="noopener" target="_blank"><img src="https://github.com/EdsonBueno/infinite_scroll_pagination/workflows/build/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://codecov.io/gh/EdsonBueno/infinite_scroll_pagination" rel="noopener" target="_blank"><img src="https://codecov.io/gh/EdsonBueno/infinite_scroll_pagination/branch/master/graph/badge.svg?token=B0CT995PHU" alt="Code Coverage Badge"></a>
	<a href="https://gitter.im/infinite_scroll_pagination/community" rel="noopener" target="_blank"><img src="https://badges.gitter.im/infinite_scroll_pagination/community.svg" alt="Gitter Badge"></a>
	<a href="https://github.com/tenhobi/effective_dart" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg" alt="Effective Dart Badge"></a>
	<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
	<a href="https://github.com/EdsonBueno/infinite_scroll_pagination" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

---

![image](https://www.digicelgroup.com/etc/designs/haiti-en-moncash/_jcr_content/global/headerLogo.asset.spool/MonCash_Logo-180-90-white.png)

A flutter plugin for moncash integration for Android and Ios.

#### If you use this library in your app, please let me know and I'll add it to the list.


<p align="center">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/1.jpg">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/2.jpg">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/3.jpg">
</p>


### Installing
Add this in pubspec.yaml
```
  moncash_flutter: 
```
### Using
```
import 'package:moncash_flutter/moncash_flutter.dart';
```

```
   WidgetsBinding.instance!.addPostFrameCallback((_) async {
      PaymentResponse? data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonCashPayment(
                  isStaging: true,
                  amount: Amount,
                  clientId: "Id",
                  clientSecret: clientSecret,
                  loadingWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      LoadingScreen(color: Colors.white),
                      Text("Redirecting to payment gateway..."),
                    ],
                  ),
                )),
      );
      if (data != null && data.status == paymentStatus.success && data.transanctionId != null) {
        setState(() {
          paymentSuccess = true;
        });
        placeOrder(transanctionId: data.transanctionId, orderId: data.orderId);
      } else {
        if (data == null) {
          showErrorDialog(context, "ERROR: Payment Failed");
        } else {
          showErrorDialog(context, "ERROR: ${data.message}");
        }
        setState(() {
          isLoading = false;
          paymentSuccess = false;
        });
      }
    });

If payment is successful PaymentResponse  will contain the transanctionId from moncash.
