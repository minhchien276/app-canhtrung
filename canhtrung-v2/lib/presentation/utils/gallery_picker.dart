// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';

Future<void> getImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final LostDataResponse response = await picker.retrieveLostData();
  if (response.isEmpty) {
    return;
  }
}

class PhotoPickerScrenn extends StatefulWidget {
  static const routeName = 'photo-picker-screen';
  const PhotoPickerScrenn({super.key});

  @override
  State<PhotoPickerScrenn> createState() => _PhotoPickerScrennState();
}

class _PhotoPickerScrennState extends State<PhotoPickerScrenn> {
  List<Medium> _images = [];
  List<Album>? _imageAlbums;
  Medium? _imageSelected;
  bool isMounted = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getAlbums();
      await getImages();
    });
    super.initState();
  }

  @override
  void dispose() {
    isMounted = false;
    super.dispose();
  }

  Future getAlbums() async {
    _imageAlbums = await PhotoGallery.listAlbums(mediumType: MediumType.image);
  }

  Future getImages() async {
    final res = await getMediaFromAlbum(_imageAlbums?.first);
    for (var e in res) {
      if (!isMounted) return;
      final tmp = await e.getFile();
      if (!tmp.path.split('.').contains('heic')) {
        if (!isMounted) return;
        setState(() {
          _images.add(e);
        });
      }
    }
  }

  Future<List<Medium>> getMediaFromAlbum(Album? album) async {
    return await album
            ?.listMedia(lightWeight: true)
            .then((value) => value.items) ??
        [];
  }

  getFilesToReturn(List<Medium> assets) async {
    List<Future<File>> fileFutures = assets.map((e) => e.getFile()).toList();
    List<File> files = await Future.wait(fileFutures);
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20.w,
          width: context.width,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4.h,
                width: 50.w,
                decoration: BoxDecoration(color: grey300),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: Container(color: whiteColor),
              ),
              AssetsGridView(
                assets: _images,
                onSelect: (value) {
                  setState(() {
                    _imageSelected = value;
                  });
                },
                iSelected: (value) {
                  return _imageSelected == value;
                },
              ),
              if (_imageSelected != null) ...[
                Positioned(
                  bottom: 40.h,
                  left: 24.w,
                  right: 24.w,
                  child: KSubmitButton(
                    size: Size(context.width, 50.h),
                    text: 'Xác nhận',
                    onTap: () async {
                      if (_imageSelected != null) {
                        final File image = await _imageSelected!.getFile();
                        if (!mounted) return;
                        context.pop(value: image);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AssetsGridView extends StatelessWidget {
  const AssetsGridView(
      {super.key, required this.assets, this.onSelect, this.iSelected});

  final List<Medium> assets;
  final Function(Medium)? onSelect;
  final bool Function(Medium)? iSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final Medium medium = assets[index];
        return assets.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : AssetTile(
                asset: medium,
                isSelected: iSelected?.call(medium),
                onSelect: (medium) {
                  onSelect?.call(medium);
                },
              );
      },
    );
  }
}

class AssetTile extends StatelessWidget {
  const AssetTile({
    super.key,
    required this.asset,
    this.onSelect,
    this.isSelected,
  });

  final Medium asset;
  final Function(Medium)? onSelect;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect?.call(asset);
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned.fill(
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder:
                  const NetworkImage('https://via.placeholder.com/56x56'),
              image: ThumbnailProvider(
                mediumId: asset.id,
                mediumType: asset.mediumType,
                highQuality: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onSelect?.call(asset);
            },
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Image.asset(
                (isSelected ?? false) ? IconApp.check : IconApp.uncheck,
                height: 24.r,
                width: 24.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
