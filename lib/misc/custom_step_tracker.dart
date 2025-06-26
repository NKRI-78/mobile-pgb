import 'package:flutter/material.dart';

enum TrackerState {
  none,
  complete,
  disabled,
}

enum StepTrackerType {
  indexedVertical,
  dotVertical,
  indexedHorizontal,
}

class CustomStepTracker extends StatelessWidget {
  const CustomStepTracker({
    Key? key,
    required this.steps,
    this.dotSize = 9,
    this.circleSize = 24,
    this.pipeSize = 40.0, // made longer
    this.selectedColor = Colors.green,
    this.unSelectedColor = Colors.red,
    this.stepTrackerType = StepTrackerType.dotVertical,
  })  : assert(dotSize <= 20),
        assert(pipeSize >= 25),
        super(key: key);

  final List<Steps> steps;
  final double dotSize;
  final double circleSize;
  final double pipeSize;
  final Color selectedColor;
  final Color unSelectedColor;
  final StepTrackerType stepTrackerType;

  Color _circleColor(int index) {
    switch (steps[index].state) {
      case TrackerState.complete:
        return selectedColor;
      case TrackerState.disabled:
        return unSelectedColor;
      case TrackerState.none:
        return Colors.grey.withOpacity(0.5);
    }
  }

  Widget _buildDot(int index) {
    return Container(
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        color: _circleColor(index),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDotVerticalHeader(int index) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _buildDot(index),
                if (index != steps.length - 1)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: _circleColor(index),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  steps[index].title,
                  if (steps[index].description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        steps[index].description!,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildDotVertical() => Column(
        children: List.generate(
          steps.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == steps.length - 1 ? 0 : 12,
            ),
            child: _buildDotVerticalHeader(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    switch (stepTrackerType) {
      case StepTrackerType.dotVertical:
        return _buildDotVertical();
      case StepTrackerType.indexedVertical:
      case StepTrackerType.indexedHorizontal:
        return const SizedBox();
    }
  }
}

class Steps {
  const Steps({
    required this.title,
    this.state = TrackerState.none,
    this.description,
  });

  final Widget title;
  final TrackerState state;
  final String? description;
}
