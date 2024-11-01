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

import 'package:example/axes/bar_secondary_axis.dart';
import 'package:example/axes/bar_secondary_axis_only.dart';
import 'package:example/axes/custom_axis_tick_formatters.dart';
import 'package:example/axes/custom_font_size_and_color.dart';
import 'package:example/axes/custom_measure_tick_count.dart';
import 'package:example/axes/gridline_dash_pattern.dart';
import 'package:example/axes/hidden_ticks_and_labels_axis.dart';
import 'package:example/axes/horizontal_bar_secondary_axis.dart';
import 'package:example/axes/integer_only_measure_axis.dart';
import 'package:example/axes/line_disjoint_axis.dart';
import 'package:example/axes/measure_axis_label_alignment.dart';
import 'package:example/axes/nonzero_bound_measure_axis.dart';
import 'package:example/axes/numeric_initial_viewport.dart';
import 'package:example/axes/ordinal_initial_viewport.dart';
import 'package:example/axes/short_tick_length_axis.dart';
import 'package:example/axes/statically_provided_ticks.dart';
import 'package:example/gallery_scaffold.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

const kBarChartWithSecondaryAxisTitle = 'Bar chart with Secondary Measure Axis';
const kBarChartWithSecondaryAxisSubtitle =
    'Bar chart with a series using a secondary measure axis';

const kBarChartWithSecondaryAxisOnlyTitle =
    'Bar chart with Secondary Measure Axis only';
const kBarChartWithSecondaryAxisOnlySubtitle =
    'Bar chart with both series using secondary measure axis';

const kHorizontalBarChartWithSecondaryAxisTitle =
    'Horizontal bar chart with Secondary Measure Axis';
const kHorizontalBarChartWithSecondaryAxisSubtitle =
    'Horizontal Bar chart with a series using secondary measure axis';

const kShortTicksAxisTitle = 'Short Ticks Axis';
const kShortTicksAxisSubtitle =
    'Bar chart with the primary measure axis having short ticks';

const kCustomAxisFontsTitle = 'Custom Axis Fonts';
const kCustomAxisFontsSubtitle =
    'Bar chart with custom axis font size and color';

const kLabelAlignmentAxisTitle = 'Label Alignment Axis';
const kLabelAlignmentAxisSubtitle =
    'Bar chart with custom measure axis label alignments';

const kNoAxisTitle = 'No Axis';
const kNoAxisSubtitle = 'Bar chart with only the axis line drawn';

const kStaticallyProvidedTicksTitle = 'Statically Provided Ticks';
const kStaticallyProvidedTicksSubtitle =
    'Bar chart with statically provided ticks';

const kCustomFormatterTitle = 'Custom Formatter';
const kCustomFormatterSubtitle =
    'Timeseries with custom domain and measure tick formatters';

const kCustomTickCountTitle = 'Custom Tick Count';
const kCustomTickCountSubtitle =
    'Timeseries with custom measure axis tick count';

const kIntegerMeasureTicksTitle = 'Integer Measure Ticks';
const kIntegerMeasureTicksSubtitle =
    'Timeseries with only whole number measure axis ticks';

const kNonZeroBoundAxisTitle = 'Non-zero bound Axis';
const kNonZeroBoundAxisSubtitle =
    'Timeseries with measure axis that does not include zero';

const kOrdinalAxisWithInitialViewportTitle =
    'Ordinal axis with initial viewport';
const kOrdinalAxisWithInitialViewportSubtitle =
    'Single series with initial viewport';

const kNumericAxisWithInitialViewportTitle =
    'Numeric axis with initial viewport';
const kNumericAxisWithInitialViewportSubtitle =
    'Initial viewport is set to a subset of the data';

const kGridlineDashPatternTitle = 'Gridline dash pattern';
const kGridlineDashPatternSubtitle =
    'Timeseries with measure gridlines that have a dash pattern';

const kDisjointMeasureAxesTitle = 'Disjoint Measure Axes';
const kDisjointMeasureAxesSubtitle = 'Line chart with disjoint measure axes';

