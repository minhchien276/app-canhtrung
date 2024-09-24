//http của từng phần
const httpAuth = 'auth';
const httpNguoiDung = 'nguoidung';
const httpKinhNguyet = 'kinhnguyet';
const httpNhatKy = 'nhatky';
const httpCauTraLoi = 'cautraloi';
const httpQuanLyQueTest = 'quanlyquetest';
const httpHopTest = 'hoptest';
const httpKetQuaTest = 'ketquatest';
const httpMail = 'mail';
const httpLink = 'link';
const httpThaiKi = 'thaiki';
const httpBlog = 'blog';
const httpType = 'type-blog';
const httpLuongKinh = 'luongkinh';
const httpQuangCao = 'quangcao';
const httpClick = 'clicklink';
const httpTvv = 'tuvanvien';
const httpBenh = 'benh';
const httpAnDam = 'andam';
const httpBuBinh = 'bubinh';
const httpBuMe = 'bume';
const httpBinh = 'binh';
const httpCon = 'con';
const httpPhatTrien = 'phattrien';
const httpChoan = 'choan';
const httpTrieuChung = 'trieuchung';
const httpHutSua = 'hutsua';
const httpVersion = 'version';
const httpVnUnit = 'vn-units';
const httpSanPham = 'sanpham';
const httpSlide = 'slide';
const httpVideo = 'videos';
const httpAddress = 'address';
const httpOrder = 'order';
const httpVoucher = 'voucher';

//auth
const authRegister = '$httpAuth/register';
const authLogin = '$httpAuth/login';
const authLogout = '$httpAuth/logout';
const authUpdateUser = '$httpAuth/update';
const authUpdatePhase = '$httpAuth/update-phase';
const authFindUser = '$httpAuth/find';
const authResetPassword = '$httpAuth/reset-password';

//http kinh nguyệt
const kinhNguyetInsert = '$httpKinhNguyet/insert';
const kinhNguyetFind = '$httpKinhNguyet/find';
const kinhNguyetUpdate = '$httpKinhNguyet/update';
const kinhNguyetDelete = '$httpKinhNguyet/delete';
const kinhNguyetDongbo = '$httpKinhNguyet/dong-bo';

//http nhật ký
const nhatKyInsert = '$httpNhatKy/insert';
const nhatKyFind = '$httpNhatKy/find';
const nhatKyDelete = '$httpNhatKy/delete';
const nhatKyGet = '$httpNhatKy/get-nhat-ky';

//http lượng kinh
const luongKinhInsert = '$httpLuongKinh/insert';
const luongKinhFind = '$httpLuongKinh/find';
const luongKinhDelete = '$httpLuongKinh/delete';
const luongKinhGet = '$httpLuongKinh/get-luong-kinh';

//http cautraloi
const cauTraLoiFind = '$httpCauTraLoi/find';
const cauTraLoiInsert = '$httpCauTraLoi/insert';

//http quanlyquetest
const quanLyQueTestInsert = '$httpQuanLyQueTest/insert';
const quanLyQueTestFind = '$httpQuanLyQueTest/find';
const quanLyQueTestUpdate = '$httpQuanLyQueTest/update';

//http hoptest
const hopTestUpdate = '$httpHopTest/update';

//http ketquatest
const ketQuaTestInsert = '$httpKetQuaTest/insert';
const ketQuaTestUpdate = '$httpKetQuaTest/update';
const ketQuaTestFind = '$httpKetQuaTest/find';
const ketQuaTestGetDatDinh = '$httpKetQuaTest/get-dat-dinh';

//http reset password
const mailResetPassword = '$httpMail/send-reset-link-email';
const mailGenOtp = '$httpMail/generate-otp';
const mailVerifyOtp = '$httpMail/verify-otp';

//http link
const linkFind = '$httpLink/find';
const linkGetConTrai = '$httpLink/get-link-con-trai';
const linkGetConGai = '$httpLink/get-link-con-gai';
const linkGetMeBe = '$httpLink/get-link-me-be';
const linkGetAnToan = '$httpLink/get-link-an-toan';

//http thaiki
const thaiKiInsert = '$httpThaiKi/insert';
const thaiKiFind = '$httpThaiKi/find';
const thaiKiUpdate = '$httpThaiKi/update';
const thaiKiDelete = '$httpThaiKi/delete-ngay-du-sinh';

//http blog
const blogGetListType = '$httpType/get';
const blogListBlog = '$httpBlog/get-blog-by-type';

