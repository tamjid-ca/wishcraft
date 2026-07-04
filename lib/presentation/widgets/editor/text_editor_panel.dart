import 'package:flutter/material.dart';
import 'font_picker.dart';
import 'color_palette_picker.dart';

class TextEditorPanel extends StatelessWidget {
  final String selectedFontFamily;
  final double selectedFontSize;
  final int selectedColorValue;
  final ValueChanged<String> onFontSelect;
  final ValueChanged<double> onFontSizeChange;
  final ValueChanged<Color> onColorSelect;

  const TextEditorPanel({
    super.key,
    required this.selectedFontFamily,
    required this.selectedFontSize,
    required this.selectedColorValue,
    required this.onFontSelect,
    required this.onFontSizeChange,
    required this.onColorSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Font Style', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        FontPicker(
          selectedFontFamily: selectedFontFamily,
          onSelect: onFontSelect,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text('Font Size', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Slider(
          value: selectedFontSize,
          min: 12,
          max: 36,
          divisions: 12,
          label: selectedFontSize.round().toString(),
          onChanged: onFontSizeChange,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ColorPalettePicker(
          selectedColorValue: selectedColorValue,
          onSelect: onColorSelect,
        ),
      ],
    );
  }
}
