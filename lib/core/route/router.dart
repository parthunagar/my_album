import 'package:auto_route/annotations.dart';
import 'package:monirth_memories/core/auto_route_guards.dart';
import 'package:monirth_memories/ui/views/favorites/favorites_view.dart';
import 'package:monirth_memories/ui/views/full_image/full_image_view.dart';
import 'package:monirth_memories/ui/views/gallery/gallery_view.dart';
import 'package:monirth_memories/ui/views/home/home_view.dart';
import 'package:monirth_memories/ui/views/splash_screen/splash_view.dart';
import 'package:monirth_memories/ui/views/video_list/video_list_view.dart';
import 'package:monirth_memories/ui/widgets/video_player.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: '/splash',
        name: 'SplashRoute',
        page: SplashScreenView,
        // initial: true,
        guards: [NotAuthGuard]),
    AutoRoute(
      path: '/home',
      name: 'HomeRoute',
      initial: true,
      page: HomeView,
    ),
    AutoRoute(
      path: '/favorites',
      name: 'FavoritesRoute',
      page: FavoritesView,
    ),
    AutoRoute(
      path: '/full_image',
      name: 'FullImageRoute',
      page: FullImageView,
    ),
    AutoRoute(
      path: '/gallery',
      name: 'GalleryRoute',
      page: GalleryView,
    ),
    AutoRoute(
      path: '/video_list',
      name: 'VideoListRoute',
      page: VideoListView,
    ),
    AutoRoute(
      path: '/my_player',
      name: 'MyPlayerRoute',
      page: MyPlayer,
    ),
  ],
)
class $AppRouter {}
