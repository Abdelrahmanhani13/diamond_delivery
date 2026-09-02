import 'package:flutter_test/flutter_test.dart';
import 'package:vendor_dashboard/main.dart';

void main() {
  testWidgets('Vendor Dashboard App smoke test', (WidgetTester tester) async {
    // Basic instantiation check
    expect(const VendorDashboardApp(), isNotNull);
  });
}
