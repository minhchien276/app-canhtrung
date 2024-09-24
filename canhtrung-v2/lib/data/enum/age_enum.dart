enum AgeEnum {
  teenage, //loại thường
  adults;

  static toEnum(int? year) {
    if (year != null) {
      int age = DateTime.now().difference(DateTime(year, 1, 1)).inDays ~/ 365;
      if (age <= 16) {
        return AgeEnum.teenage;
      } else {
        return AgeEnum.adults;
      }
    }
    return AgeEnum.adults;
  }
}
