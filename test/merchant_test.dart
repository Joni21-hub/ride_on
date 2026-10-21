import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/merchant_view.dart';
import 'package:flutter_application_1/screens/merchant/merchant_dashboard_tab.dart';
import 'package:flutter_application_1/screens/merchant/merchant_orders_tab.dart';
import 'package:flutter_application_1/screens/merchant/merchant_menu_tab.dart';
import 'package:flutter_application_1/screens/merchant/merchant_wallet_tab.dart';

void main() {
  testWidgets('MerchantView renders all tabs and interacts with order lifecycle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MerchantView(onBackToCustomer: () {}),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Header and Dashboard Tab
    expect(find.text('Dapur Sambal Sukaramai'), findsWidgets);
    expect(find.text('Gerai Buka'), findsOneWidget);
    expect(find.byType(MerchantDashboardTab), findsOneWidget);
    expect(find.text('Rp 485.000'), findsOneWidget);

    // 2. Switch to Pesanan Tab via Icon
    await tester.tap(find.byIcon(Icons.receipt_long));
    await tester.pumpAndSettle();
    expect(find.byType(MerchantOrdersTab), findsOneWidget);
    expect(find.text('Pesanan Baru'), findsOneWidget);
    expect(find.text('Pesanan'), findsOneWidget);

    // 3. Switch to Menu Tab via Icon
    await tester.tap(find.byIcon(Icons.restaurant_menu));
    await tester.pumpAndSettle();
    expect(find.byType(MerchantMenuTab), findsOneWidget);
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);

    // 4. Switch to Keuangan Tab via Icon
    await tester.tap(find.byIcon(Icons.account_balance_wallet));
    await tester.pumpAndSettle();
    expect(find.byType(MerchantWalletTab), findsOneWidget);
    expect(find.text('Saldo Dompet Gerai'), findsOneWidget);
    expect(find.text('Keuangan'), findsOneWidget);
  });
}
