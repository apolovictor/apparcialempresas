class RouteNames {
  static const String home = '/';
  static const String products = '/produtos';
  static const String productDetails = '/productDetails';
  static const String reports = '/relatorios';
  static const String settings = '/configuracoes';
  static const String tables = '/mesas';
}

class RouteListTile {
  static const String listTile1 = 'Colors.green[50]';
  static const String listTile2 = 'Colors.green[50]';
  static const String listTile3 = 'Colors.green[50]';
  static const String listTile4 = 'Colors.green[50]';
}

class RouteNamesList {
  String title;
  RouteNamesList({required this.title});
}

List<RouteNamesList> topBarList = [
  RouteNamesList(title: RouteNames.home),
  RouteNamesList(title: RouteNames.products),
  RouteNamesList(title: RouteNames.reports),
  RouteNamesList(title: RouteNames.tables),
];
