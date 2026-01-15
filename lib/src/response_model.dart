/// Statut du paiement MonCash
enum paymentStatus {
  /// Paiement réussi
  success,

  /// Paiement échoué
  failed,
}

/// Modèle de réponse pour les transactions de paiement MonCash
class PaymentResponse {
  /// ID de transaction unique retourné par MonCash
  String? transactionId;

  /// Propriété dépréciée - Utilisez [transactionId] à la place
  @Deprecated(
    'Utilisez transactionId à la place. Cette propriété sera supprimée dans une version future.',
  )
  String? get transanctionId => transactionId;

  /// Définit l'ID de transaction (pour compatibilité descendante)
  @Deprecated(
    'Utilisez le paramètre transactionId dans le constructeur à la place.',
  )
  set transanctionId(String? value) => transactionId = value;

  /// Statut du paiement (success ou failed)
  final paymentStatus status;

  /// Message descriptif du résultat de la transaction
  final String? message;

  /// ID de commande associé à la transaction
  final String? orderId;

  /// Crée une nouvelle instance de [PaymentResponse]
  PaymentResponse({
    this.transactionId,
    required this.status,
    required this.message,
    this.orderId,
  });
}
