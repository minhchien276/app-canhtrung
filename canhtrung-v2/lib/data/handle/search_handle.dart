class SearchHandle {
  List<String> suggestPhase1 = [
    'Que thử',
    'Vitamin',
    'Bổ trứng',
    'Bổ tinh',
    'Dung dịch vệ sinh',
    'Tạo kiềm, axit',
  ];
  List<String> suggestPhase2 = [
    'Que thử',
    'Bao cao su',
    'Dung dịch vệ sinh',
    'Làm đẹp da, tóc',
  ];
  List<String> suggestPhase3 = [
    'Que thử',
    'Vitamin',
    'Bổ trứng',
    'Bổ tinh',
    'Dung dịch vệ sinh',
    'Tạo kiềm, axit',
  ];
  List<String> suggestPhase4 = [
    'Kích sữa, lợi sữa, đặc sữa',
    'Sản phẩm cho bé, chăm sóc bé',
    'Chăm sóc mẹ',
  ];
  List<String> suggestPhase5 = [
    'Làm đẹp da tóc',
    'Bao cao su',
    'Dung dịch vệ sinh',
    'Mát gan, trị mụn',
  ];

  //loai bo dau
  String removeDiacritics(String input) {
    final Map<String, String> diacriticMap = {
      'á': 'a',
      'à': 'a',
      'ả': 'a',
      'ã': 'a',
      'ạ': 'a',
      'ă': 'a',
      'ắ': 'a',
      'ằ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'ặ': 'a',
      'â': 'a',
      'ấ': 'a',
      'ầ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ậ': 'a',
      'é': 'e',
      'è': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ẹ': 'e',
      'ê': 'e',
      'ế': 'e',
      'ề': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ệ': 'e',
      'í': 'i',
      'ì': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ị': 'i',
      'ó': 'o',
      'ò': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ọ': 'o',
      'ô': 'o',
      'ố': 'o',
      'ồ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ộ': 'o',
      'ơ': 'o',
      'ớ': 'o',
      'ờ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ợ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ụ': 'u',
      'ư': 'u',
      'ứ': 'u',
      'ừ': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ự': 'u',
      'ý': 'y',
      'ỳ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ỵ': 'y',
      'đ': 'd',
    };
    return input.replaceAllMapped(
        RegExp(
            '[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ]'),
        (match) => diacriticMap[match.group(0)!]!);
  }

  //tim kiem
  List<String> searchResults(
    String search,
    List<String> products,
  ) {
    return products.where((product) {
      return removeDiacritics(product.toLowerCase())
          .contains(removeDiacritics(search.toLowerCase()));
    }).toList();
  }

  List<String> getSuggest(
    int phase,
  ) {
    List<List<String>> suggests = [
      suggestPhase1,
      suggestPhase2,
      suggestPhase3,
      suggestPhase4,
      suggestPhase5,
    ];
    return suggests[phase];
  }
}
