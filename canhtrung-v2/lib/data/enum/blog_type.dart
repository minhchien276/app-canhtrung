enum BlogType {
  quanhe,
  biquyet;

  String parseTitle() {
    switch (this) {
      case BlogType.quanhe:
        return 'Quan hệ an toàn sau sinh';
      case BlogType.biquyet:
        return 'Bí quyết chăm con khoa học';
      default:
        return 'Bài viết';
    }
  }

  String endpoint() {
    switch (this) {
      case BlogType.quanhe:
        return 'quanhe';
      case BlogType.biquyet:
        return 'biquyet';
      default:
        return 'null';
    }
  }
}
