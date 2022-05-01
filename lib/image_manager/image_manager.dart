import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class ImageManager {
  Future<List<File>> getLatestImages() async {
    final isGranted = await checkForPermission();
    if (!isGranted) {
      throw UnimplementedError("Permission is not granted!");
    }
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    final List<AssetEntity> entities = await paths.first.getAssetListPaged(page: 0, size: 80);
    return entities.map((e) => File(e.relativePath!)).toList();
  }

  Future<bool> checkForPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    return _ps.isAuth;
  }
}