//http quảng cáo
const quangCaoGet = '$httpQuangCao/find';

//http click
const clickInsert = '$httpClick/insert';

//http tvv
const tvvGetAll = '$httpTvv/get';
const tvvGetbyUser = '$httpTvv/get-tvv-by-iduser';

//http benh
const benhInsert = '$httpBenh/insert';
const benhUpdate = '$httpBenh/update';
const benhDelete = '$httpBenh/delete';
const benhFind = '$httpBenh/find';

//http an dam
const anDamInsert = '$httpAnDam/insert';
const anDamUpdate = '$httpAnDam/update';
const anDamFind = '$httpAnDam/find';
const anDamDelete = '$httpAnDam/delete';

//http bu binh
const buBinhInsert = '$httpAnDam/insert';
const buBinhUpdate = '$httpAnDam/update';
const buBinhFind = '$httpAnDam/find';

//http bu me
const buMeInsert = '$httpAnDam/insert';
const buMeUpdate = '$httpAnDam/update';
const buMeFind = '$httpAnDam/find';
const buMeDelete = '$httpAnDam/delete';

//http binh
const binhInsert = '$httpBinh/insert';
const binhUpdate = '$httpBinh/update';
const binhFind = '$httpBinh/find';
const binhDelete = '$httpBinh/delete';

//http con
const conGet = '$httpCon/get-by-ma-nguoi-dung';
const conInsert = '$httpCon/insert';
const conFind = '$httpCon/find';
const conUpdate = '$httpCon/update';
const conUpdateTrangThai = '$httpCon/update-trang-thai';
const conDelete = '$httpCon/delete';

//http phattrien
const phatTrienInsert = '$httpPhatTrien/insert';
const phatTrienGet = '$httpPhatTrien/get';

//http choan
const choanInsert = '$httpChoan/insert';
const choanGet = '$httpChoan/get-cho-an';
const choanGetNgayTao = '$httpChoan/get-cho-an-by-ma-loai-cho-an';
const choanGetHistory = '$httpChoan/get-cho-an-by-ngay-tao';
const choanUpdate = '$httpChoan/update-trong-luong';
const choanDelete = '$httpChoan/delete';

//http trieuchung
const trieuChungInsert = '$httpTrieuChung/insert';
const trieuChungGet = '$httpTrieuChung/get';

//http hutsua
const hutSuaInsert = '$httpHutSua/insert';
const hutSuaFind = '$httpHutSua/find';
const hutSuaUpdate = '$httpHutSua/update';
const hutSuaDelete = '$httpHutSua/delete';
const hutSuaGetNgayTao = '$httpHutSua/get-hut-sua-by-ngay-tao';
const hutSuaHistory = '$httpHutSua/get-hut-sua-7-ngay';

//http version
const versionGet = '$httpVersion/get-new-version';

//http location
const vnUnitGetCity = '$httpVnUnit/get-provinces';
const vnUnitGetDistrict = '$httpVnUnit/get-districts';
const vnUnitGetWard = '$httpVnUnit/get-wards';

//http sanpham
const sanphamGetLimit = '$httpSanPham/get-limit';
const sanphamGetAll = '$httpSanPham/get-all';
const sanphamGetAllByListId = '$httpSanPham/get-all-details';
const sanphamSearch = '$httpSanPham/search-products';

//http slide
const sildeGet = '$httpSlide/get-all';

//http videos
const videoGuideGetVideo = '$httpVideo/get-video-test';
const videoGuideGetImage = '$httpVideo/get-test-image';
const videoGetBuMe = '$httpVideo/get-link-bu-me';

//http address
const addressGetAll = '$httpAddress/get-all-address';
const addressInsert = '$httpAddress/insert';
const addressUpdate = '$httpAddress/update';
const addressUpdateStatus = '$httpAddress/update-status-address';
const addressDelete = '$httpAddress/delete';

//http order
const orderInsert = '$httpOrder/insert';
const orderUpdate = '$httpOrder/update';
const orderGet = '$httpOrder/get';
const orderGetAll = '$httpOrder/get-all';
const orderGetStatus = '$httpOrder/get-order-status';
const orderGetHistory = '$httpOrder/get-order-history';
const orderGetItemDetail = '$httpOrder/get-order-details';
const orderCancel = '$httpOrder/cancel-order';

//http voucher
const voucherGetFreeShip = '$httpVoucher/get-free-ship';
const voucherGetVoucher = '$httpVoucher/get-voucher';
