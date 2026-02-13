

<p align="center">
<h1>
Flutter Moncash Payment Plugin
</h1>

</p>

<p align="center">
	<a href="https://github.com/zocky96/moncash_flutter_plus" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
	<a href="https://opensource.org/licenses/AGPL-3.0" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-AGPL--3.0-purple.svg" alt="License Badge"></a>
	<img src="https://img.shields.io/badge/version-0.0.4-blue.svg" alt="Version Badge">
</p>

---

![image](https://www.digicelgroup.com/etc/designs/haiti-en-moncash/_jcr_content/global/headerLogo.asset.spool/MonCash_Logo-180-90-white.png)

A Flutter plugin for MonCash payment integration for Android and iOS. This is an updated fork with Flutter v2 embedding support.

#### If you use this library in your app, please let me know and I'll add it to the list.


<p align="center">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/1.jpg">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/2.jpg">
<img height="400" alt="demoApp" src="https://raw.githubusercontent.com/gauravmehta13/moncash_flutter/master/screenshots/3.jpg">
</p>


### Installing
Add this to your `pubspec.yaml`:
```yaml
dependencies:
  moncash_flutter:
    git:
      url: https://github.com/zocky96/moncash_flutter_plus.git
```

Then run:
```bash
flutter pub get
```
### Using
```dart
import 'package:moncash_flutter/moncash_flutter.dart';
```

```dart
   WidgetsBinding.instance.addPostFrameCallback((_) async {
      PaymentResponse? data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonCashPayment(
                  isStaging: true,
                  amount: 100.0,
                  clientId: "Your Client ID",
                  clientSecret: "Your Client Secret",
                  loadingWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text("Redirection vers la passerelle de paiement..."),
                    ],
                  ),
                )),
      );
      
      if (data != null && data.status == paymentStatus.success && data.transactionId != null) {
        setState(() {
          paymentSuccess = true;
        });
        placeOrder(transactionId: data.transactionId, orderId: data.orderId);
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
```

If payment is successful, `PaymentResponse` will contain the `transactionId` from MonCash.

### Migration Guide (v0.0.3 → v0.0.4)

#### Breaking Changes

1. **Flutter Version Requirement**: This version requires Flutter 3.12+ for `PopScope` support.

2. **Property Renaming**: `transanctionId` → `transactionId`
   ```dart
   // ❌ Old way (still works but deprecated)
   String? id = paymentResponse.transanctionId;
   
   // ✅ New way
   String? id = paymentResponse.transactionId;
   ```

3. **Method Renaming**: `retrieveTransanction()` → `retrieveTransaction()`
   ```dart
   // ❌ Old way (no longer available)
   await monCash.retrieveTransanction(transactionId);
   
   // ✅ New way
   await monCash.retrieveTransaction(transactionId);
   ```

### What's Fixed in v0.0.4

- **CRITICAL**: Fixed navigation bug where `PaymentResponse` was never properly returned
- Updated to use modern Flutter APIs (`PopScope`, `InAppWebViewSettings`)
- Fixed `DioError` → `DioException` for Dio 5.x compatibility
- Added proper timeout handling (30s) for all HTTP requests
- Improved error messages and logging
- Added comprehensive code documentation

