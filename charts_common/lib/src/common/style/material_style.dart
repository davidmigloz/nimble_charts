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

import 'package:nimble_charts_common/src/chart/cartesian/axis/spec/axis_spec.dart'
    show LineStyleSpec;
import 'package:nimble_charts_common/src/common/color.dart' show Color;
import 'package:nimble_charts_common/src/common/graphics_factory.dart'
    show GraphicsFactory;
import 'package:nimble_charts_common/src/common/line_style.dart' show LineStyle;
import 'package:nimble_charts_common/src/common/material_palette.dart'
    show MaterialGray, MaterialPalette;
import 'package:nimble_charts_common/src/common/palette.dart' show Palette;
import 'package:nimble_charts_common/src/common/style/style.dart' show Style;

class MaterialStyle implements Style {
  const MaterialStyle();

  @override
  Color get black => MaterialPalette.black;

  @override
  Color get transparent => MaterialPalette.transparent;

  @override
  Color get white => MaterialPalette.white;

  @override
  List<Palette> getOrderedPalettes(int count) =>
      MaterialPalette.getOrderedPalettes(count);

  @override
  LineStyle createAxisLineStyle(
    GraphicsFactory graphicsFactory,
    LineStyleSpec? spec,
  ) =>
      graphicsFactory.createLinePaint()
        ..color = spec?.color ?? MaterialPalette.gray.shadeDefault
        ..dashPattern = spec?.dashPattern
        ..strokeWidth = spec?.thickness ?? 1;

  @override
  LineStyle createTickLineStyle(
    GraphicsFactory graphicsFactory,
    LineStyleSpec? spec,
  ) =>
      graphicsFactory.createLinePaint()
        ..color = spec?.color ?? MaterialPalette.gray.shadeDefault
        ..dashPattern = spec?.dashPattern
        ..strokeWidth = spec?.thickness ?? 1;

  @override
  int get tickLength => 3;

  @override
  Color get tickColor => (MaterialPalette.gray as MaterialGray).shade800;

  @override
  LineStyle createGridlineStyle(
    GraphicsFactory graphicsFactory,
    LineStyleSpec? spec,
  ) =>
      graphicsFactory.createLinePaint()
        ..color = spec?.color ?? (MaterialPalette.gray as MaterialGray).shade300
        ..dashPattern = spec?.dashPattern
        ..strokeWidth = spec?.thickness ?? 1;

  @override
  Color get arcLabelOutsideLeaderLine =>
      (MaterialPalette.gray as MaterialGray).shade600;

  @override
  Color get defaultSeriesColor => MaterialPalette.gray.shadeDefault;

  @override
  Color get arcStrokeColor => MaterialPalette.white;

  @override
  Color get legendEntryTextColor =>
      (MaterialPalette.gray as MaterialGray).shade800;

  @override
  Color get legendTitleTextColor =>
      (MaterialPalette.gray as MaterialGray).shade800;

  @override
  Color get linePointHighlighterColor =>
      (MaterialPalette.gray as MaterialGray).shade600;

  @override
  Color get noDataColor =>
      (MaterialPalette.gray as MaterialGray).shade200;

  @override
  Color get rangeAnnotationColor =>
      (MaterialPalette.gray as MaterialGray).shade100;

  @override
  Color get sliderFillColor => MaterialPalette.white;

  @override
  Color get sliderStrokeColor =>
      (MaterialPalette.gray as MaterialGray).shade600;

  @override
  Color get chartBackgroundColor => MaterialPalette.white;

  @override
  double get rangeBandSize => 0.65;
}
