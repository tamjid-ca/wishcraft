import 'package:flutter/material.dart';
import 'wc_app_bar.dart';

/// A convenience wrapper around [Scaffold] that automatically applies
/// [WcAppBar] when a [title] is provided, keeping all screens consistent.
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final bool useSafeArea;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: title != null
          ? WcAppBar(
              title: title!,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            )
          : null,
      body: useSafeArea ? SafeArea(child: body) : body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
