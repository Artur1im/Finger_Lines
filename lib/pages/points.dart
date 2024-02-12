import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pointsProvider = StateNotifierProvider<PointsNotifier, List<Offset>>(
    (ref) => PointsNotifier());

class PointsNotifier extends StateNotifier<List<Offset>> {
  PointsNotifier() : super([]);

  void addPoint(Offset point) {
    state = [...state, point];
  }

  void clearPoints() {
    state = [];
  }

  void removeLastPoint() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }
}
