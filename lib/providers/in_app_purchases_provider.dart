import 'dart:async';

import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class InAppPurchasesProvider {
  //late StreamSubscription<List<PurchaseDetails>> _subscription;
  static late Stream _stream;
  static List<ProductDetails> _products = [];

  static Future<bool> _validate(PurchaseDetails details) {
    // TODO: Fix this.
    return Future.value(true);
  }

  static Future<void> init() async {
    _stream = InAppPurchase.instance.purchaseStream;

    print("InAppPurchasesProvider.init");

    const Set<String> _kIds = {'remove_ads'};
    ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);

    _products = response.productDetails;

    print("InAppPurchasesProvider.init: _products: $_products");
    for (ProductDetails product in _products) {
      print(
          "InAppPurchasesProvider.init: product: ${product.title} ${product.price}");
    }

    _stream.listen((list) async {
      for (PurchaseDetails purchase in list) {
        if (purchase.status == PurchaseStatus.pending) {
        } else {
          if (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored) {
            if (await _validate(purchase)) {
              SharedPreferencesProvider.removeAdsPurchased = true;
              SharedPreferencesProvider.save();

              InAppPurchase.instance.completePurchase(purchase);
            }
          }
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }
        }
      }
    });
  }

  static List<ProductDetails> get products => _products;

  static Stream get stream => _stream;
}
