import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());
}
