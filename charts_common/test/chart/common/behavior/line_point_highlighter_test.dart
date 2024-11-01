// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math' show Point, Rectangle;

import 'package:mockito/mockito.dart';
import 'package:nimble_charts_common/src/chart/cartesian/axis/axis.dart';
import 'package:nimble_charts_common/src/chart/common/base_chart.dart';
import 'package:nimble_charts_common/src/chart/common/behavior/line_point_highlighter.dart';
import 'package:nimble_charts_common/src/chart/common/datum_details.dart';
import 'package:nimble_charts_common/src/chart/common/processed_series.dart';
import 'package:nimble_charts_common/src/chart/common/selection_model/selection_model.dart';
import 'package:nimble_charts_common/src/chart/common/series_datum.dart';
import 'package:nimble_charts_common/src/chart/common/series_renderer.dart';
import 'package:nimble_charts_common/src/common/material_palette.dart';
import 'package:nimble_charts_common/src/common/math.dart';
import 'package:nimble_charts_common/src/data/series.dart';
import 'package:test/test.dart';

import '../../../mox.mocks.dart';

class MockCartesianChart extends MockChart<dynamic> {
  LifecycleListener<dynamic>? lastListener;

  @override
  LifecycleListener<dynamic> addLifecycleListener(
    LifecycleListener<dynamic>? listener,
  ) {
    lastListener = listener;
    return lastListener!;
  }

  @override
  bool removeLifecycleListener(LifecycleListener<dynamic>? listener) {
    expect(listener, equals(lastListener));
    lastListener = null;
    return true;
  }

  @override
  bool get vertical => true;
}

class MockSelectionModel extends MockMutableSelectionModel<dynamic> {
  SelectionModelListener<dynamic>? lastListener;

  @override
  void addSelectionChangedListener(SelectionModelListener<dynamic>? listener) =>
      lastListener = listener;

  @override
  void removeSelectionChangedListener(
    SelectionModelListener<dynamic>? listener,
  ) {
    expect(listener, equals(lastListener));
    lastListener = null;
  }
}

class MockNumericAxis extends Mock implements NumericAxis {
  @override
  double? getLocation(num? domain) => 10;
}

class MockSeriesRenderer<D> extends BaseSeriesRenderer<D> {
  MockSeriesRenderer() : super(rendererId: 'fake', layoutPaintOrder: 0);

  @override
  void update(_, __) {}

  @override
  void paint(_, __) {}

  @override
  List<DatumDetails<D>> getNearestDatumDetailPerSeries(
    Point<double> chartPoint,
    bool byDomain,
    Rectangle<int>? boundsOverride, {
    bool selectOverlappingPoints = false,
    bool selectExactEventLocation = false,
  }) {
    throw UnimplementedError();
  }

  @override
  DatumDetails<D> addPositionToDetailsForSeriesDatum(
    DatumDetails<D> details,
    SeriesDatum<D> seriesDatum,
  ) =>
      DatumDetails.from(details, chartPosition: const NullablePoint(0, 0));
}

