import 'package:flutter/material.dart';

/// 스켈레톤 로딩 위젯
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // 위젯이 화면에 보일 때 애니메이션 시작 (첫 프레임 이후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_controller.isAnimating) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = widget.baseColor ??
        (isDark ? Colors.grey.shade800 : Colors.grey.shade300);
    final highlightColor = widget.highlightColor ??
        (isDark ? Colors.grey.shade700 : Colors.grey.shade200);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 추천 카드 스켈레톤
class RecommendationCardSkeleton extends StatelessWidget {
  final bool isDark;

  const RecommendationCardSkeleton({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                ]
              : [
                  Colors.white,
                  Colors.orange.shade50,
                ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이모지 스켈레톤
          SkeletonLoader(
            width: 140,
            height: 140,
            borderRadius: BorderRadius.circular(70),
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          ),
          const SizedBox(height: 32),
          // 제목 스켈레톤
          SkeletonLoader(
            width: 200,
            height: 36,
            borderRadius: BorderRadius.circular(8),
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          ),
          const SizedBox(height: 24),
          // 설명 스켈레톤
          SkeletonLoader(
            width: double.infinity,
            height: 16,
            borderRadius: BorderRadius.circular(8),
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          ),
          const SizedBox(height: 12),
          SkeletonLoader(
            width: double.infinity,
            height: 16,
            borderRadius: BorderRadius.circular(8),
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          ),
          const SizedBox(height: 12),
          SkeletonLoader(
            width: 150,
            height: 16,
            borderRadius: BorderRadius.circular(8),
            baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
          ),
        ],
      ),
    );
  }
}

