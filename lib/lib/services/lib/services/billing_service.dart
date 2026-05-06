import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingService {
  static const String subscriptionId = 'sub_monthly_29mad';
  final InAppPurchase _iap = InAppPurchase.instance;
  bool isAvailable = false;
  List<ProductDetails> products = [];

  BillingService() {
    _initialize();
  }

  Future<void> _initialize() async {
    isAvailable = await _iap.isAvailable();
    if (!isAvailable) return;
    final response = await _iap.queryProductDetails({subscriptionId}.toSet());
    products = response.productDetails;
    _iap.purchaseStream.listen(_handlePurchase);
  }

  void _handlePurchase(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_subscribed', true);
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_subscribed') ?? false;
  }

  Future<void> buySubscription() async {
    if (products.isEmpty) return;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: products.first,
    );
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
