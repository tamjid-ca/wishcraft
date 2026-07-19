import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/occasion_model.dart';
import '../../../data/models/wish_card_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/wish_card_widget.dart';
import '../../widgets/cards/card_template_selector.dart';
import '../../widgets/editor/text_editor_panel.dart';
import '../../widgets/editor/sticker_overlay_picker.dart';
import '../../widgets/editor/layout_picker.dart';

class CardEditorScreen extends ConsumerStatefulWidget {
  const CardEditorScreen({super.key});

  @override
  ConsumerState<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends ConsumerState<CardEditorScreen> {
  final _senderController = TextEditingController();

  @override
  void dispose() {
    _senderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If extra is string, it's the occasionId. If it's a WishCardModel, it's edit mode.
    final extra = GoRouterState.of(context).extra;
    final String occasionId = extra is WishCardModel ? extra.occasionId : (extra as String? ?? 'custom');
    final WishCardModel? editingCard = extra is WishCardModel ? extra : null;

    final occasion = occasions.firstWhere(
      (o) => o.id == occasionId,
      orElse: () => occasions.last,
    );

    final state = ref.watch(cardEditorViewModelProvider);
    final notifier = ref.read(cardEditorViewModelProvider.notifier);

    // Grab selected variant text from WishGenerator state if not edit mode
    final wishGenState = ref.watch(wishGeneratorViewModelProvider(occasionId));
    final String wishText = editingCard?.wishText ?? wishGenState.selectedVariant?.text ?? '';
    final String recipientName = editingCard?.recipientName ?? wishGenState.recipientName;

    // Temporary model representing the card design preview
    final cardPreview = WishCardModel(
      id: editingCard?.id ?? const Uuid().v4(),
      occasionId: occasionId,
      recipientName: state.showRecipientName ? recipientName : '',
      senderName: state.senderName,
      wishText: wishText,
      templateId: state.selectedTemplateId,
      fontFamily: state.fontFamily,
      fontSize: state.fontSize,
      textColor: state.textColor,
      stickerIds: state.appliedStickerIds,
      showBorder: state.showBorder,
      cardLayout: state.cardLayout,
      thumbnailBase64: state.thumbnailBase64,
      createdAt: editingCard?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cardEditor),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: notifier.canUndo ? notifier.undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: notifier.canRedo ? notifier.redo : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: WishCardWidget(
                    card: cardPreview,
                    occasionDisplayName: occasion.displayName,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: AppStrings.templates),
                        Tab(text: AppStrings.text),
                        Tab(text: AppStrings.stickers),
                        Tab(text: AppStrings.layout),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Templates
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CardTemplateSelector(
                                templateIds: occasion.templateIds,
                                selectedId: state.selectedTemplateId,
                                occasionId: occasionId,
                                onSelect: notifier.selectTemplate,
                              ),
                            ],
                          ),
                          // Text settings
                          SingleChildScrollView(
                            child: TextEditorPanel(
                              selectedFontFamily: state.fontFamily,
                              selectedFontSize: state.fontSize,
                              selectedColorValue: state.textColor,
                              onFontSelect: notifier.setFont,
                              onFontSizeChange: notifier.setFontSize,
                              onColorSelect: notifier.setTextColor,
                            ),
                          ),
                          // Stickers list
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => StickerOverlayPicker(
                                    onSelectSticker: notifier.addSticker,
                                  ),
                                );
                              },
                              child: const Text('Add Sticker Overlay'),
                            ),
                          ),
                          // Layout configurations
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                LayoutPicker(
                                  selectedLayout: state.cardLayout,
                                  onSelect: notifier.setLayout,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _senderController,
                                  decoration: const InputDecoration(
                                    labelText: 'Sender Name',
                                    hintText: 'e.g. Your name',
                                  ),
                                  onChanged: notifier.setSenderName,
                                ),
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  title: const Text('Show Border Frame'),
                                  value: state.showBorder,
                                  onChanged: (_) => notifier.toggleBorder(),
                                ),
                                SwitchListTile(
                                  title: const Text('Show Recipient Name'),
                                  value: state.showRecipientName,
                                  onChanged: (_) => notifier.toggleRecipientName(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              context.push('/preview', extra: cardPreview);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text(AppStrings.previewShare),
          ),
        ),
      ),
    );
  }
}
