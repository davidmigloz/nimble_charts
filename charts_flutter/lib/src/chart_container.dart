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

import 'dart:async';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:nimble_charts/flutter.dart';
import 'package:nimble_charts/src/base_chart_state.dart';
import 'package:nimble_charts/src/chart_canvas.dart' as cc;
import 'package:nimble_charts/src/graphics_factory.dart' as gf;
import 'package:nimble_charts_common/common.dart' as common;
//import 'package:sky_engine/ui/text.dart' as sky;

/// Widget that inflates to a [CustomPaint] that implements common
/// [common.ChartContext].
class ChartContainer<D> extends CustomPaint {
  const ChartContainer({
    required this.chartWidget,
    required this.chartState,
    required this.animationValue,
    required this.rtl,
    super.key,
    this.oldChartWidget,
    this.rtlSpec,
    this.userManagedState,
  });
  final BaseChart<D> chartWidget;
  final BaseChart<D>? oldChartWidget;
  final BaseChartState<D> chartState;
  final double animationValue;
  final bool rtl;
  final common.RTLSpec? rtlSpec;
  final UserManagedState<D>? userManagedState;

  @override
  RenderCustomPaint createRenderObject(BuildContext context) =>
      ChartContainerRenderObject<D>()..reconfigure(this, context);

  @override
  void updateRenderObject(
    BuildContext context,
    ChartContainerRenderObject renderObject,
  ) {
    renderObject.reconfigure(this, context);
  }
}

