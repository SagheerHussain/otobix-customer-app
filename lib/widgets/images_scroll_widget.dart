import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';

class ImagesScrollWidget extends StatefulWidget {
  final List<String> imageUrls;
  final List<VoidCallback> onTaps;
  final double height;
  final double width;
  final BoxFit fit;
  final double spacing;
  final Duration scrollDuration;

  const ImagesScrollWidget({
    super.key,
    required this.imageUrls,
    required this.onTaps,
    this.height = 120,
    this.width = 160,
    this.fit = BoxFit.cover,
    this.spacing = 12,
    this.scrollDuration = const Duration(
      milliseconds: 15000,
    ), // 15 seconds for full loop
  }) : assert(imageUrls.length == onTaps.length);

  @override
  State<ImagesScrollWidget> createState() => _ImagesScrollWidgetState();
}

class _ImagesScrollWidgetState extends State<ImagesScrollWidget> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final itemWidth = widget.width + widget.spacing;

        _scrollOffset +=
            itemWidth / (widget.scrollDuration.inMilliseconds / 16);

        if (_scrollOffset >= maxScroll) {
          _scrollOffset = 0.0;
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(_scrollOffset);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a list that's 3x the original for smooth looping
    final extendedUrls = List.generate(
      10,
      (index) => widget.imageUrls,
    ).expand((x) => x).toList();
    final extendedTaps = List.generate(
      10,
      (index) => widget.onTaps,
    ).expand((x) => x).toList();

    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: extendedUrls.length,
        separatorBuilder: (context, index) =>
            VerticalDivider(color: AppColors.grey, width: 1),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: extendedTaps[index],
            child: SizedBox(
              width: widget.width,
              child: Image.asset(
                extendedUrls[index],
                fit: widget.fit,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
