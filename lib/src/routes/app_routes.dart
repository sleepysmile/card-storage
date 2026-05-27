class AppRoutes {
  static const home = '/home';
  static const settings = '/settings';
  static const cardList = '/cards';
  static const cardCreate = '/cards/create';
  static const cardScan = '/cards/scan';
  static const cardView = '/cards/view';
  static const cardEdit = '/cards/edit';

  static const all = [
    home,
    settings,
    cardList,
    cardCreate,
    cardScan,
    cardView,
    cardEdit,
  ];

  static String cardViewPath(String barcode) {
    return '$cardView?barcode=${Uri.encodeQueryComponent(barcode)}';
  }

  static String cardEditPath(String barcode) {
    return '$cardEdit?barcode=${Uri.encodeQueryComponent(barcode)}';
  }

  static String normalize(String? routeName) {
    if (routeName == null || routeName.isEmpty || routeName == '/') {
      return home;
    }

    if (all.contains(routeName)) {
      return routeName;
    }

    return home;
  }

  static int indexFor(String routeName) {
    switch (routeName) {
      case settings:
        return 1;
      case home:
      default:
        return 0;
    }
  }

  static String routeForIndex(int index) {
    switch (index) {
      case 1:
        return settings;
      case 0:
      default:
        return home;
    }
  }
}
