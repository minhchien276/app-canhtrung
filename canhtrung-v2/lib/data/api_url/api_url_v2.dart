class ApiUrlV2 {
  static const baseUrl = 'https://ovumb-3ef3d173eba0.herokuapp.com/api/';
  //static const baseUrl = 'http://192.168.102.40/api/';

// {} []

//http của từng phần
  static const httpAuth = 'auth';
  static const httpNguoiDung = 'nguoidung';
  static const httpKinhNguyet = 'kinhnguyet';
  static const httpNhatKy = 'nhatky';
  static const httpCauTraLoi = 'cautraloi';
  static const httpQuanLyQueTest = 'quanlyquetest';
  static const httpHopTest = 'hoptest';
  static const httpKetQuaTest = 'ketquatest';
  static const httpMail = 'mail';
  static const httpLink = 'link';
  static const httpThaiKi = 'thaiki';
  static const httpBlog = 'blog';
  static const httpType = 'type-blog';
  static const httpLuongKinh = 'luongkinh';
  static const httpQuangCao = 'quangcao';
  static const httpClick = 'clicklink';
  static const httpTvv = 'tuvanvien';
  static const httpBenh = 'benh';
  static const httpAnDam = 'andam';
  static const httpBuBinh = 'bubinh';
  static const httpBuMe = 'bume';
  static const httpBinh = 'binh';
  static const httpCon = 'con';
  static const httpPhatTrien = 'phattrien';
  static const httpChoan = 'choan';
  static const httpTrieuChung = 'trieuchung';
  static const httpHutSua = 'hutsua';
  static const httpVersion = 'version';
  static const httpVnUnit = 'vn-units';
  static const httpSanPham = 'sanpham';
  static const httpSlide = 'slide';
  static const httpVideo = 'videos';
  static const httpAddress = 'address';
  static const httpOrder = 'order';
  static const httpVoucher = 'voucher';
  static const httpAds = 'clickads';
  static const httpQrsua = 'qrsua';
  static const httpTailieukichsua = 'tailieukichsua';
  static const httpNotification = 'notification';

//auth
  static const authRegister = '$httpAuth/register';
  static const authLogin = '$httpAuth/login';
  static const authLoginV2 = '$httpAuth/login-v2';
  static const authLogout = '$httpAuth/logout';
  static const authUpdateUser = '$httpAuth/update';
  static const authUpdatePhase = '$httpAuth/update-phase';
  static const authFindUser = '$httpAuth/find';
  static const authResetPassword = '$httpAuth/reset-password';
  static const authLogged = '$httpAuth/logged';
  static const authUpdateDeviceToken = '$httpAuth/update-device-token';

//http kinh nguyệt
  static const kinhNguyetInsert = '$httpKinhNguyet/insert';
  static const kinhNguyetFind = '$httpKinhNguyet/find';
  static const kinhNguyetUpdate = '$httpKinhNguyet/update';
  static const kinhNguyetDelete = '$httpKinhNguyet/delete';
  static const kinhNguyetDongbo = '$httpKinhNguyet/dong-bo';
  static const kinhNguyetDeleteByDate = '$httpKinhNguyet/delete-by-date';

//http nhật ký
  static const nhatKyInsert = '$httpNhatKy/insert';
  static const nhatKyFind = '$httpNhatKy/find';
  static const nhatKyDelete = '$httpNhatKy/delete';
  static const nhatKyGet = '$httpNhatKy/get-nhat-ky';
  static const nhatKyDongBo = '$httpNhatKy/dong-bo-nhat-ky';

//http lượng kinh
  static const luongKinhInsert = '$httpLuongKinh/insert';
  static const luongKinhFind = '$httpLuongKinh/find';
  static const luongKinhDelete = '$httpLuongKinh/delete';
  static const luongKinhGet = '$httpLuongKinh/get-luong-kinh';
  static const luongKinhDongBo = '$httpLuongKinh/dong-bo-luong-kinh';

//http cautraloi
  static const cauTraLoiFind = '$httpCauTraLoi/find';
  static const cauTraLoiInsert = '$httpCauTraLoi/insert';

//http quanlyquetest
  static const quanLyQueTestInsert = '$httpQuanLyQueTest/insert';
  static const quanLyQueTestFind = '$httpQuanLyQueTest/find';
  static const quanLyQueTestGet = '$httpQuanLyQueTest/get';
  static const quanLyQueTestUpdate = '$httpQuanLyQueTest/update';

//http hoptest
  static const hopTestUpdate = '$httpHopTest/update';

//http ketquatest
  static const ketQuaTestInsert = '$httpKetQuaTest/insert';
  static const ketQuaTestUpdate = '$httpKetQuaTest/update';
  static const ketQuaTestFind = '$httpKetQuaTest/find';
  static const ketQuaTestGetDatDinh = '$httpKetQuaTest/get-dat-dinh';

//http reset password
  static const mailResetPassword = '$httpMail/send-reset-link-email';
  static const mailGenOtp = '$httpMail/generate-otp';
  static const mailVerifyOtp = '$httpMail/verify-otp';

//http link
  static const linkFind = '$httpLink/find';
  static const linkGetConTrai = '$httpLink/get-link-con-trai';
  static const linkGetConGai = '$httpLink/get-link-con-gai';
  static const linkGetMeBe = '$httpLink/get-link-me-be';
  static const linkGetAnToan = '$httpLink/get-link-an-toan';

//http thaiki
  static const thaiKiInsert = '$httpThaiKi/insert';
  static const thaiKiFind = '$httpThaiKi/find';
  static const thaiKiUpdate = '$httpThaiKi/update';
  static const thaiKiDelete = '$httpThaiKi/delete-ngay-du-sinh';

//http blog
  static const blogGetListType = '$httpType/get';
  static const blogListBlog = '$httpBlog/get-blog-by-type';
  static const blogListBlogV2 = '$httpBlog/get-blog-by-type-v2';

//http quảng cáo
  static const quangCaoGet = '$httpQuangCao/find';

//http click
  static const clickInsert = '$httpClick/insert';

//http tvv
  static const tvvGetAll = '$httpTvv/get';
  static const tvvGetbyUser = '$httpTvv/get-tvv-by-iduser';
  static const tvvRedirectToZalo = '$httpTvv/redirect-to-zalo';

//http benh
  static const benhInsert = '$httpBenh/insert';
  static const benhUpdate = '$httpBenh/update';
  static const benhDelete = '$httpBenh/delete';
  static const benhFind = '$httpBenh/find';

//http an dam
  static const anDamInsert = '$httpAnDam/insert';
  static const anDamUpdate = '$httpAnDam/update';
  static const anDamFind = '$httpAnDam/find';
  static const anDamDelete = '$httpAnDam/delete';

//http bu binh
  static const buBinhInsert = '$httpAnDam/insert';
  static const buBinhUpdate = '$httpAnDam/update';
  static const buBinhFind = '$httpAnDam/find';

//http bu me
  static const buMeInsert = '$httpAnDam/insert';
  static const buMeUpdate = '$httpAnDam/update';
  static const buMeFind = '$httpAnDam/find';
  static const buMeDelete = '$httpAnDam/delete';

//http binh
  static const binhInsert = '$httpBinh/insert';
  static const binhUpdate = '$httpBinh/update';
  static const binhFind = '$httpBinh/find';
  static const binhDelete = '$httpBinh/delete';

//http con
  static const conGet = '$httpCon/get-by-ma-nguoi-dung';
  static const conInsert = '$httpCon/insert';
  static const conFind = '$httpCon/find';
  static const conUpdate = '$httpCon/update';
  static const conUpdateTrangThai = '$httpCon/update-trang-thai';
  static const conDelete = '$httpCon/delete';

//http phattrien
  static const phatTrienInsert = '$httpPhatTrien/insert';
  static const phatTrienGet = '$httpPhatTrien/get';

//http choan
  static const choanInsert = '$httpChoan/insert';
  static const choanGet = '$httpChoan/get-cho-an';
  static const choanGetNgayTao = '$httpChoan/get-cho-an-by-ma-loai-cho-an';
  static const choanGetHistory = '$httpChoan/get-cho-an-by-ngay-tao';
  static const choanUpdate = '$httpChoan/update-trong-luong';
  static const choanDelete = '$httpChoan/delete';

//http trieuchung
  static const trieuChungInsert = '$httpTrieuChung/insert';
  static const trieuChungGet = '$httpTrieuChung/get';

//http hutsua
  static const hutSuaInsert = '$httpHutSua/insert';
  static const hutSuaFind = '$httpHutSua/find';
  static const hutSuaUpdate = '$httpHutSua/update';
  static const hutSuaDelete = '$httpHutSua/delete';
  static const hutSuaGetNgayTao = '$httpHutSua/get-hut-sua-by-ngay-tao';
  static const hutSuaHistory = '$httpHutSua/get-hut-sua-7-ngay';

//http version
  static const versionGet = '$httpVersion/get-new-version';

//http location
  static const vnUnitGetCity = '$httpVnUnit/get-provinces';
  static const vnUnitGetDistrict = '$httpVnUnit/get-districts';
  static const vnUnitGetWard = '$httpVnUnit/get-wards';

//http sanpham
  static const sanphamGetLimit = '$httpSanPham/get-limit';
  static const sanphamGetAll = '$httpSanPham/get-all';
  static const sanphamGetAllByListId = '$httpSanPham/get-all-details';
  static const sanphamSearch = '$httpSanPham/search-products';
  static const sanphamGetDiscount = '$httpSanPham/get-product-discount';

//http slide
  static const sildeGet = '$httpSlide/get-all';

//http videos
  static const videoGuideGetVideo = '$httpVideo/get-video-test';
  static const videoGuideGetImage = '$httpVideo/get-test-image';
  static const videoGetBuMe = '$httpVideo/get-link-bu-me';

//http address
  static const addressGetAll = '$httpAddress/get-all-address';
  static const addressInsert = '$httpAddress/insert';
  static const addressUpdate = '$httpAddress/update';
  static const addressUpdateStatus = '$httpAddress/update-status-address';
  static const addressDelete = '$httpAddress/delete';

//http order
  static const orderInsert = '$httpOrder/insert';
  static const orderUpdate = '$httpOrder/update';
  static const orderGet = '$httpOrder/get';
  static const orderGetAll = '$httpOrder/get-all';
  static const orderGetStatus = '$httpOrder/get-order-status';
  static const orderGetHistory = '$httpOrder/get-order-history';
  static const orderGetItemDetail = '$httpOrder/get-order-details';
  static const orderCancel = '$httpOrder/cancel-order';

//http voucher
  static const voucherGetFreeShip = '$httpVoucher/get-free-ship';
  static const voucherGetVoucher = '$httpVoucher/get-voucher';

  //http ads
  static const adsClick = '$httpAds/insert';

  //http qr sua
  static const qrSuaGet = '$httpQrsua/get-qrsua';
  static const qrSuaUpdate = '$httpQrsua/update-qrsua';

  //http tailieukichsua
  static const tailieukichsuaGetVideo = '$httpTailieukichsua/get-video';
  static const tailieukichsuaGetImage = '$httpTailieukichsua/get-image';

  //http notification
  static const notificationGet = '$httpNotification/notification-user';
  static const notificationGetDetail = '$httpNotification/notification-details';
}
