// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog_list.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';

import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan.dart';

enum LoadedStatus {
  none,
  initial,
  succes,
  failure,
  disconnect;
}

enum LoadingStatus {
  all,
  begin,
  stop;
}

enum MilkEventName {
  rGet,
  rAdd,
  rDelete,
  rUpdate,
  rSwtich,
}

class MilkState extends Equatable {
  LoadingStatus isLoading;
  String? loadingText;
  String? message;
  Con? currentBaby;
  List<Con> babies;
  List<PhatTrienCon> phatTrienCon;
  List<ChoAn> choAn;
  List<TrieuChung> trieuChung;
  List<ChoAn> choAnHistory;
  bool? unlock;
  LoadedStatus status;
  MilkEventName event;
  int indexPhatTrien;
  List<ChartDataChoAn> chartDataChoAn;
  ChoAnEnum choAnEnum;
  Guide? bumeLink;
  List<HutSua> hutSuaByDay;
  List<HutSua> hutSua;
  bool popContext;
  List<PostModel>? posts;
  List<PostModel>? videos;
  List<BlogList>? blogsQuanHe;
  List<BlogList>? blogsBiQuyet;

  MilkState({
    required this.isLoading,
    this.loadingText,
    this.message,
    this.currentBaby,
    required this.babies,
    required this.phatTrienCon,
    required this.choAn,
    required this.choAnHistory,
    required this.trieuChung,
    required this.chartDataChoAn,
    required this.unlock,
    this.status = LoadedStatus.none,
    this.event = MilkEventName.rGet,
    this.indexPhatTrien = 0,
    this.choAnEnum = ChoAnEnum.none,
    this.bumeLink,
    required this.hutSuaByDay,
    required this.hutSua,
    this.popContext = false,
    required this.posts,
    required this.videos,
    required this.blogsQuanHe,
    required this.blogsBiQuyet,
  });

  copyWith({
    List<Con>? babies,
    Con? currentBaby,
    LoadingStatus? isLoading,
    bool? unlock,
    List<PhatTrienCon>? phatTrienCon,
    List<ChoAn>? choAn,
    List<ChoAn>? choAnHistory,
    List<TrieuChung>? trieuChung,
    String? message,
    LoadedStatus? status,
    MilkEventName? event,
    int? indexPhatTrien,
    List<ChartDataChoAn>? chartDataChoAn,
    ChoAnEnum? choAnEnum,
    Guide? bumeLink,
    List<HutSua>? hutSuaByDay,
    List<HutSua>? hutSua,
    bool? popContext,
    List<PostModel>? posts,
    List<PostModel>? videos,
    List<BlogList>? blogsQuanHe,
    List<BlogList>? blogsBiQuyet,
  }) {
    return MilkState(
      babies: babies ?? this.babies,
      currentBaby: currentBaby ?? this.currentBaby,
      isLoading: isLoading ?? this.isLoading,
      phatTrienCon: phatTrienCon ?? this.phatTrienCon,
      choAn: choAn ?? this.choAn,
      choAnHistory: choAnHistory ?? this.choAnHistory,
      trieuChung: trieuChung ?? this.trieuChung,
      chartDataChoAn: chartDataChoAn ?? this.chartDataChoAn,
      unlock: unlock ?? this.unlock,
      message: message,
      status: status ?? LoadedStatus.succes,
      event: event ?? MilkEventName.rGet,
      indexPhatTrien: indexPhatTrien ?? 0,
      choAnEnum: choAnEnum ?? this.choAnEnum,
      bumeLink: bumeLink ?? this.bumeLink,
      hutSuaByDay: hutSuaByDay ?? this.hutSuaByDay,
      hutSua: hutSua ?? this.hutSua,
      popContext: popContext ?? false,
      posts: posts ?? this.posts,
      videos: videos ?? this.videos,
      blogsQuanHe: blogsQuanHe ?? this.blogsQuanHe,
      blogsBiQuyet: blogsBiQuyet ?? this.blogsBiQuyet,
    );
  }

  @override
  List<Object?> get props => [
        babies,
        choAn,
        phatTrienCon,
        trieuChung,
        unlock,
        isLoading,
        message,
        status,
        event,
        indexPhatTrien,
        chartDataChoAn,
        choAnEnum,
        choAnHistory,
        bumeLink,
        hutSua,
        hutSuaByDay,
        popContext,
        posts,
        videos,
        blogsQuanHe,
        blogsBiQuyet,
      ];
}
