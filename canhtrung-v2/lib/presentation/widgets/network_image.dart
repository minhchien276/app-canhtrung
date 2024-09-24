import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';

Widget networkImageWithCached({
  required Size size,
  required String? url,
  File? file,
  double? borderRadius,
  BoxBorder? boxBorder,
  Widget? placeholder,
  VoidCallback? onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: boxBorder,
      borderRadius: BorderRadius.circular(1000), // Bo góc của ClipRRect
    ),
    child: GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 24),
        child: Container(
            height: size.height,
            width: size.width,
            color: whiteColor,
            child: file != null
                ? Image.file(file, fit: BoxFit.cover)
                : url != null && url != ''
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: rose300,
                          ),
                        ),
                        errorWidget: (context, _, __) {
                          return placeholder ?? defaultImage(size);
                        },
                      )
                    : placeholder ?? defaultImage(size)),
      ),
    ),
  );
}

Widget defaultImage(Size size) => Container(
      height: size.height,
      width: size.width,
      color: Colors.grey[300],
      child: Image.asset(
        'assets/images/placeholder_image.png',
        color: whiteColor,
        scale: 2,
      ),
    );

Widget defaultAvatar(Size size, {File? file}) => Container(
      height: size.height,
      width: size.width,
      color: rose100,
      child: file != null
          ? Image.file(file, fit: BoxFit.cover)
          : Image.asset(
              Imgs.avatar,
            ),
    );