void main() {
  late MockCartesianChart chart;
  late MockSelectionModel selectionModel;
  late MockSeriesRenderer<dynamic> seriesRenderer;

  late MutableSeries<int> series1;
  final s1D1 = MyRow(1, 11);
  final s1D2 = MyRow(2, 12);
  final s1D3 = MyRow(3, 13);

  late MutableSeries<int> series2;
  final s2D1 = MyRow(4, 21);
  final s2D2 = MyRow(5, 22);
  final s2D3 = MyRow(6, 23);

  List<DatumDetails<dynamic>> mockGetSelectedDatumDetails(
    List<SeriesDatum<dynamic>> selection,
  ) {
    final details = <DatumDetails<dynamic>>[];

    for (final seriesDatum in selection) {
      details.add(seriesRenderer.getDetailsForSeriesDatum(seriesDatum));
    }

    return details;
  }

  void setupSelection(List<SeriesDatum<int>> selection) {
    final selected = <MyRow>[];

    for (var i = 0; i < selection.length; i++) {
      selected.add(selection[0].datum as MyRow);
    }

    for (var i = 0; i < series1.data.length; i++) {
      when(selectionModel.isDatumSelected(series1, i))
          .thenReturn(selected.contains(series1.data[i]));
    }
    for (var i = 0; i < series2.data.length; i++) {
      when(selectionModel.isDatumSelected(series2, i))
          .thenReturn(selected.contains(series2.data[i]));
    }

    when(selectionModel.selectedDatum).thenReturn(selection);

    final selectedDetails = mockGetSelectedDatumDetails(selection);

    when(chart.getSelectedDatumDetails(SelectionModelType.info))
        .thenReturn(selectedDetails);
  }

  setUp(() {
    chart = MockCartesianChart();

    seriesRenderer = MockSeriesRenderer();

    selectionModel = MockSelectionModel();
    when(chart.getSelectionModel(SelectionModelType.info))
        .thenReturn(selectionModel);

    series1 = MutableSeries(
      Series<MyRow, int>(
        id: 's1',
        data: [s1D1, s1D2, s1D3],
        domainFn: (row, _) => row.campaign,
        measureFn: (row, _) => row.count,
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      ),
    )..measureFn = (_) => 0.0;

    series2 = MutableSeries(
      Series<MyRow, int>(
        id: 's2',
        data: [s2D1, s2D2, s2D3],
        domainFn: (row, _) => row.campaign,
        measureFn: (row, _) => row.count,
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
      ),
    )..measureFn = (_) => 0.0;
  });

  group('LinePointHighlighter', () {
    test('highlights the selected points', () {
      // Setup
      final behavior =
          LinePointHighlighter(selectionModelType: SelectionModelType.info);
      final tester = LinePointHighlighterTester(behavior);
      behavior.attachTo(chart);
      setupSelection([
        SeriesDatum(series1, s1D2),
        SeriesDatum(series2, s2D2),
      ]);

      // Mock axes for returning fake domain locations.
      final Axis<num> domainAxis = MockNumericAxis();
      final Axis<num> primaryMeasureAxis = MockNumericAxis();

      series1
        ..setAttr(domainAxisKey, domainAxis)
        ..setAttr(measureAxisKey, primaryMeasureAxis)
        ..measureOffsetFn = (_) => 0.0;

      series2
        ..setAttr(domainAxisKey, domainAxis)
        ..setAttr(measureAxisKey, primaryMeasureAxis)
        ..measureOffsetFn = (_) => 0.0;

      // Act
      selectionModel.lastListener?.call(selectionModel);
      verify(chart.redraw(skipAnimation: true, skipLayout: true));

      chart.lastListener?.onAxisConfigured?.call();

      // Verify
      expect(tester.getSelectionLength(), equals(2));

      expect(tester.isDatumSelected(series1.data[0]), equals(false));
      expect(tester.isDatumSelected(series1.data[1]), equals(true));
      expect(tester.isDatumSelected(series1.data[2]), equals(false));

      expect(tester.isDatumSelected(series2.data[0]), equals(false));
      expect(tester.isDatumSelected(series2.data[1]), equals(true));
      expect(tester.isDatumSelected(series2.data[2]), equals(false));
    });

    test('listens to other selection models', () {
      // Setup
      final behavior =
          LinePointHighlighter(selectionModelType: SelectionModelType.action);
      when(chart.getSelectionModel(SelectionModelType.action))
          .thenReturn(selectionModel);

      // Act
      behavior.attachTo(chart);

      // Verify
      verify(chart.getSelectionModel(SelectionModelType.action));
      verifyNever(chart.getSelectionModel(SelectionModelType.info));
    });

    test('leaves everything alone with no selection', () {
      // Setup
      final behavior =
          LinePointHighlighter(selectionModelType: SelectionModelType.info);
      final tester = LinePointHighlighterTester(behavior);
      behavior.attachTo(chart);
      setupSelection([]);

      // Act
      selectionModel.lastListener?.call(selectionModel);
      verify(chart.redraw(skipAnimation: true, skipLayout: true));
      chart.lastListener?.onAxisConfigured?.call();

      // Verify
      expect(tester.getSelectionLength(), equals(0));

      expect(tester.isDatumSelected(series1.data[0]), equals(false));
      expect(tester.isDatumSelected(series1.data[1]), equals(false));
      expect(tester.isDatumSelected(series1.data[2]), equals(false));

      expect(tester.isDatumSelected(series2.data[0]), equals(false));
      expect(tester.isDatumSelected(series2.data[1]), equals(false));
      expect(tester.isDatumSelected(series2.data[2]), equals(false));
    });

    test('cleans up', () {
      // Setup
      final behavior =
          LinePointHighlighter(selectionModelType: SelectionModelType.info)
            ..attachTo(chart);
      setupSelection([
        SeriesDatum(series1, s1D2),
        SeriesDatum(series2, s2D2),
      ]);

      // Act
      behavior.removeFrom(chart);

      // Verify
      expect(chart.lastListener, isNull);
      expect(selectionModel.lastListener, isNull);
    });
  });
}

class MyRow {
  MyRow(this.campaign, this.count);
  final int campaign;
  final int count;
}
