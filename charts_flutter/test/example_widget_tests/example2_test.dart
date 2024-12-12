import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nimble_charts/flutter.dart' as charts;
import 'example_test.dart';

/// Widget tests for the example app.
void main() {
  appState.value = appState.value.copyWith(
    isOriginal: true,
    useRandomData: false,
  );
  testWidgets(
    'Navigates to Outside Label Pie Chart',
    (tester) async => tester.navigateToChartAndGolden<charts.PieChart<num>>(
      'Outside Label Pie Chart',
      scrollDelta: 350,
      skipGolden: true,
    ),
  );
}
