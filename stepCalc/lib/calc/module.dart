import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'pages/calc.dart';

final calcRoutes = Route(
  matcher: Matcher.path('calc'),
  materialBuilder: (_, result) => Calculator(),
);
