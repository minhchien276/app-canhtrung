enum QueTestType {
  trung,
  thai;

  parseInt() {
    switch (this) {
      case QueTestType.trung:
        return 1;
      case QueTestType.thai:
        return 2;
      default:
        return 1;
    }
  }

  toEnum(int id) {
    switch (id) {
      case 1:
        return QueTestType.trung;
      case 2:
        return QueTestType.thai;
      default:
        return QueTestType.trung;
    }
  }
}
