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

import 'package:example/combo_chart/date_time_line_point.dart';
import 'package:example/combo_chart/numeric_line_bar.dart';
import 'package:example/combo_chart/numeric_line_point.dart';
import 'package:example/combo_chart/ordinal_bar_line.dart';
import 'package:example/combo_chart/scatter_plot_line.dart';
import 'package:example/gallery_scaffold.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

const ordinalComboChartTitle = 'Ordinal Combo Chart';
const ordinalComboChartSubtitle = 'Ordinal combo chart with bars and lines';

const numericComboLineBarChartTitle = 'Numeric Line Bar Combo Chart';
const numericComboLineBarChartSubtitle =
    'Numeric combo chart with lines and bars';

const numericComboLinePointChartTitle = 'Numeric Line Points Combo Chart';
const numericComboLinePointChartSubtitle =
    'Numeric combo chart with lines and points';

const dateTimeComboLinePointChartTitle = 'Time Series Combo Chart';
const dateTimeComboLinePointChartSubtitle =
    'Time series combo chart with lines and points';

const scatterPlotComboLineChartTitle = 'Scatter Plot Combo Chart';
const scatterPlotComboLineChartSubtitle =
    'Scatter plot combo chart with a line';

List<GalleryScaffold> buildGallery() => [
      GalleryScaffold(
        listTileIcon: const Icon(Icons.insert_chart),
        title: ordinalComboChartTitle,
        subtitle: ordinalComboChartSubtitle,
        childBuilder: appState.value.useRandomData
            ? OrdinalComboBarLineChart.withRandomData
            : OrdinalComboBarLineChart.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: numericComboLineBarChartTitle,
        subtitle: numericComboLineBarChartSubtitle,
        childBuilder: appState.value.useRandomData
            ? NumericComboLineBarChart.withRandomData
            : NumericComboLineBarChart.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: numericComboLinePointChartTitle,
        subtitle: numericComboLinePointChartSubtitle,
        childBuilder: appState.value.useRandomData
            ? NumericComboLinePointChart.withRandomData
            : NumericComboLinePointChart.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.show_chart),
        title: dateTimeComboLinePointChartTitle,
        subtitle: dateTimeComboLinePointChartSubtitle,
        childBuilder: appState.value.useRandomData
            ? DateTimeComboLinePointChart.withRandomData
            : DateTimeComboLinePointChart.withSampleData,
      ),
      GalleryScaffold(
        listTileIcon: const Icon(Icons.scatter_plot),
        title: scatterPlotComboLineChartTitle,
        subtitle: scatterPlotComboLineChartSubtitle,
        childBuilder: appState.value.useRandomData
            ? ScatterPlotComboLineChart.withRandomData
            : ScatterPlotComboLineChart.withSampleData,
      ),
    ];
