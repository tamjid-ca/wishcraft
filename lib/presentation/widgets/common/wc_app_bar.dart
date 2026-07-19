import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A shared, themed AppBar used consistently across all WishCraft screens.
///
/// Automatically adapts to the current [ThemeMode] via [Theme.of(context)].
/// Optionally shows a gradient bottom border with [showGradientBorder].
class WcAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool showGradientBorder;

  const WcAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.showGradientBorder = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (showGradientBorder ? 2.0 : 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: cs.primary.withValues(alpha: 0.05),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      bottom: showGradientBorder
          ? PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
            )
          : null,
    );
  }
}
