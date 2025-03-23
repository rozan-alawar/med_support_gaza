import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWithAnimatedShader extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const ImageWithAnimatedShader(
      {super.key, required this.imageUrl, this.width, this.height});

  @override
  _ImageWithAnimatedShaderState createState() =>
      _ImageWithAnimatedShaderState();
}

class _ImageWithAnimatedShaderState extends State<ImageWithAnimatedShader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      placeholder: (context, url) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
                stops: [
                  _controller.value * 0.5,
                  _controller.value,
                  _controller.value * 1.5,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
            ),
          );
        },
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
