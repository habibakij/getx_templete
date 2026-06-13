import 'package:flutter/material.dart';
import 'package:price_sense/app/core/widget/regular_text.dart';
import 'package:price_sense/app/core/widget/section_sub_title.dart';
import 'package:price_sense/app/data/model/local/segment.dart';
import 'package:price_sense/app/modules/settings/views/widgets/icon_box.dart';

class SegmentedTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Segment> options;
  final Object selected;
  final ValueChanged<Object> onChanged;

  const SegmentedTile({super.key, required this.icon, required this.title, required this.options, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      titleAlignment: ListTileTitleAlignment.bottom,
      contentPadding: EdgeInsets.zero,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: DecoratedIcon(icon: icon),
      ),
      title: SectionSubTitle(label: title),
      subtitle: SegmentedButton<Object>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          side: BorderSide(color: scheme.outlineVariant),
        ),
        segments: options
            .map(
              (segment) => ButtonSegment<Object>(
                value: segment.value,
                label: RegularText(label: segment.label),
                icon: Icon(segment.icon, size: 12.0),
              ),
            )
            .toList(),
        selected: {selected},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}
