import 'package:photo_manager/photo_manager.dart';

class ScanlyImageManager {

  /// TO get File from AssetEntity
  /// Iterate on the result then call [await element.file]
  /// element is every item in result
  Future<List<AssetEntity>> getLatestImages() async {
    final isGranted = await checkForPermission();
    if (!isGranted) {
      throw UnimplementedError("Permission is not granted!");
    }
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    final List<AssetEntity> entities = await paths.first.getAssetListPaged(page: 0, size: 20);
    return entities;
  }

  Future<bool> checkForPermission() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    return _ps.isAuth;
  }
}