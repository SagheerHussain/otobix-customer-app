import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeBannersWidget extends StatefulWidget {
  const HomeBannersWidget({
    super.key,
    required this.imageUrls,
    this.height,
    this.displayDuration = const Duration(seconds: 2),
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.onTap,
    this.cacheKey = 'default_banners',
  });

  final List<String> imageUrls;
  final double? height;
  final Duration displayDuration;
  final BorderRadius borderRadius;
  final void Function(int index)? onTap;

  final String cacheKey;

  @override
  State<HomeBannersWidget> createState() => _HomeBannersWidgetState();
}

class _HomeBannersWidgetState extends State<HomeBannersWidget> {
  static final Map<String, int> _virtualIndexCache = {};

  late final PageController _pageController;
  Timer? _timer;

  late int _virtualIndex;

  bool _isRouteCurrent() {
    final route = ModalRoute.of(context);
    // If route is null, treat as visible
    return route?.isCurrent ?? true;
  }

  @override
  void initState() {
    super.initState();

    final count = widget.imageUrls.length;
    final saved = _virtualIndexCache[widget.cacheKey];

    // Start from saved, else center
    _virtualIndex = saved ?? (count > 0 ? count * 1000 : 0);

    _pageController = PageController(initialPage: _virtualIndex);

    if (count > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.displayDuration, (_) {
      if (!mounted) return;
      if (widget.imageUrls.length <= 1) return;

      // ✅ THIS is the important fix:
      // don't advance pages while another screen is on top
      if (!_isRouteCurrent()) return;

      _virtualIndex++;
      _virtualIndexCache[widget.cacheKey] = _virtualIndex;

      _pageController.animateToPage(
        _virtualIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didUpdateWidget(covariant HomeBannersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrls.length != widget.imageUrls.length) {
      _timer?.cancel();

      final count = widget.imageUrls.length;
      _virtualIndex =
          _virtualIndexCache[widget.cacheKey] ?? (count > 0 ? count * 1000 : 0);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_virtualIndex); // instant
        }
      });

      if (count > 1) _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final realIndex = index % widget.imageUrls.length;
          final url = widget.imageUrls[realIndex];

          return GestureDetector(
            onTap: () => widget.onTap?.call(realIndex),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, _) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, _, __) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        onPageChanged: (i) {
          _virtualIndex = i;
          _virtualIndexCache[widget.cacheKey] = i;
        },
      ),
    );
  }
}

// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class HomeBannersWidget extends StatefulWidget {
//   const HomeBannersWidget({
//     super.key,
//     required this.imageUrls,
//     this.height,
//     this.displayDuration = const Duration(seconds: 2),
//     this.borderRadius = const BorderRadius.all(Radius.circular(0)),
//     this.onTap,
//   });

//   final List<String> imageUrls;
//   final double? height;
//   final Duration displayDuration;
//   final BorderRadius borderRadius;
//   final void Function(int index)? onTap;

//   @override
//   State<HomeBannersWidget> createState() => _HomeBannersWidgetState();
// }

// class _HomeBannersWidgetState extends State<HomeBannersWidget> {
//   late final PageController _pageController;
//   Timer? _timer;

//   // This is a "virtual" index for infinite scrolling
//   late int _virtualIndex;

//   @override
//   void initState() {
//     super.initState();

//     // Start somewhere far so we can keep going forward “forever”
//     final count = widget.imageUrls.length;
//     _virtualIndex = count > 0 ? count * 1000 : 0;

//     _pageController = PageController(initialPage: _virtualIndex);

//     if (count > 1) {
//       _startAutoScroll();
//     }
//   }

//   void _startAutoScroll() {
//     _timer?.cancel();
//     _timer = Timer.periodic(widget.displayDuration, (_) {
//       if (!mounted || widget.imageUrls.length <= 1) return;

//       _virtualIndex++;

//       _pageController.animateToPage(
//         _virtualIndex,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void didUpdateWidget(covariant HomeBannersWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // Restart timer if number of images changes
//     if (oldWidget.imageUrls.length != widget.imageUrls.length) {
//       _timer?.cancel();
//       if (widget.imageUrls.length > 1) {
//         _startAutoScroll();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.imageUrls.isEmpty) {
//       return SizedBox(height: widget.height);
//     }

//     return SizedBox(
//       height: widget.height,
//       width: double.infinity,
//       child: PageView.builder(
//         controller: _pageController,
//         // itemCount is null => infinite pages
//         itemBuilder: (context, index) {
//           final realIndex = index % widget.imageUrls.length;
//           final url = widget.imageUrls[realIndex];

//           return GestureDetector(
//             onTap: () => widget.onTap?.call(realIndex),
//             child: ClipRRect(
//               borderRadius: widget.borderRadius,
//               child: Center(
//                 child: CachedNetworkImage(
//                   imageUrl: url,
//                   fit: BoxFit.contain, // full image, no crop
//                   width: double.infinity,
//                   height: double.infinity,
//                   placeholder: (context, _) =>
//                       const Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, _, __) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
