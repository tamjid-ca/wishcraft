import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/occasion_model.dart';
import '../../../data/models/wish_card_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/wish_card_widget.dart';
import '../../widgets/common/error_snackbar.dart';
import '../../widgets/share/share_bottom_sheet.dart';

class CardPreviewScreen extends ConsumerStatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  ConsumerState<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends ConsumerState<CardPreviewScreen> {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final WishCardModel card = GoRouterState.of(context).extra as WishCardModel;
    final occasion = occasions.firstWhere(
      (o) => o.id == card.occasionId,
      orElse: () => occasions.last,
    );

    final state = ref.watch(previewViewModelProvider);
    final notifier = ref.read(previewViewModelProvider.notifier);

    ref.listen<PreviewState>(previewViewModelProvider, (_, current) {
      if (current.errorMessage != null) {
        ErrorSnackbar.show(context, current.errorMessage!);
        notifier.clearError();
      } else if (current.isSaved) {
        ErrorSnackbar.showSuccess(context, AppStrings.cardSaved);
      }
    });

    final isLoading = state.isSaving || state.isExporting;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.preview),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: WishCardWidget(
                      card: card,
                      occasionDisplayName: occasion.displayName,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : () => notifier.saveCard(card, _repaintKey),
                          icon: const Icon(Icons.cloud_upload),
                          label: Text(state.isSaving ? AppStrings.saving : AppStrings.saveToCloud),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : () => notifier.exportAsPng(_repaintKey, card.id),
                          icon: const Icon(Icons.image),
                          label: const Text(AppStrings.exportPng),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : () => notifier.exportAsPdf(_repaintKey, card.id),
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text(AppStrings.exportPdf),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => ShareBottomSheet(
                                  onShareWhatsApp: () => notifier.shareImage(_repaintKey, wishText: card.wishText),
                                  onShareTelegram: () => notifier.shareImage(_repaintKey, wishText: card.wishText),
                                  onShareMessenger: () => notifier.shareImage(_repaintKey, wishText: card.wishText),
                                  onSaveGallery: () => notifier.saveToGallery(_repaintKey),
                                  onMore: () => notifier.shareImage(_repaintKey, wishText: card.wishText),
                                ),
                              );
                            },
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text(AppStrings.shareSheet, style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
