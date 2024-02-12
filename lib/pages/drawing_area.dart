import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/pages/line.dart';
import 'package:todo_app/pages/points.dart';
import 'drawing_painter.dart';

class DrawingArea extends ConsumerWidget {
  const DrawingArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsProvider);
    final lines = ref.watch(linesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(15)),
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () => ref.read(linesProvider.notifier).undo(),
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                onPressed: () => ref.read(linesProvider.notifier).redo(),
                icon: const Icon(Icons.redo),
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final Offset localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              if (localPosition.dx >= 0 && localPosition.dy >= 0) {
                ref.read(pointsProvider.notifier).addPoint(localPosition);
              }
            },
            onPanEnd: (details) {
              if (points.isNotEmpty) {
                final lastPoint = points.last;
                if (lines.isNotEmpty) {
                  final firstPoint = points.first;
                  final lastLine = lines.last;
                  if (lastPoint != firstPoint &&
                      !ref.read(linesProvider.notifier).linesIntersect(
                          lastLine.start,
                          lastLine.end,
                          firstPoint,
                          lastPoint)) {
                    ref
                        .read(linesProvider.notifier)
                        .addLine(Line(firstPoint, lastPoint));
                  }
                } else {
                  ref
                      .read(linesProvider.notifier)
                      .addLine(Line(points.first, lastPoint));
                }
                ref.read(pointsProvider.notifier).clearPoints();
              }
            },
            child: CustomPaint(
              painter: DrawingPainter(
                  points: points, lines: lines, context: context),
              size: Size.infinite,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Нажмите на любую точку экрана, чтобы построить угол'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () => ref.read(linesProvider.notifier).undo(),
                  child: const Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        Text('Отменить дейстиве'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
