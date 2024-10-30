import 'package:example/axes/axes_gallery.dart';
import 'package:example/bar_chart/bar_gallery.dart';
import 'package:example/combo_chart/combo_gallery.dart';
import 'package:example/gallery_app.dart';
import 'package:example/line_chart/line_gallery.dart';
import 'package:example/main.dart';
import 'package:example/original.dart';
import 'package:example/pie_chart/pie_gallery.dart';
import 'package:example/scatter_plot_chart/scatter_plot_gallery.dart';
import 'package:example/time_series_chart/time_series_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nimble_charts/flutter.dart' as charts;

import '../test_functions.dart';

/// Widget tests for the example app.
void main() {
  group('ExampleApp Widget Tests', () {
    appState.value = appState.value.copyWith(
      isOriginal: true,
      useRandomData: false,
    );

    testWidgets(
      'Main Menu',
      (tester) async {
        const galleryApp = GalleryApp();

        await tester.pumpWidget(galleryApp);

        tester.viewOf(find.byWidget(galleryApp))
          ..physicalSize = const Size(2000, 7000)
          ..devicePixelRatio = 1;

        await tester.pumpAndSettle();

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.semanticChildCount, equals(91));

        await matchesGolden<GalleryApp>(
          'example_menu',
        );
      },
    );

    testWidgets(
      'Navigates to Simple Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        simpleBarChartTileTitle,
        extra: () async {
          await tester.tap(find.byType(charts.BarChart));
          await tester.pumpAndSettle();
        },
      ),
    );

    testWidgets(
      'Navigates to Stacked Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        stackedBarChartTileTitle,
      ),
    );

    testWidgets(
      'Navigates to Grouped Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        groupedBarChartTileTitle,
      ),
    );

    testWidgets(
      'Navigates to Grouped Stacked Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        groupedStackedBarChartTileTitle,
      ),
    );

    testWidgets(
      'Navigates to Grouped Bar Target Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        groupedBarTargetLineChartTileTitle,
      ),
    );

    testWidgets(
      'Navigates to Grouped Bar Single Target Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        groupedBarSingleTargetLineChartTileTitle,
      ),
    );

    testWidgets(
      'Navigates to Stacked Bar Target Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        stackedBarTargetLineChart,
        scrollDelta: 200,
      ),
    );

    testWidgets(
      'Navigates to Horizontal Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        horizontalBarChart,
        scrollDelta: 200,
      ),
    );

    testWidgets(
      'Navigates to Stacked Horizontal Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        stackedHorizontalBarChart,
        scrollDelta: 200,
      ),
    );

    testWidgets(
      'Navigates to Horizontal Bar Chart with Bar Labels and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        horizontalBarLabelChart,
        scrollDelta: 200,
      ),
    );

    testWidgets(
      'Navigates to Horizontal Bar Chart with Custom Bar Labels and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        horizontalBarLabelCustomChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Vertical Bar Chart with Bar Labels and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        verticalBarLabelChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Spark Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        sparkBarChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Grouped Fill Color Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        groupedFillColorChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Stacked Fill Color Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        stackedFillColorChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Pattern Forward Hatch Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        patternForwardHatchChart,
        scrollDelta: 300,
      ),
      skip: true,
    );

    testWidgets(
      'Navigates to Horizontal Pattern Forward Hatch Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        horizontalPatternForwardHatchChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Weighted Pattern Bar Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        weightedPatternChart,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Bar Chart with custom bar radius and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        barChartWithCustomBarRadius,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        simpleTimeSeriesChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to End Points Axis Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        endPointsAxisTimeSeriesChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Line Annotation on Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        lineAnnotationTimeSeriesChartTitle,
        scrollDelta: 360,
      ),
    );

    testWidgets(
      'Navigates to Range Annotation on Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        rangeAnnotationTimeSeriesChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Range Annotation Margin Labels '
      'on Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        rangeAnnotationMarginLabelsTimeSeriesChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Symbol Annotation Time Series Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        symbolAnnotationTimeSeriesChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Time Series Chart with Bars and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        timeSeriesChartWithBarsTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Time Series Chart with Confidence Interval and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        confidenceIntervalTimeSeriesChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        simpleLineChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Stacked Area Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        stackedAreaLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Stacked Area Custom Color Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        stackedAreaCustomColorLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Area and Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        areaAndLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Points Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        pointsLineChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Null Data Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        simpleNullsLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Stacked Area with Nulls Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        stackedAreaNullsLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Dash Pattern Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        dashPatternLineChartTitle,
        scrollDelta: 300,
      ),
    );
    testWidgets(
      'Navigates to Segments Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        segmentsLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Line Annotation Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        lineLineAnnotationChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Range Annotation Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        lineRangeAnnotationChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Range Annotation Margin Labels Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        lineRangeAnnotationMarginChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Pan and Zoom Line Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        lineAnimationZoomChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Scatter Plot Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.ScatterPlotChart>(
        simpleScatterPlotChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Scatter Plot Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.ScatterPlotChart>(
        comparisonPointsScatterPlotChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Scatter Plot Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.ScatterPlotChart>(
        panAndZoomScatterPlotChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Bucketing Axis Scatter Plot Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.ScatterPlotChart>(
        bucketingAxisScatterPlotChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Ordinal Combo Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.OrdinalComboChart>(
        ordinalComboChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Numeric Line Bar Combo Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.NumericComboChart>(
        numericComboLineBarChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Numeric Line Points Combo Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.NumericComboChart>(
        numericComboLinePointChartTitle,
        scrollDelta: 400,
      ),
    );

    testWidgets(
      'Navigates to Time Series Combo Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        dateTimeComboLinePointChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Scatter Plot Combo Chart and Renders',
      (tester) async =>
          tester.navigateToChartAndGolden<charts.ScatterPlotChart>(
        scatterPlotComboLineChartTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Pie Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.PieChart<num>>(
        simplePieChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Partial Pie Chart and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.PieChart<num>>(
        partialPieChartTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Bar chart with Secondary Measure Axis and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kBarChartWithSecondaryAxisTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Bar chart with Secondary Measure Axis Only and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kBarChartWithSecondaryAxisOnlyTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Horizontal Bar chart with Secondary Measure Axis, Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kHorizontalBarChartWithSecondaryAxisTitle,
        scrollDelta: 400,
      ),
    );

    testWidgets(
      'Navigates to Short Ticks Axis and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kShortTicksAxisTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Custom Axis Fonts and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kCustomAxisFontsTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Label Alignment Axis and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kLabelAlignmentAxisTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to No Axis and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kNoAxisTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Statically Provided Ticks and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kStaticallyProvidedTicksTitle,
        scrollDelta: 400,
      ),
    );

    testWidgets(
      'Navigates to Custom Formatter and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        kCustomFormatterTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Custom Tick Count and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        kCustomTickCountTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Integer Measure Ticks and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        kIntegerMeasureTicksTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Non-zero bound Axis and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        kNonZeroBoundAxisTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Ordinal axis with initial viewport and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.BarChart>(
        kOrdinalAxisWithInitialViewportTitle,
        scrollDelta: 350,
      ),
    );

    testWidgets(
      'Navigates to Numeric axis with initial viewport and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        kNumericAxisWithInitialViewportTitle,
        scrollDelta: 400,
      ),
    );

    testWidgets(
      'Navigates to Gridline dash pattern and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.TimeSeriesChart>(
        kGridlineDashPatternTitle,
        scrollDelta: 300,
      ),
    );

    testWidgets(
      'Navigates to Disjoint measure axes and Renders',
      (tester) async => tester.navigateToChartAndGolden<charts.LineChart>(
        kDisjointMeasureAxesTitle,
        scrollDelta: 300,
      ),
    );
  });
}

