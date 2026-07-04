import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/occasion_model.dart';

class OccasionState extends Equatable {
  final List<OccasionModel> occasions;
  final String searchQuery;

  const OccasionState({
    this.occasions = const [],
    this.searchQuery = '',
  });

  List<OccasionModel> get filtered {
    if (searchQuery.isEmpty) return occasions;
    return occasions
        .where((o) =>
            o.displayName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            o.emoji.contains(searchQuery))
        .toList();
  }

  OccasionState copyWith({
    List<OccasionModel>? occasions,
    String? searchQuery,
  }) {
    return OccasionState(
      occasions: occasions ?? this.occasions,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [occasions, searchQuery];
}

class OccasionViewModel extends StateNotifier<OccasionState> {
  OccasionViewModel() : super(const OccasionState(occasions: occasions));

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }
}
