import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/screens/titip_belanja_screen.dart';
import 'package:flutter_application_1/screens/customer_tracking_screen.dart';

void main() {
  testWidgets('TitipBelanjaScreen renders multi-location and calculates tiered fees', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TitipBelanjaScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Title & Locations
    expect(find.text('Titip Belanja Manual'), findsOneWidget);
    expect(find.textContaining('Pasar Tradisional Sukaramai'), findsOneWidget);
    expect(find.textContaining('Apotek Kimia Farma Batuphat'), findsOneWidget);

    // 2. Verify Items
    expect(find.textContaining('Daging Sapi (1 kg)'), findsOneWidget);
    expect(find.textContaining('Cabai Merah (1/2 kg)'), findsOneWidget);
    expect(find.textContaining('Minyak Kayu Putih'), findsOneWidget);

    // 3. Verify Ongkir calculation
    // Base: 12000, Extra location: +2000, 5 items (4-6 tier): +1000 => Total: 15000
    expect(find.text('Total Ongkir Driver'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);

    // 4. Tap Cari Driver Belanja
    await tester.tap(find.text('CARI DRIVER BELANJA'));
    await tester.pumpAndSettle();

    // 5. Verify CustomerTrackingScreen opens
    expect(find.byType(CustomerTrackingScreen), findsOneWidget);
    expect(find.text('Driver Menuju Pasar / Toko'), findsOneWidget);
    expect(find.textContaining('Joni Utama'), findsWidgets);
  });
}
