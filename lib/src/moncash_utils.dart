import 'dart:developer';

import 'package:dio/dio.dart';

class MonCash {
  final String clientId;
  final String clientSecret;

  final bool staging;
  MonCash({
    this.staging = false,
    required this.clientId,
    required this.clientSecret,
  });

  // String get authHeader => 'Basic ' + clientId + ':' + clientSecret;
  String get hostRestApi => staging
      ? "sandbox.moncashbutton.digicelgroup.com/Api"
      : "moncashbutton.digicelgroup.com/Api";

  String get gatewayBaseUrl => staging
      ? "https://sandbox.moncashbutton.digicelgroup.com/Moncash-middleware"
      : "https://moncashbutton.digicelgroup.com/Moncash-middleware";

  String get oauthUrl {
    return "https://$clientId:$clientSecret@$hostRestApi/oauth/token";
  }

  String get paymentUrl {
    return "https://$hostRestApi/v1/CreatePayment";
  }

  String get paymentRedirectUrl {
    return "$gatewayBaseUrl/Payment/Redirect?token=";
  }

  String get retrieveTransactionPaymentUrl {
    return "https://$hostRestApi/v1/RetrieveTransactionPayment";
  }

  String get retrieveOrderPaymentUrl {
    return "https://$hostRestApi/v1/RetrieveOrderPayment";
  }

  Future<String?> getWebviewUrl({
    required String amount,
    required String orderId,
  }) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await generatePaymentUrl(oAuth, amount: amount, orderId: orderId);
    } else {
      return null;
    }
  }

  /// Génère un token OAuth pour l'authentification MonCash
  ///
  /// Retourne le token d'accès en cas de succès, null en cas d'échec
  Future<String?> generateOauthToken() async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      var resp = await dio.post(
        oauthUrl,
        data: {"scope": "read", "grant_type": "client_credentials"},
      );
      if (resp.data["access_token"] != null) {
        log('OAuth token généré avec succès');
        return resp.data["access_token"];
      } else {
        log('Erreur: access_token non trouvé dans la réponse');
        return null;
      }
    } on DioException catch (e) {
      log(
        'Erreur DioException lors de la génération du token OAuth: ${e.response?.statusCode} - ${e.message}',
      );
      return null;
    } catch (e) {
      log('Erreur inattendue lors de la génération du token OAuth: $e');
      return null;
    }
  }

  /// Génère l'URL de paiement pour afficher dans la WebView
  ///
  /// [authToken] Token OAuth obtenu via [generateOauthToken]
  /// [amount] Montant de la transaction
  /// [orderId] Identifiant unique de la commande
  ///
  /// Retourne l'URL de paiement en cas de succès, null en cas d'échec
  Future<String?> generatePaymentUrl(
    String authToken, {
    required String amount,
    required String orderId,
  }) async {
    String url = paymentUrl;
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      var resp = await dio.post(
        url,
        data: {"amount": amount, "orderId": orderId},
      );

      if (resp.data["payment_token"]?["token"] != null) {
        var payToken = resp.data["payment_token"]["token"];
        var payUrl = paymentRedirectUrl + payToken;
        log('URL de paiement générée avec succès');
        return payUrl;
      } else {
        log('Erreur: payment_token non trouvé dans la réponse');
        return null;
      }
    } on DioException catch (e) {
      log(
        'Erreur DioException lors de la génération de l\'URL de paiement: ${e.response?.statusCode} - ${e.message}',
      );
      return null;
    } catch (e) {
      log('Erreur inattendue lors de la génération de l\'URL de paiement: $e');
      return null;
    }
  }

  /// Récupère les détails d'une transaction via son ID
  ///
  /// [transactionId] ID de la transaction à récupérer
  /// Retourne les données de la transaction ou null en cas d'échec
  retrieveTransaction(String transactionId) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await retrieveTransactionPayment(transactionId, oAuth);
    } else {
      return null;
    }
  }

  /// Récupère les détails d'une commande via son ID
  ///
  /// [orderId] ID de la commande à récupérer
  /// Retourne les données de la commande ou null en cas d'échec
  retrieveOrder(String orderId) async {
    String? oAuth = await generateOauthToken();
    if (oAuth != null) {
      return await retrieveOrderPayment(orderId, oAuth);
    } else {
      return null;
    }
  }

  /// Récupère les détails d'une transaction depuis l'API MonCash
  ///
  /// [transactionId] ID de la transaction
  /// [oauth] Token OAuth pour l'authentification
  Future retrieveTransactionPayment(String transactionId, String oauth) async {
    String url = retrieveTransactionPaymentUrl;
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $oauth",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      var resp = await dio.post(url, data: {"transactionId": transactionId});
      log('Détails de la transaction récupérés avec succès');
      return resp.data;
    } on DioException catch (e) {
      log(
        'Erreur DioException lors de la récupération de la transaction: ${e.response?.statusCode} - ${e.message}',
      );
      return null;
    } catch (e) {
      log('Erreur inattendue lors de la récupération de la transaction: $e');
      return null;
    }
  }

  /// Récupère les détails d'une commande depuis l'API MonCash
  ///
  /// [orderId] ID de la commande
  /// [oauth] Token OAuth pour l'authentification
  retrieveOrderPayment(String orderId, String oauth) async {
    String url = retrieveOrderPaymentUrl;
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $oauth",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      var resp = await dio.post(url, data: {"orderId": orderId});
      log('Détails de la commande récupérés avec succès');
      return resp.data;
    } on DioException catch (e) {
      log(
        'Erreur DioException lors de la récupération de la commande: ${e.response?.statusCode} - ${e.message}',
      );
      return null;
    } catch (e) {
      log('Erreur inattendue lors de la récupération de la commande: $e');
      return null;
    }
  }
}
