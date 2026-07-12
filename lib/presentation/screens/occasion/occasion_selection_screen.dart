import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../widgets/occasion/occasion_grid.dart';

class OccasionSelectionScreen extends ConsumerWidget {
  const OccasionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(occasionViewModelProvider);
    final notifier = ref.read(occasionViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.selectOccasion),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: notifier.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchOccasions,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: notifier.clearSearch,
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: OccasionGrid(
              occasions: state.filtered,
              onTap: (occasion) {
                context.push('/wish-generator/${occasion.id}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
