import 'package:fehviewer/route/routes.dart';

import '../fetch_list.dart';
import 'default_tabview_controller.dart';

class PopularViewController extends DefaultTabViewController {
  @override
  void onInit() {
    heroTag = EHRoutes.popular;
    super.onInit();
  }

  @override
  FetchListClient getFetchListClient(FetchParams fetchParams) {
    return PopularFetchListClient(fetchParams: fetchParams);
  }
}