extension ExampleWidgetTestExtensions on WidgetTester {
  /// Taps on the button and takes a golden screenshot of the chart.
  Future<void> navigateToChartAndGolden<T extends Widget>(
    String tileText, {
    Future<void> Function()? extra,
    double? scrollDelta,
  }) async {
    //Create and pump
    const galleryApp = GalleryApp();
    await pumpWidget(galleryApp);

    //Set the screen size of the widget
    viewOf(find.byWidget(galleryApp))
      ..physicalSize = const Size(1200, 700)
      ..devicePixelRatio = 1;

    expect(find.byType(Original), findsOneWidget);

    // Find the list tile by text
    final tileFinder = find.byWidgetPredicate(
      (w) => switch (w) {
        final ListTile l => switch (l.title) {
            final Text t when t.data == tileText => true,
            _ => false
          },
        _ => false
      },
    );

    // Scroll to the button if needed.
    if (scrollDelta != null) {
      await scrollUntilVisible(tileFinder, scrollDelta);
    }

    // Tap the tile
    await tap(tileFinder);
    await pumpAndSettle();
    await pump(const Duration(seconds: 1));

    //Check that the chart exists
    expect(find.byType(T), findsOneWidget);

    // Do extra assertions
    await extra?.call();

    await matchesGolden<T>(
      'example_${tileText.replaceAll(' ', '_').toLowerCase()}',
    );
  }
}
