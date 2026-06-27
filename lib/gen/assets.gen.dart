// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/png
  $AssetsImagesPngGen get png => const $AssetsImagesPngGen();

  /// Directory path: assets/images/svg
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();
}

class $AssetsLocalesGen {
  const $AssetsLocalesGen();

  /// File path: assets/locales/ar.json
  String get ar => 'assets/locales/ar.json';

  /// File path: assets/locales/en.json
  String get en => 'assets/locales/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class $AssetsImagesPngGen {
  const $AssetsImagesPngGen();

  /// File path: assets/images/png/green_mind_dark_png.png
  AssetGenImage get greenMindDarkPng =>
      const AssetGenImage('assets/images/png/green_mind_dark_png.png');

  /// File path: assets/images/png/green_mind_png.png
  AssetGenImage get greenMindPng =>
      const AssetGenImage('assets/images/png/green_mind_png.png');

  /// File path: assets/images/png/green_mind_white_png.png
  AssetGenImage get greenMindWhitePng =>
      const AssetGenImage('assets/images/png/green_mind_white_png.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    greenMindDarkPng,
    greenMindPng,
    greenMindWhitePng,
  ];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/green_mind_dark_svg.svg
  String get greenMindDarkSvg => 'assets/images/svg/green_mind_dark_svg.svg';

  /// File path: assets/images/svg/green_mind_svg.svg
  String get greenMindSvg => 'assets/images/svg/green_mind_svg.svg';

  /// File path: assets/images/svg/green_mind_white_svg.svg
  String get greenMindWhiteSvg => 'assets/images/svg/green_mind_white_svg.svg';

  /// List of all assets
  List<String> get values => [
    greenMindDarkSvg,
    greenMindSvg,
    greenMindWhiteSvg,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLocalesGen locales = $AssetsLocalesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
