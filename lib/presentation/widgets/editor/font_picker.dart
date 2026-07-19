import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';

class FontPicker extends StatefulWidget {
  final String selectedFontFamily;
  final ValueChanged<String> onSelect;

  const FontPicker({
    super.key,
    required this.selectedFontFamily,
    required this.onSelect,
  });

  @override
  State<FontPicker> createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  String _selectedCategory = 'Serif';

  static const Map<String, List<String>> groupedFonts = {
    'Serif': [
      'Playfair Display',
      'Cormorant Garamond',
      'Lora',
      'Merriweather',
      'EB Garamond',
    ],
    'Sans-serif': [
      'Poppins',
      'Inter',
      'Nunito',
      'Montserrat',
      'Raleway',
      'Open Sans',
      'Roboto',
    ],
    'Handwriting': [
      'Dancing Script',
      'Pacifico',
      'Sacramento',
      'Great Vibes',
      'Satisfy',
      'Caveat',
    ],
    'Display': [
      'Lobster',
      'Abril Fatface',
      'Righteous',
      'Oswald',
      'Cinzel',
      'Exo 2',
      'Bebas Neue',
    ],
  };

  @override
  void initState() {
    super.initState();
    // Auto-select category of current font
    for (final entry in groupedFonts.entries) {
      if (entry.value.contains(widget.selectedFontFamily)) {
        _selectedCategory = entry.key;
        break;
      }
    }
  }

  @override
  void didUpdateWidget(covariant FontPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFontFamily != widget.selectedFontFamily) {
      for (final entry in groupedFonts.entries) {
        if (entry.value.contains(widget.selectedFontFamily)) {
          setState(() {
            _selectedCategory = entry.key;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fonts = groupedFonts[_selectedCategory] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category selector
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: groupedFonts.keys.map((category) {
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Fonts list with live preview
        SizedBox(
          height: 55,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: fonts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final font = fonts[idx];
              final isSelected = font == widget.selectedFontFamily;
              return ChoiceChip(
                label: Text(
                  font,
                  style: AppTextStyles.getFont(
                    font,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                selected: isSelected,
                selectedColor: Theme.of(context).primaryColor,
                onSelected: (_) => widget.onSelect(font),
              );
            },
          ),
        ),
      ],
    );
  }
}
