/// Statut du paiement MonCash
///
/// Utilisé pour indiquer si un paiement a réussi ou échoué.
///
/// Example:
/// ```dart
/// if (response.status == paymentStatus.success) {
///   print('Payment successful!');
/// }
/// ```
enum paymentStatus {
  /// Le paiement a été complété avec succès
  success,

  /// Le paiement a échoué ou a été annulé
  failed,
}

/// Modèle de réponse pour les transactions de paiement MonCash
///
/// Cette classe représente la réponse retournée par le widget [MonCashPayment]
/// après qu'un utilisateur ait complété ou annulé un paiement.
///
/// Example d'utilisation:
/// ```dart
/// PaymentResponse? response = await Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => MonCashPayment(
///       amount: 100.0,
///       clientId: 'your_client_id',
///       clientSecret: 'your_client_secret',
///     ),
///   ),
/// );
///
/// if (response != null && response.status == paymentStatus.success) {
///   print('Transaction ID: ${response.transactionId}');
///   print('Order ID: ${response.orderId}');
/// }
/// ```
class PaymentResponse {
  /// ID de transaction unique retourné par MonCash
  ///
  /// Cet ID peut être utilisé pour récupérer les détails de la transaction
  /// via [MonCash.retrieveTransaction].
  String? transactionId;

  /// Propriété dépréciée - Utilisez [transactionId] à la place
  ///
  /// Cette propriété existe pour la compatibilité descendante et sera
  /// supprimée dans une version future.
  @Deprecated(
    'Utilisez transactionId à la place. Cette propriété sera supprimée dans une version future.',
  )
  String? get transanctionId => transactionId;

  /// Définit l'ID de transaction (pour compatibilité descendante)
  @Deprecated(
    'Utilisez le paramètre transactionId dans le constructeur à la place.',
  )
  set transanctionId(String? value) => transactionId = value;

  /// Statut du paiement
  ///
  /// Soit [paymentStatus.success] pour un paiement réussi,
  /// soit [paymentStatus.failed] pour un paiement échoué ou annulé.
  final paymentStatus status;

  /// Message descriptif du résultat de la transaction
  ///
  /// Contient des détails sur le succès ou l'échec du paiement.
  /// En cas d'erreur, ce message peut contenir des informations utiles
  /// pour le débogage.
  final String? message;

  /// ID de commande associé à la transaction
  ///
  /// C'est l'identifiant unique de commande que vous avez fourni
  /// (ou qui a été généré automatiquement) lors de l'initiation du paiement.
  final String? orderId;

  /// Crée une nouvelle instance de [PaymentResponse]
  ///
  /// [status] est requis et indique si le paiement a réussi ou échoué.
  /// [message] est requis et contient des détails sur le résultat.
  /// [transactionId] et [orderId] sont optionnels.
  PaymentResponse({
    this.transactionId,
    required this.status,
    required this.message,
    this.orderId,
  });
}
