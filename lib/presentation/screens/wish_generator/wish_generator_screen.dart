import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/occasion_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/common/error_snackbar.dart';
import '../../widgets/wish/wish_variants_list.dart';

class WishGeneratorScreen extends ConsumerStatefulWidget {
  final String occasionId;

  const WishGeneratorScreen({super.key, required this.occasionId});

  @override
  ConsumerState<WishGeneratorScreen> createState() => _WishGeneratorScreenState();
}

class _WishGeneratorScreenState extends ConsumerState<WishGeneratorScreen> {
  final _recipientController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _relationships = [
    'Mom', 'Dad', 'Friend', 'Wife', 'Husband', 'Child', 'Boss', 'Custom'
  ];

  final List<String> _tones = [
    'Heartfelt', 'Funny', 'Formal', 'Poetic'
  ];

  @override
  void dispose() {
    _recipientController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final occasion = occasions.firstWhere(
      (o) => o.id == widget.occasionId,
      orElse: () => occasions.last,
    );

    final state = ref.watch(wishGeneratorViewModelProvider(widget.occasionId));
    final notifier = ref.read(wishGeneratorViewModelProvider(widget.occasionId).notifier);

    ref.listen<AsyncValue>(
      wishGeneratorViewModelProvider(widget.occasionId).select((s) => s.wishVariants),
      (_, next) {
        if (next is AsyncError) {
          ErrorSnackbar.show(context, next.error.toString());
        }
      },
    );

    final isLoading = state.wishVariants is AsyncLoading;
    final wishes = state.wishVariants.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishes for ${occasion.displayName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: AppStrings.recipientName,
                  hintText: AppStrings.recipientNameHint,
                ),
                onChanged: notifier.setRecipientName,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter recipient name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: state.relationship,
                decoration: const InputDecoration(labelText: AppStrings.relationship),
                items: _relationships.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (v) {
                  if (v != null) notifier.setRelationship(v);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: AppStrings.personalNote,
                  hintText: AppStrings.personalNoteHint,
                ),
                onChanged: notifier.setPersonalNote,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.tone,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _tones.map((t) {
                  final isSelected = state.tone == t;
                  return ChoiceChip(
                    label: Text(t),
                    selected: isSelected,
                    onSelected: (_) => notifier.setTone(t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(AppStrings.generating),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      notifier.generateWishes();
                    }
                  },
                  child: const Text(AppStrings.generateWishes),
                ),
              const SizedBox(height: 24),
              if (wishes.isNotEmpty) ...[
                const Text(
                  'Select a message variant:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                WishVariantsList(
                  variants: wishes,
                  selectedIndex: state.selectedIndex,
                  onSelect: notifier.selectVariant,
                  onRegenerate: notifier.regenerateVariant,
                  onEdit: notifier.editVariantText,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.selectedIndex == null
                      ? null
                      : () {
                          // Pass state setup to card editor
                          ref.read(cardEditorViewModelProvider.notifier).initFromCard(
                                senderName: '',
                                showBorder: false,
                              );
                          context.push('/card-editor', extra: widget.occasionId);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(AppStrings.nextCustomize),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
