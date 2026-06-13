import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/extension/app_extension.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';
import 'package:price_sense/app/core/widget/app_button.dart';
import 'package:price_sense/app/core/widget/central_app_bar.dart';
import 'package:price_sense/app/core/widget/custom_divider.dart';
import 'package:price_sense/app/core/widget/section_sub_title.dart';
import 'package:price_sense/app/core/widget/section_title.dart';
import 'package:price_sense/app/data/model/local/segment.dart';
import 'package:price_sense/app/modules/settings/controllers/settings_controller.dart';
import 'package:price_sense/app/modules/settings/views/widgets/color_tile.dart';
import 'package:price_sense/app/modules/settings/views/widgets/segment_tile.dart';
import 'package:price_sense/app/modules/settings/views/widgets/settings_card.dart';
import 'package:price_sense/app/modules/settings/views/widgets/switch_tile.dart';
import 'package:price_sense/l10n/app_localizations.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: CentralAppBar(
        titleWidgets: SectionHeader(label: l10n?.settings ?? ''),
        actions: [
          IconButton(
            icon: Icon(controller.themeMode == AppThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            tooltip: 'Toggle Theme',
            onPressed: () {
              controller.setThemeMode(controller.themeMode == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark);
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: context.colorScheme.surfaceContainerLow,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Appearance
          SectionSubTitle(
            label: l10n?.appearance ?? '',
            toUpperCase: true,
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          ),
          SettingsCard(
            children: [
              SegmentedTile(
                icon: Icons.palette_rounded,
                title: l10n?.theme ?? '',
                options: [
                  Segment(Icons.light_mode_rounded, l10n?.lightTheme ?? '', AppThemeMode.light),
                  Segment(Icons.settings_suggest_rounded, l10n?.systemTheme ?? '', AppThemeMode.system),
                  Segment(Icons.dark_mode_rounded, l10n?.darkTheme ?? '', AppThemeMode.dark),
                ],
                selected: controller.themeMode,
                onChanged: (v) => controller.setThemeMode(v as AppThemeMode),
              ),
              const CustomDivider(),
              SegmentedTile(
                icon: Icons.language_rounded,
                title: l10n?.language ?? '',
                options: [
                  Segment(Icons.abc, l10n?.english ?? '', const Locale('en')),
                  Segment(Icons.language, l10n?.bangla ?? '', const Locale('bn')),
                ],
                selected: controller.locale,
                onChanged: (v) => controller.setLocale(v as Locale),
              ),
              const CustomDivider(),
              SegmentedTile(
                icon: Icons.text_fields_rounded,
                title: l10n?.textSize ?? '',
                options: [
                  Segment(Icons.text_decrease_rounded, l10n?.small ?? '', TextSizeOption.small),
                  Segment(Icons.text_fields_rounded, l10n?.medium ?? '', TextSizeOption.medium),
                  Segment(Icons.text_increase_rounded, l10n?.large ?? '', TextSizeOption.large),
                ],
                selected: controller.textSize,
                onChanged: (v) => controller.setTextSize(v as TextSizeOption),
              ),
              const CustomDivider(),
              ColorTile(
                icon: Icons.color_lens_rounded,
                title: l10n?.primaryColor ?? '',
                subtitle: l10n?.tapToChange ?? '',
                color: controller.primaryColor,
                onTap: () => _showColorPicker(context, l10n),
              ),
            ],
          ),

          // General
          SectionSubTitle(
            label: l10n?.general ?? '',
            toUpperCase: true,
            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          ),
          SettingsCard(
            children: [
              SwitchTile(
                icon: Icons.notifications_rounded,
                title: l10n?.notifications ?? '',
                subtitle: l10n?.notificationsSubtitle ?? '',
                value: controller.notifications,
                onChanged: controller.setNotifications,
              ),
              const CustomDivider(),
              SwitchTile(
                icon: Icons.volume_up_rounded,
                title: l10n?.sound ?? '',
                subtitle: l10n?.soundSubtitle ?? '',
                value: controller.sound,
                onChanged: controller.setSound,
              ),
              const CustomDivider(),
              SwitchTile(
                icon: Icons.vibration_rounded,
                title: l10n?.vibration ?? '',
                subtitle: l10n?.vibrationSubtitle ?? '',
                value: controller.vibration,
                onChanged: controller.setVibration,
              ),
            ],
          ),

          // Privacy
          SectionSubTitle(
            label: l10n?.privacy ?? '',
            toUpperCase: true,
            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          ),
          SettingsCard(
            children: [
              SwitchTile(icon: Icons.fingerprint_rounded, title: l10n?.biometric ?? '', subtitle: l10n?.biometricSubtitle ?? '', value: controller.biometric, onChanged: controller.setBiometric),
              const CustomDivider(),
              SwitchTile(icon: Icons.lock_clock_rounded, title: l10n?.autoLock ?? '', subtitle: l10n?.autoLockSubtitle ?? '', value: controller.autoLock, onChanged: controller.setAutoLock),
            ],
          ),

          // About
          SectionSubTitle(
            label: l10n?.about ?? '',
            toUpperCase: true,
            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          ),
          SettingsCard(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 20),
                ),
                title: Text(l10n?.version ?? ''),
                trailing: Chip(label: const Text('1.0.0'), backgroundColor: Theme.of(context).colorScheme.secondaryContainer, side: BorderSide.none),
              ),
            ],
          ),

          // Reset
          const SizedBox(height: 8),
          AppButton(
            backgroundColor: context.colorScheme.surface,
            titleWidget: SectionSubTitle(label: l10n?.reset ?? '', textColor: AppColors.primary),
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  icon: const Icon(Icons.restore_rounded),
                  title: Text(l10n?.resetSettings ?? ''),
                  content: Text(l10n?.resetConfirm ?? ''),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n?.cancel ?? '')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
                      onPressed: () {
                        controller.resetToDefaults();
                        Navigator.pop(ctx, true);
                      },
                      child: Text(l10n?.reset ?? ''),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<void> _showColorPicker(BuildContext context, AppLocalizations? l10n) async {
    Color picked = controller.primaryColor;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.pickColor ?? ''),
        content: SingleChildScrollView(
          child: ColorPicker(
            color: picked,
            onColorChanged: (c) => picked = c,
            heading: Text(l10n?.pickColor ?? '', style: Theme.of(ctx).textTheme.titleSmall),
            subheading: Text('Select shade', style: Theme.of(ctx).textTheme.bodySmall),
            wheelSubheading: Text('Wheel', style: Theme.of(ctx).textTheme.bodySmall),
            showColorCode: true,
            colorCodeHasColor: true,
            pickersEnabled: const {ColorPickerType.primary: true, ColorPickerType.accent: true, ColorPickerType.wheel: true},
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n?.cancel ?? '')),
          FilledButton(
            onPressed: () {
              controller.setPrimaryColor(picked);
              Navigator.pop(ctx);
            },
            child: Text(l10n?.done ?? ''),
          ),
        ],
      ),
    );
  }
}
