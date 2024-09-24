class NumberHandle {
  //format gia tien
  String formatPrice(num price, String type, String unit, {String? prefix}) {
    String value = price.toInt().toString();
    int count = 0;
    String tmp = '';
    if (value.length > 1) {
      for (int i = value.length - 1; i >= 0; i--) {
        tmp += value[i];
        count++;
        if (count % 3 == 0 && count != value.length) {
          tmp += type;
        }
      }
      return (prefix ?? '') + tmp.split('').reversed.join() + unit;
    }
    return (prefix ?? '') + value + unit;
  }

  String formatVoucherPrice(num price) {
    int prefix = price ~/ 100;
    return '${prefix}K';
  }

  String formatSold(num? sold) {
    if (sold == null) {
      return '0';
    }
    if (sold < 1000) {
      return sold.toString();
    } else if (sold < 1000000) {
      double res = sold / 1000;
      return '${(res * 10).truncateToDouble() / 10}K';
    } else {
      double res = sold / 1000000;
      return '${(res * 10).truncateToDouble() / 10}M';
    }
  }
}
