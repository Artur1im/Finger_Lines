import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Line {
  final Offset start;
  final Offset end;

  Line(this.start, this.end);
}

final linesProvider =
    StateNotifierProvider<LinesNotifier, List<Line>>((ref) => LinesNotifier());

class LinesNotifier extends StateNotifier<List<Line>> {
  LinesNotifier() : super([]);

  final List<List<Line>> _history = [];
  int _currentHistoryIndex = -1;

  void addLine(Line line) {
    _history.add([...state]);
    _currentHistoryIndex = _history.length - 1;
    state = [...state, line];
  }

  void clearLines() {
    _history.add([...state]);
    _currentHistoryIndex = _history.length - 1;
    state = [];
  }

  void removeLastLine() {
    if (state.isNotEmpty) {
      _history.add([...state]);
      _currentHistoryIndex = _history.length - 1;
      state = state.sublist(0, state.length - 1);
    }
  }

  void redo() {
    if (_currentHistoryIndex < _history.length - 1) {
      _currentHistoryIndex++;
      state = [..._history[_currentHistoryIndex]];
    }
  }

  void undo() {
    if (_currentHistoryIndex > 0) {
      _currentHistoryIndex--;
      state = [..._history[_currentHistoryIndex]];
    }
  }

  bool linesIntersect(Offset a1, Offset a2, Offset b1, Offset b2) {
    double x1 = a1.dx, y1 = a1.dy, x2 = a2.dx, y2 = a2.dy;
    double x3 = b1.dx, y3 = b1.dy, x4 = b2.dx, y4 = b2.dy;

    double d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (d == 0) return false;

    double pre = (x1 * y2 - y1 * x2), post = (x3 * y4 - y3 * x4);
    double intersectionX = (pre * (x3 - x4) - (x1 - x2) * post) / d;
    double intersectionY = (pre * (y3 - y4) - (y1 - y2) * post) / d;

    if (!(intersectionX >= min(x1, x2) &&
        intersectionX <= max(x1, x2) &&
        intersectionX >= min(x3, x4) &&
        intersectionX <= max(x3, x4))) return false;
    if (!(intersectionY >= min(y1, y2) &&
        intersectionY <= max(y1, y2) &&
        intersectionY >= min(y3, y4) &&
        intersectionY <= max(y3, y4))) return false;
    return true;
  }
}
