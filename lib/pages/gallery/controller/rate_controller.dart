import 'package:fehviewer/common/service/controller_tag_service.dart';
import 'package:fehviewer/models/base/eh_models.dart';
import 'package:fehviewer/network/api.dart';
import 'package:fehviewer/utils/logger.dart';
import 'package:fehviewer/utils/toast.dart';
import 'package:get/get.dart';

import 'gallery_page_controller.dart';
import 'gallery_page_state.dart';

class RateController extends GetxController {
  RateController();

  late double rate;

  late GalleryPageController pageController;
  GalleryPageState get _pageState => pageController.gState;
  GalleryProvider? get _item => _pageState.galleryProvider;

  @override
  void onInit() {
    super.onInit();
    pageController = Get.find(tag: pageCtrlTag);
    rate = _item?.rating ?? 0;
  }

  Future<void> rating() async {
    if (_item == null) {
      return;
    }

    logger.v('rating $rate');
    logger.v('${_item?.apiuid} ${_item?.apikey}');
    logger.v('${(rate * 2).round()}');
    final Map<String, dynamic> rultMap = await Api.setRating(
      apikey: _item!.apikey ?? '',
      apiuid: _item!.apiuid ?? '',
      gid: _item!.gid ?? '0',
      token: _item!.token ?? '',
      rating: (rate * 2).round(),
    );
    pageController.ratinged(
      ratingUsr: double.parse(rultMap['rating_usr'].toString()),
      ratingAvg: double.parse(rultMap['rating_avg'].toString()),
      ratingCnt: rultMap['rating_cnt'] as int,
      colorRating: rultMap['rating_cls'] as String,
    );
    showToast('Ratting successfully');
  }
}
