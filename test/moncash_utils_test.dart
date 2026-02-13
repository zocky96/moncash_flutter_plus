import 'package:flutter_test/flutter_test.dart';
import 'package:moncash_flutter/src/moncash_utils.dart';

void main() {
  group('MonCash', () {
    late MonCash monCashStaging;
    late MonCash monCashProduction;

    setUp(() {
      monCashStaging = MonCash(
        clientId: 'test_client_id',
        clientSecret: 'test_client_secret',
        staging: true,
      );

      monCashProduction = MonCash(
        clientId: 'prod_client_id',
        clientSecret: 'prod_client_secret',
        staging: false,
      );
    });

    group('Constructor and Properties', () {
      test('should create instance with staging mode', () {
        expect(monCashStaging.clientId, 'test_client_id');
        expect(monCashStaging.clientSecret, 'test_client_secret');
        expect(monCashStaging.staging, true);
      });

      test('should create instance with production mode', () {
        expect(monCashProduction.clientId, 'prod_client_id');
        expect(monCashProduction.clientSecret, 'prod_client_secret');
        expect(monCashProduction.staging, false);
      });

      test('should default to production mode when staging not specified', () {
        final monCash = MonCash(
          clientId: 'test_id',
          clientSecret: 'test_secret',
        );
        expect(monCash.staging, false);
      });
    });

    group('URL Getters - Staging', () {
      test('should return correct staging hostRestApi', () {
        expect(
          monCashStaging.hostRestApi,
          'sandbox.moncashbutton.digicelgroup.com/Api',
        );
      });

      test('should return correct staging gatewayBaseUrl', () {
        expect(
          monCashStaging.gatewayBaseUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware',
        );
      });

      test('should return correct staging oauthUrl', () {
        expect(
          monCashStaging.oauthUrl,
          'https://test_client_id:test_client_secret@sandbox.moncashbutton.digicelgroup.com/Api/oauth/token',
        );
      });

      test('should return correct staging paymentUrl', () {
        expect(
          monCashStaging.paymentUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Api/v1/CreatePayment',
        );
      });

      test('should return correct staging paymentRedirectUrl', () {
        expect(
          monCashStaging.paymentRedirectUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware/Payment/Redirect?token=',
        );
      });

      test('should return correct staging retrieveTransactionPaymentUrl', () {
        expect(
          monCashStaging.retrieveTransactionPaymentUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Api/v1/RetrieveTransactionPayment',
        );
      });

      test('should return correct staging retrieveOrderPaymentUrl', () {
        expect(
          monCashStaging.retrieveOrderPaymentUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Api/v1/RetrieveOrderPayment',
        );
      });
    });

    group('URL Getters - Production', () {
      test('should return correct production hostRestApi', () {
        expect(
          monCashProduction.hostRestApi,
          'moncashbutton.digicelgroup.com/Api',
        );
      });

      test('should return correct production gatewayBaseUrl', () {
        expect(
          monCashProduction.gatewayBaseUrl,
          'https://moncashbutton.digicelgroup.com/Moncash-middleware',
        );
      });

      test('should return correct production oauthUrl', () {
        expect(
          monCashProduction.oauthUrl,
          'https://prod_client_id:prod_client_secret@moncashbutton.digicelgroup.com/Api/oauth/token',
        );
      });

      test('should return correct production paymentUrl', () {
        expect(
          monCashProduction.paymentUrl,
          'https://moncashbutton.digicelgroup.com/Api/v1/CreatePayment',
        );
      });

      test('should return correct production paymentRedirectUrl', () {
        expect(
          monCashProduction.paymentRedirectUrl,
          'https://moncashbutton.digicelgroup.com/Moncash-middleware/Payment/Redirect?token=',
        );
      });
    });

    group('URL Construction', () {
      test('should properly encode credentials in oauthUrl', () {
        final monCash = MonCash(
          clientId: 'client@123',
          clientSecret: 'secret#456',
          staging: true,
        );

        expect(monCash.oauthUrl, contains('client@123:secret#456@'));
      });

      test('should build correct payment redirect URL', () {
        const token = 'test_token_12345';
        final expectedUrl = '${monCashStaging.paymentRedirectUrl}$token';

        expect(
          expectedUrl,
          'https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware/Payment/Redirect?token=test_token_12345',
        );
      });
    });

    // Note: Integration tests for API calls (generateOauthToken, generatePaymentUrl, etc.)
    // would require mocking HTTP requests and are better suited for integration tests
    // or would need a mock HTTP client. These are covered in the integration test suite.
  });
}
