import 'package:auto_route/auto_route.dart';
import 'package:monirth_memories/core/logger.dart';

class NotAuthGuard extends AutoRouteGuard {
  final log = getLogger('NotAuthGuard');

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    router.replaceNamed('/home');
    return;
  }
}
