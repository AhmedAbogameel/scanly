import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'package:request_permission/request_permission.dart';
import 'package:scan/scan.dart';
import 'dart:developer';

abstract class ScanlyImageManager {
  /// Get the recent 20 image from storage
  static Future<List<ImageModel>> getRecentImages() async {
    final recentAssetEntity = await getRecentAssetEntity();
    int length = recentAssetEntity.length;
    List<ImageModel> images = [];
    for (int i = 0; i < length; i++) {
      final assetEntity = recentAssetEntity[i];
      final file = await assetEntity.file;
      images.add(ImageModel(type: Type.image, file: file!));
    }
    return images;
  }

  /// TO get File from AssetEntity
  /// Iterate on the result then call [await element.file]
  /// element is every item in result
  static Future<List<AssetEntity>> getRecentAssetEntity() async {
    final isGranted = await checkForPermission();
    if (!isGranted) {
      log("Scanly : Permission is not granted!");
      throw UnimplementedError("Permission is not granted!");
    }
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    final List<AssetEntity> entities = await paths.first.getAssetListPaged(page: 0, size: 20);
    return entities;
  }

  static Future<bool> checkForPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    await RequestPermission.instace.requestAndroidPermission("android.permission.CAMERA");
    return _ps.isAuth;
  }

  static Future<String?> scan(String imgPath) async {
    return await Scan.parse(imgPath);
  }
}

enum Type {image, gallery}

class ImageModel {
  final Type? type;
  final File? file;
  const ImageModel({this.type, this.file});
}
