import 'package:flutter/material.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class CentralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final Widget? title;
  final Widget? titleWidgets;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double elevation;

  const CentralAppBar({
    super.key,
    this.backgroundColor = AppColors.primary,
    this.title,
    this.titleWidgets,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.bottom,
    this.elevation = 0,
  }) : assert(
          title != null || titleWidgets != null,
          'Either title or titleWidgets must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      title: titleWidgets,
      leading: leading,
      actions: actions?.isNotEmpty == true ? actions : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