List<GalleryScaffold> buildGallery() => [
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kBarChartWithSecondaryAxisTitle,
        subtitle: kBarChartWithSecondaryAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? BarChartWithSecondaryAxis.withRandomData
            : BarChartWithSecondaryAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kBarChartWithSecondaryAxisOnlyTitle,
        subtitle: kBarChartWithSecondaryAxisOnlySubtitle,
        childBuilder: appState.value.useRandomData
            ? BarChartWithSecondaryAxisOnly.withRandomData
            : BarChartWithSecondaryAxisOnly.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: Transform.rotate(
          angle: 1.5708,
          child: const Icon(Icons.insert_chart),
        ),
        title: kHorizontalBarChartWithSecondaryAxisTitle,
        subtitle: kHorizontalBarChartWithSecondaryAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? HorizontalBarChartWithSecondaryAxis.withRandomData
            : HorizontalBarChartWithSecondaryAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kShortTicksAxisTitle,
        subtitle: kShortTicksAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? ShortTickLengthAxis.withRandomData
            : ShortTickLengthAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kCustomAxisFontsTitle,
        subtitle: kCustomAxisFontsSubtitle,
        childBuilder: appState.value.useRandomData
            ? CustomFontSizeAndColor.withRandomData
            : CustomFontSizeAndColor.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kLabelAlignmentAxisTitle,
        subtitle: kLabelAlignmentAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? MeasureAxisLabelAlignment.withRandomData
            : MeasureAxisLabelAlignment.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kNoAxisTitle,
        subtitle: kNoAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? HiddenTicksAndLabelsAxis.withRandomData
            : HiddenTicksAndLabelsAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kStaticallyProvidedTicksTitle,
        subtitle: kStaticallyProvidedTicksSubtitle,
        childBuilder: appState.value.useRandomData
            ? StaticallyProvidedTicks.withRandomData
            : StaticallyProvidedTicks.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kCustomFormatterTitle,
        subtitle: kCustomFormatterSubtitle,
        childBuilder: appState.value.useRandomData
            ? CustomAxisTickFormatters.withRandomData
            : CustomAxisTickFormatters.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kCustomTickCountTitle,
        subtitle: kCustomTickCountSubtitle,
        childBuilder: appState.value.useRandomData
            ? CustomMeasureTickCount.withRandomData
            : CustomMeasureTickCount.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kIntegerMeasureTicksTitle,
        subtitle: kIntegerMeasureTicksSubtitle,
        childBuilder: appState.value.useRandomData
            ? IntegerOnlyMeasureAxis.withRandomData
            : IntegerOnlyMeasureAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kNonZeroBoundAxisTitle,
        subtitle: kNonZeroBoundAxisSubtitle,
        childBuilder: appState.value.useRandomData
            ? NonzeroBoundMeasureAxis.withRandomData
            : NonzeroBoundMeasureAxis.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: kOrdinalAxisWithInitialViewportTitle,
        subtitle: kOrdinalAxisWithInitialViewportSubtitle,
        childBuilder: appState.value.useRandomData
            ? OrdinalInitialViewport.withRandomData
            : OrdinalInitialViewport.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kNumericAxisWithInitialViewportTitle,
        subtitle: kNumericAxisWithInitialViewportSubtitle,
        childBuilder: appState.value.useRandomData
            ? NumericInitialViewport.withRandomData
            : NumericInitialViewport.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kGridlineDashPatternTitle,
        subtitle: kGridlineDashPatternSubtitle,
        childBuilder: appState.value.useRandomData
            ? GridlineDashPattern.withRandomData
            : GridlineDashPattern.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: kDisjointMeasureAxesTitle,
        subtitle: kDisjointMeasureAxesSubtitle,
        childBuilder: appState.value.useRandomData
            ? DisjointMeasureAxisLineChart.withRandomData
            : DisjointMeasureAxisLineChart.withSampleData,
      ),
    ];
