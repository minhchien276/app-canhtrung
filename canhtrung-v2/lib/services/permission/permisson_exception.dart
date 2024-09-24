class PermissionException implements Exception {
  final String message;

  PermissionException(this.message);

  @override
  String toString() => message;
}

class LocationDeniedException extends PermissionException {
  LocationDeniedException()
      : super(
            'Bạn chưa cấp quyền truy cập vị trí, hãy bật cấp quyền để sử dụng tính năng này');
}

class CameraDeniedException extends PermissionException {
  CameraDeniedException()
      : super(
            'Bạn chưa cấp quyền sử dụng camera, hãy bật cấp quyền để sử dụng tính năng này');
}

class PhotosDeniedException extends PermissionException {
  PhotosDeniedException()
      : super(
            'Bạn chưa cấp quyền truy cập vào thư viện ảnh, hãy bật cấp quyền để sử dụng tính năng này');
}
