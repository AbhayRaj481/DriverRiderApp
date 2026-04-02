import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class InAppPurchaseTracker {
  static InAppPurchaseTracker? _instance;
  factory InAppPurchaseTracker() =>
      _instance ??= InAppPurchaseTracker._internal();
  InAppPurchaseTracker._internal();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  final List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Initialize IAP connection.
  Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () => _subscription?.cancel(),
      onError: (error){
        if (kDebugMode) {
          print('Purchase error: $error');
        }},
    );
    await _initialize();
  }

  Future<void> _initialize() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      _isAvailable = false;
      return;
    }
    _isAvailable = true;
    // iOS specific
     StreamSubscription<List<PurchaseDetails>>? iosPlatformAddition =
        _iap.purchaseStream.listen((data){});
    iosPlatformAddition;
  }

  /// Load subscription products by IDs.
  Future<void> loadSubscriptions(List<String> productIds) async {
    if (!_isAvailable) throw Exception('IAP not available');
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      productIds.toSet(),
    );
    if (response.error != null) {
      throw Exception('Error loading products: ${response.error!.message}');
    }
    _products = response.productDetails;
  }

  /// Buy subscription.
  Future<void> buySubscription({required String productId}) async {
    if (!_isAvailable) throw Exception('IAP not available');
    final ProductDetails? product = _products.firstWhereOrNull(
      (p) => p.id == productId,
    );
    if (product == null) throw Exception('Product not found');
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore purchases.
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Consume/delete purchase (for consumables).
  Future<void> consumePurchase({
    required PurchaseDetails purchaseDetails,
  }) async {
    await _iap.completePurchase(purchaseDetails);
  }

  /// Get current subscriptions/purchases.
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get isAvailable => _isAvailable;

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {

    for(var purchaseDetails in purchaseDetailsList){
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Pending UI
      }
      else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
      }
      else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _purchases.add(purchaseDetails);
          // Save to Firebase
          String? uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            await _dbRef
                .child('users/$uid/subscriptions')
                .child(purchaseDetails.purchaseID!)
                .set({
              'productId': purchaseDetails.productID,
              'purchaseId': purchaseDetails.purchaseID,
              'status': purchaseDetails.status,
              'verificationData':
              purchaseDetails.verificationData.serverVerificationData,
            });
          }
        }
        await _iap.completePurchase(purchaseDetails);
      }
    }
    /*purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {

    });*/
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Server verify or local
    // For subs, check receipt
    return true; // Placeholder
  }

  void dispose() {
    _subscription?.cancel();
  }
}

// Extension for firstWhereOrNull if not available
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}