/// A [RenderCustomPaint] that implements [common.ChartContext] for rendering
/// charts.
///
/// This class is responsible for managing the rendering state of a chart and
/// providing the necessary context for chart behaviors and interactions.
class ChartContainerRenderObject<D> extends RenderCustomPaint
    implements common.ChartContext {
  /// The underlying common chart implementation.
  common.BaseChart<D>? _chart;

  /// The list of series to be rendered.
  List<common.Series<dynamic, D>>? _seriesList;

  /// The state of the chart.
  late BaseChartState<D> _chartState;

  /// Whether the chart container is in RTL mode.
  bool _chartContainerIsRtl = false;

  /// RTL specification for the chart.
  common.RTLSpec? _rtlSpec;

  /// Factory for creating DateTime objects.
  common.DateTimeFactory? _dateTimeFactory;

  /// Whether the chart is in explore mode.
  bool _exploreMode = false;

  /// List of accessibility nodes.
  List<common.A11yNode>? _a11yNodes;

  /// Reconfigures the chart container with new configuration.
  ///
  /// [config] The new configuration.
  /// [context] The build context.
  void reconfigure(ChartContainer<D> config, BuildContext context) {
    _chartState = config.chartState;

    _dateTimeFactory = (config.chartWidget is TimeSeriesChart)
        ? (config.chartWidget as TimeSeriesChart).dateTimeFactory
        : null;
    _dateTimeFactory ??= const common.LocalDateTimeFactory();

    if (_chart == null) {
      common.Performance.time('chartsCreate');
      _chart = config.chartWidget.createCommonChart(_chartState);
      _chart!.init(this, gf.GraphicsFactory(context));
      common.Performance.timeEnd('chartsCreate');
    }
    common.Performance.time('chartsConfig');
    config.chartWidget
        .updateCommonChart(_chart!, config.oldChartWidget, _chartState);

    _rtlSpec = config.rtlSpec;
    _chartContainerIsRtl = config.rtl;

    common.Performance.timeEnd('chartsConfig');

    if (_chartState.chartIsDirty) {
      _chart!.configurationChanged();
    }

    // If series list changes or other configuration changed that triggered the
    // _chartState.configurationChanged flag to be set (such as axis, behavior,
    // and renderer changes). Otherwise, the chart only requests repainting and
    // does not reprocess the series.
    //
    // Series list is considered "changed" based on the instance.
    if (_seriesList != config.chartWidget.seriesList ||
        _chartState.chartIsDirty) {
      _chartState.resetChartDirtyFlag();
      _seriesList = config.chartWidget.seriesList;

      // Clear out the a11y nodes generated.
      _a11yNodes = null;

      common.Performance.time('chartsDraw');
      _chart!.draw(_seriesList!);
      common.Performance.timeEnd('chartsDraw');

      // This is needed because when a series changes we need to reset flutter's
      // animation value from 1.0 back to 0.0.
      _chart!.animationPercent = 0.0;
      markNeedsLayout();
    } else {
      _chart!.animationPercent = config.animationValue;
      markNeedsPaint();
    }

    _updateUserManagedState(config.userManagedState);

    // Set the painter used for calling common chart for paint.
    // This painter is also used to generate semantic nodes for a11y.
    _setNewPainter();
  }

  /// If user managed state is set, check each setting to see if it is different
  /// than internal chart state and only update if different.
  void _updateUserManagedState(UserManagedState<D>? newState) {
    if (newState == null) {
      return;
    }

    // Only override the selection model if it is different than the existing
    // selection model so update listeners are not unnecessarily triggered.
    for (final type in newState.selectionModels.keys) {
      final model = _chart!.getSelectionModel(type);

      final userModel =
          newState.selectionModels[type]!.getModel(_chart!.currentSeriesList);

      if (model != userModel) {
        model.updateSelection(
          userModel.selectedDatum,
          userModel.selectedSeries,
        );
      }
    }
  }

  @override
  void performLayout() {
    common.Performance.time('chartsLayout');
    _chart!
        .measure(constraints.maxWidth.toInt(), constraints.maxHeight.toInt());
    _chart!.layout(constraints.maxWidth.toInt(), constraints.maxHeight.toInt());
    common.Performance.timeEnd('chartsLayout');
    size = constraints.biggest;

    // Check if the gestures registered in gesture registry matches what the
    // common chart is listening to.
    // TODO: Still need a test for this for sanity sake.
//    assert(_desiredGestures
//        .difference(_chart!.gestureProxy.listenedGestures)
//        .isEmpty);
  }

  @override
  void markNeedsLayout() {
    super.markNeedsLayout();
    if (parent != null) {
      markParentNeedsLayout();
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void requestRedraw() {}

  @override
  void requestAnimation(Duration transition) {
    void startAnimationController(_) {
      _chartState.setAnimation(transition);
    }

    // Sometimes chart behaviors try to draw the chart outside of a Flutter draw
    // cycle. Schedule a frame manually to handle these cases.
    if (!SchedulerBinding.instance.hasScheduledFrame) {
      SchedulerBinding.instance.scheduleFrame();
    }

    SchedulerBinding.instance.addPostFrameCallback(startAnimationController);
  }

  /// Request Flutter to rebuild the widget/container of chart.
  ///
  /// This is different than requesting redraw and paint because those only
  /// affect the chart widget. This is for requesting rebuild of the Flutter
  /// widget that contains the chart widget. This is necessary for supporting
  /// Flutter widgets that are layout with the chart.
  ///
  /// Example is legends, a legend widget can be layout on top of the chart
  /// widget or along the sides of the chart. Requesting a rebuild allows
  /// the legend to layout and redraw itself.
  void requestRebuild() {
    void doRebuild(_) {
      _chartState.requestRebuild();
    }

    // Flutter does not allow requesting rebuild during the build cycle, this
    // schedules rebuild request to happen after the current build cycle.
    // This is needed to request rebuild after the legend has been added in the
    // post process phase of the chart, which happens during the chart widget's
    // build cycle.
    SchedulerBinding.instance.addPostFrameCallback(doRebuild);
  }

  /// When Flutter's markNeedsLayout is called, layout and paint are both
  /// called. If animations are off, Flutter's paint call after layout will
  /// paint the chart. If animations are on, Flutter's paint is called with the
  /// initial animation value and then the animation controller is started after
  /// this first build cycle.
  @override
  void requestPaint() {
    markNeedsPaint();
  }

  @override
  double get pixelsPerDp => 1;

  @override
  bool get chartContainerIsRtl => _chartContainerIsRtl;

  @override
  common.RTLSpec? get rtlSpec => _rtlSpec;

  @override
  bool get isRtl =>
      _chartContainerIsRtl &&
      (_rtlSpec == null ||
          _rtlSpec?.axisDirection == common.AxisDirection.reversed);

  @override
  bool get isTappable => _chart!.isTappable;

  @override
  common.DateTimeFactory get dateTimeFactory => _dateTimeFactory!;

  /// Gets the chart's gesture listener.
  common.ProxyGestureListener get gestureProxy => _chart!.gestureProxy;

  TextDirection get textDirection =>
      _chartContainerIsRtl ? TextDirection.rtl : TextDirection.ltr;

  @override
  void enableA11yExploreMode(
    List<common.A11yNode> nodes, {
    String? announcement,
  }) {
    _a11yNodes = nodes;
    _exploreMode = true;
    _setNewPainter();
    requestRebuild();
    if (announcement != null) {
      unawaited(
        SemanticsService.announce(
          announcement,
          toDartTextDirection(textDirection),
        ),
      );
    }
  }

  @override
  void disableA11yExploreMode({String? announcement}) {
    _a11yNodes = [];
    _exploreMode = false;
    _setNewPainter();
    requestRebuild();
    if (announcement != null) {
      unawaited(
        SemanticsService.announce(
          announcement,
          toDartTextDirection(textDirection),
        ),
      );
    }
  }

  /// Sets a new painter for the chart container.
  void _setNewPainter() {
    painter = ChartContainerCustomPaint(
      oldPainter: painter as ChartContainerCustomPaint?,
      chart: _chart!,
      exploreMode: _exploreMode,
      a11yNodes: _a11yNodes ?? [],
      textDirection: textDirection,
    );
  }
}

/// A custom painter for chart containers.
///
/// This class is responsible for painting the chart and managing its state.
class ChartContainerCustomPaint extends CustomPainter {
  /// Creates a new [ChartContainerCustomPaint].
  ///
  /// If an [oldPainter] is provided with matching properties, returns the old
  /// painter instead of creating a new one.
  ///
  /// [chart] The chart to paint.
  /// [exploreMode] Whether the chart is in explore mode.
  /// [a11yNodes] List of accessibility nodes.
  /// [textDirection] The text direction for the chart.
  factory ChartContainerCustomPaint({
    required common.BaseChart chart,
    ChartContainerCustomPaint? oldPainter,
    bool exploreMode = false,
    List<common.A11yNode> a11yNodes = const [],
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (oldPainter != null &&
        oldPainter.exploreMode == exploreMode &&
        oldPainter.a11yNodes == a11yNodes &&
        oldPainter.textDirection == textDirection) {
      return oldPainter;
    } else {
      return ChartContainerCustomPaint._internal(
        chart: chart,
        exploreMode: exploreMode,
        a11yNodes: a11yNodes,
        textDirection: textDirection,
      );
    }
  }

  /// Internal constructor for [ChartContainerCustomPaint].
  ChartContainerCustomPaint._internal({
    required this.chart,
    required this.exploreMode,
    required this.a11yNodes,
    required this.textDirection,
  });

  /// The chart to paint.
  final common.BaseChart chart;

  /// Whether the chart is in explore mode.
  final bool exploreMode;

  /// List of accessibility nodes.
  final List<common.A11yNode> a11yNodes;

  /// The text direction for the chart.
  final TextDirection textDirection;

  /// Paints the chart on the canvas.
  @override
  void paint(Canvas canvas, Size size) {
    common.Performance.time('chartsPaint');
    final chartsCanvas = cc.ChartCanvas(canvas, chart.graphicsFactory!);
    chart.paint(chartsCanvas);
    common.Performance.timeEnd('chartsPaint');
  }

  /// Whether the chart should be repainted.
  @override
  bool shouldRepaint(ChartContainerCustomPaint oldPainter) => false;

  /// Whether the semantics should be rebuilt.
  @override
  bool shouldRebuildSemantics(ChartContainerCustomPaint oldDelegate) =>
      exploreMode != oldDelegate.exploreMode ||
      a11yNodes != oldDelegate.a11yNodes ||
      textDirection != textDirection;

  /// Builds the semantics for the chart.
  @override
  SemanticsBuilderCallback get semanticsBuilder => _buildSemantics;

  /// Builds the semantic nodes for the chart.
  List<CustomPainterSemantics> _buildSemantics(Size size) {
    final nodes = <CustomPainterSemantics>[];

    for (final node in a11yNodes) {
      final rect = Rect.fromLTWH(
        node.boundingBox.left.toDouble(),
        node.boundingBox.top.toDouble(),
        node.boundingBox.width.toDouble(),
        node.boundingBox.height.toDouble(),
      );
      nodes.add(
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            value: node.label,
            textDirection: toDartTextDirection(textDirection),
            onDidGainAccessibilityFocus: node.onFocus,
          ),
        ),
      );
    }

    return nodes;
  }
}

ui.TextDirection toDartTextDirection(TextDirection textDirection) =>
    switch (textDirection) {
      TextDirection.ltr => ui.TextDirection.ltr,
      TextDirection.rtl => ui.TextDirection.rtl,
      //TODO: is this mapping correct?
      TextDirection.center => ui.TextDirection.ltr,
    };
