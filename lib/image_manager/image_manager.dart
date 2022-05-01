import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

abstract class ScanlyImageManager {

  static Future<List<File?>> getRecentImages() async {
    final recentAssetEntity = await getRecentAssetEntity();
    int length = recentAssetEntity.length;
    List<File?> images = [];
    for (int i = 0; i < length; i++) {
      final assetEntity = recentAssetEntity[i];
      final file = await assetEntity.file;
      images.add(file);
    }
    return images;
  }

  /// TO get File from AssetEntity
  /// Iterate on the result then call [await element.file]
  /// element is every item in result
  static Future<List<AssetEntity>> getRecentAssetEntity() async {
    final isGranted = await checkForPermission();
    if (!isGranted) {
      throw UnimplementedError("Permission is not granted!");
    }
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    final List<AssetEntity> entities = await paths.first.getAssetListPaged(page: 0, size: 20);
    return entities;
  }

  static Future<bool> checkForPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    return _ps.isAuth;
  }
}