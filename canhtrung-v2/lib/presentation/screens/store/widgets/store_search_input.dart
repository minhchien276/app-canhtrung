// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/handle/search_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/slider/slider_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_search_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_search_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

class StoreSearchInput extends StatefulWidget {
  String name;
  String iconUrl;
  FocusNode focusNode;
  StoreSearchInput({
    Key? key,
    required this.name,
    required this.iconUrl,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<StoreSearchInput> createState() => _StoreSearchInputState();
}

class _StoreSearchInputState extends State<StoreSearchInput> {
  late TextEditingController _searchController;
  List<String> suggests = [];
  List<String> searchs = [];

  @override
  void initState() {
    getSuggest();
    _searchController = TextEditingController();
    _searchController.addListener(() async {
      String textSearch = _searchController.text.toUpperCase();
      if (widget.focusNode.hasFocus) {
        searchs = await SearchHandle().searchResults(textSearch, suggests);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getSuggest() async {
    final maNguoiDung = await SharedPreferencesService().id ?? '';
    final user = await LocalRepository().getNguoiDung(maNguoiDung);
    suggests = SearchHandle().getSuggest(user.phase! - 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 50,
          width: 500,
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: grey500.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.bottom,
            focusNode: widget.focusNode,
            cursorColor: rose400,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ).copyWith(
              color: widget.focusNode.hasFocus ? rose400 : grey400,
            ),
            decoration: InputDecoration(
              focusColor: rose400,
              prefixIcon: widget.focusNode.hasFocus
                  ? InkWell(
                      onTap: () {
                        widget.focusNode.unfocus();
                      },
                      child: Image.asset(
                        'assets/icons/back_icon.png',
                        scale: 2.8,
                        color: rose400,
                      ),
                    )
                  : Image.asset(
                      widget.iconUrl,
                      scale: 3,
                      color: grey400,
                    ),
              prefixIconColor: grey400,
              hintText: widget.name,
              suffixIcon: widget.focusNode.hasFocus
                  ? InkWell(
                      onTap: () {
                        _searchController.text = '';
                      },
                      child: Image.asset(
                        'assets/icons/x_icon.png',
                        scale: 4,
                        color: widget.focusNode.hasFocus ? rose400 : grey400,
                      ),
                    )
                  : null,
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ).copyWith(
                color: grey400,
              ),
              filled: true,
              fillColor: whiteColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  width: 0,
                  color: whiteColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (String value) {
              if (value.trim().isNotEmpty) {
                sliderRepository.add(false);
                Navigator.pushNamed(
                  context,
                  StoreProductSearchScreen.routeName,
                  arguments: {
                    'search': value,
                    'title': 'Kết quả tìm kiếm',
                    'isSearch': true,
                  },
                );
              }
            },
          ),
        ),
        if (widget.focusNode.hasFocus) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: _searchController.text.isEmpty
                  ? suggests.length * 50
                  : searchs.length * 50,
              width: size.width,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: grey200.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: _searchController.text.isEmpty
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: suggests.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _searchController.text = suggests[index];
                            sliderRepository.add(false);
                            Navigator.pushNamed(
                              context,
                              StoreProductSearchScreen.routeName,
                              arguments: {
                                'search': suggests[index],
                                'title': 'Kết quả tìm kiếm',
                                'isSearch': true,
                              },
                            );
                            widget.focusNode.unfocus();
                          },
                          child: StoreSeachItem(
                            name: suggests[index],
                            isLastItem: index == suggests.length - 1,
                            searchController: _searchController,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _searchController.text = searchs[index];
                            sliderRepository.add(false);
                            Navigator.pushNamed(
                              context,
                              StoreProductSearchScreen.routeName,
                              arguments: {
                                'search': searchs[index],
                                'title': 'Kết quả tìm kiếm',
                                'isSearch': true,
                              },
                            );
                            widget.focusNode.unfocus();
                          },
                          child: StoreSeachItem(
                            name: searchs[index],
                            isLastItem: index == searchs.length - 1,
                            searchController: _searchController,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
