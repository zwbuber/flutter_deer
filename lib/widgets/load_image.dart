import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageFormat { png, jpg, gif, webp }

// 图片加载（支持本地与网络图片）
class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.holderImg = 'none',
    this.cacheWidth,
    this.cacheHeight,
  });

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String holderImg;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image.startsWith('http')) {
      // 网络图片加载
      final Widget holder = LoadAssetImage(
        holderImg,
        width: width,
        height: height,
        fit: fit,
      );
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (_, _) => holder, // 加载中显示的占位图
        errorWidget: (_, __, dynamic error) => holder, // 加载失败显示的占位图
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth, // 内存缓存的宽度，默认为原图大小
        memCacheHeight: cacheHeight, // 内存缓存的高度，默认为原图大小
      );
    } else {
      // 本地图片加载
      return LoadAssetImage(image, width: width, height: height);
    }
  }
}

// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.cacheWidth,
    this.cacheHeight,
    this.format = ImageFormat.png,
    this.color,
  });

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final int? cacheWidth;
  final int? cacheHeight;
  final ImageFormat format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$image.${format.name.toLowerCase()}',
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}
