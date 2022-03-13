import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

GoRouter? router;

GoRouter buildRouter(BuildContext context, bool isWeb) {
  router = router ??
      GoRouter(
        initialLocation: '/',
        routes: [],
      );
  return router!;
}
