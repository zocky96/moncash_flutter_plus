import 'package:flutter_test/flutter_test.dart';
import 'package:moncash_flutter/moncash_flutter.dart';

void main() {
  group('paymentStatus', () {
    test('should have success status', () {
      expect(paymentStatus.success, isNotNull);
    });

    test('should have failed status', () {
      expect(paymentStatus.failed, isNotNull);
    });

    test('should have exactly 2 values', () {
      expect(paymentStatus.values.length, 2);
    });
  });

  group('PaymentResponse', () {
    test('should create instance with required parameters', () {
      final response = PaymentResponse(
        status: paymentStatus.success,
        message: 'Payment successful',
      );

      expect(response.status, paymentStatus.success);
      expect(response.message, 'Payment successful');
      expect(response.transactionId, isNull);
      expect(response.orderId, isNull);
    });

    test('should create instance with all parameters', () {
      final response = PaymentResponse(
        transactionId: 'txn_123456',
        status: paymentStatus.success,
        message: 'Payment successful',
        orderId: 'order_789',
      );

      expect(response.transactionId, 'txn_123456');
      expect(response.status, paymentStatus.success);
      expect(response.message, 'Payment successful');
      expect(response.orderId, 'order_789');
    });

    test('should create failed payment response', () {
      final response = PaymentResponse(
        status: paymentStatus.failed,
        message: 'Payment cancelled',
        orderId: 'order_123',
      );

      expect(response.status, paymentStatus.failed);
      expect(response.message, 'Payment cancelled');
      expect(response.transactionId, isNull);
      expect(response.orderId, 'order_123');
    });

    group('Deprecated transanctionId', () {
      test('should work with deprecated getter', () {
        final response = PaymentResponse(
          transactionId: 'txn_abc',
          status: paymentStatus.success,
          message: 'Success',
        );

        // ignore: deprecated_member_use_from_same_package
        expect(response.transanctionId, 'txn_abc');
      });

      test('should work with deprecated setter', () {
        final response = PaymentResponse(
          status: paymentStatus.success,
          message: 'Success',
        );

        // ignore: deprecated_member_use_from_same_package
        response.transanctionId = 'txn_xyz';

        expect(response.transactionId, 'txn_xyz');
        // ignore: deprecated_member_use_from_same_package
        expect(response.transanctionId, 'txn_xyz');
      });

      test('deprecated getter should return same value as transactionId', () {
        final response = PaymentResponse(
          transactionId: 'txn_test',
          status: paymentStatus.success,
          message: 'Test',
        );

        // ignore: deprecated_member_use_from_same_package
        expect(response.transanctionId, equals(response.transactionId));
      });
    });

    test('should handle null transactionId', () {
      final response = PaymentResponse(
        status: paymentStatus.failed,
        message: 'Failed',
      );

      expect(response.transactionId, isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(response.transanctionId, isNull);
    });

    test('should handle null orderId', () {
      final response = PaymentResponse(
        transactionId: 'txn_123',
        status: paymentStatus.success,
        message: 'Success',
      );

      expect(response.orderId, isNull);
    });
  });
}
