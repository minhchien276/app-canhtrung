import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _singleton =
      SharedPreferencesService._internal();
  static SharedPreferences? _preferences;

  factory SharedPreferencesService() {
    return _singleton;
  }

  SharedPreferencesService._internal();

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception("SharedPreferences have not been initialized yet.");
    }
    return _preferences!;
  }

  final _tokenKey = 'token';
  final _userIdKey = 'maNguoiDung';
  final _synchronizedKey = 'sync';
  final _showcaseviewKey = 'showcaseview';
  final _phaseKey = 'phase';
  final _ads1Key = 'date1';
  final _ads2Key = 'date2';
  final _ads3Key = 'date3';
  final _showAdsKey = 'setShowAds';
  final _versionKey = 'callVersion';
  final _kinhnguyetKey = 'kinhnguyet';
  final _kinhnguyetWarningKey = 'kinhnguyet_warning';
  final _nhatkyKey = 'nhatky';
  final _luongkinhKey = 'luongkinh';
  final _deviceTokenKey = 'device_token';

  String? get token => _preferences?.getString(_tokenKey);
  String? get id => _preferences?.getString(_userIdKey);
  bool get synchronized => _preferences?.getBool(_synchronizedKey) ?? false;
  bool? get showCase => _preferences?.getBool(_showcaseviewKey);
  int? get phase => _preferences?.getInt(_phaseKey);
  int? get ads1 => _preferences?.getInt(_ads1Key);
  int? get ads2 => _preferences?.getInt(_ads2Key);
  int? get ads3 => _preferences?.getInt(_ads3Key);
  int? get showAds => _preferences?.getInt(_showAdsKey);
  int? get version => _preferences?.getInt(_versionKey);
  bool? get syncKinhNguyet => _preferences?.getBool(_kinhnguyetKey);
  bool? get warningKinhNguyet => _preferences?.getBool(_kinhnguyetWarningKey);
  bool? get syncNhatKy => _preferences?.getBool(_nhatkyKey);
  bool? get syncLuongKinh => _preferences?.getBool(_luongkinhKey);
  String? get deviceToken => _preferences?.getString(_deviceTokenKey);

  //mã người dùng
  setId(String maNguoiDung) async {
    await _preferences?.setString(_userIdKey, maNguoiDung);
  }

  removeId() async {
    await _preferences?.remove(_userIdKey);
  }

  // token
  setToken(String token) async {
    await _preferences?.setString(_tokenKey, token);
  }

  removeToken() async {
    await _preferences?.remove(_tokenKey);
  }

  // check đồng bộ
  setSync(bool sync) async {
    await _preferences?.setBool(_synchronizedKey, sync);
  }

  removeSync() async {
    await _preferences?.remove(_synchronizedKey);
  }

  // check showcase
  setShowCaseView(bool showcaseview) async {
    await _preferences?.setBool(_showcaseviewKey, showcaseview);
  }

  // check phase
  setPhase(int phase) async {
    await _preferences?.setInt(_phaseKey, phase);
  }

  removePhase() async {
    await _preferences?.remove(_phaseKey);
  }

  //ADS
  // phase1
  setAds1(DateTime date) async {
    await _preferences?.setInt(_ads1Key, date.millisecondsSinceEpoch);
  }

  removeAds1() async {
    await _preferences?.remove(_ads1Key);
  }

  // phase2
  setAds2(DateTime date) async {
    await _preferences?.setInt(_ads2Key, date.millisecondsSinceEpoch);
  }

  removeAds2() async {
    await _preferences?.remove(_ads2Key);
  }

  // phase3
  setAds3(DateTime date) async {
    await _preferences?.setInt(_ads3Key, date.millisecondsSinceEpoch);
  }

  removeAds3() async {
    await _preferences?.remove(_ads3Key);
  }

  //set show ads
  setShowAds(DateTime date) async {
    await _preferences?.setInt(_showAdsKey, date.millisecondsSinceEpoch);
  }

  // VERSION
  setCallVersion(int date) async {
    await _preferences?.setInt(_versionKey, date);
  }

  removeCallVersion() async {
    await _preferences?.remove(_versionKey);
  }

  //SYNCHRONIZED
  //true: đã đồng bộ, false: chưa đồng bộ
  //KinhNguyet
  setSyncKinhNguyet(bool status) async {
    await _preferences?.setBool(_kinhnguyetKey, status);
    await setWarningKinhNguyet(status);
  }

  setWarningKinhNguyet(bool status) async {
    await _preferences?.setBool(_kinhnguyetWarningKey, status);
  }

  removeSyncKinhNguyet() async {
    await _preferences?.remove(_kinhnguyetKey);
    await _preferences?.remove(_kinhnguyetWarningKey);
  }

  //NhatKy
  setSyncNhatKy(bool status) async {
    await _preferences?.setBool(_nhatkyKey, status);
  }

  removeSyncNhatKy() async {
    await _preferences?.remove(_nhatkyKey);
  }

  //LuongKinh
  setSyncLuongKinh(bool status) async {
    await _preferences?.setBool(_luongkinhKey, status);
  }

  removeSyncLuongKinh() async {
    await _preferences?.remove(_luongkinhKey);
  }

  setFCM(String token) async {
    await _preferences?.setString(_deviceTokenKey, token);
  }

  remoceFCM() async {
    await _preferences?.remove(_deviceTokenKey);
  }

  //LOGOUT
  logout() async {
    await remoceFCM();
    await removeToken();
    await removeId();
    await removeSync();
    await removeAds1();
    await removeAds2();
    await removeAds3();
    await removeSyncKinhNguyet();
    await removeSyncNhatKy();
    await removeSyncLuongKinh();
  }
}
