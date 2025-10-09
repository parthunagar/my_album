// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;

import '../../ui/views/favorites/favorites_view.dart' as _i3;
import '../../ui/views/full_image/full_image_view.dart' as _i4;
import '../../ui/views/gallery/gallery_view.dart' as _i5;
import '../../ui/views/home/home_view.dart' as _i2;
import '../../ui/views/splash_screen/splash_view.dart' as _i1;
import '../../ui/views/video_list/video_list_view.dart' as _i6;
import '../../ui/widgets/video_player.dart' as _i7;
import '../auto_route_guards.dart' as _i10;
import '../services/favorites_service.dart' as _i11;

class AppRouter extends _i8.RootStackRouter {
  AppRouter({
    _i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
    required this.notAuthGuard,
  }) : super(navigatorKey);

  final _i10.NotAuthGuard notAuthGuard;

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreenView(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomeView(),
      );
    },
    FavoritesRoute.name: (routeData) {
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.FavoritesView(),
      );
    },
    FullImageRoute.name: (routeData) {
      final args = routeData.argsAs<FullImageRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.FullImageView(
          key: args.key,
          id: args.id,
          fullImagePath: args.fullImagePath,
          isAsset: args.isAsset,
          favoritesService: args.favoritesService,
        ),
      );
    },
    GalleryRoute.name: (routeData) {
      final args = routeData.argsAs<GalleryRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.GalleryView(
          key: args.key,
          jsonUrl: args.jsonUrl,
        ),
      );
    },
    VideoListRoute.name: (routeData) {
      final args = routeData.argsAs<VideoListRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.VideoListView(
          args.jsonUrl,
          key: args.key,
        ),
      );
    },
    MyPlayerRoute.name: (routeData) {
      final args = routeData.argsAs<MyPlayerRouteArgs>();
      return _i8.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.MyPlayer(
          key: args.key,
          videoUrl: args.videoUrl,
        ),
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/home',
          fullMatch: true,
        ),
        _i8.RouteConfig(
          SplashRoute.name,
          path: '/splash',
          guards: [notAuthGuard],
        ),
        _i8.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i8.RouteConfig(
          FavoritesRoute.name,
          path: '/favorites',
        ),
        _i8.RouteConfig(
          FullImageRoute.name,
          path: '/full_image',
        ),
        _i8.RouteConfig(
          GalleryRoute.name,
          path: '/gallery',
        ),
        _i8.RouteConfig(
          VideoListRoute.name,
          path: '/video_list',
        ),
        _i8.RouteConfig(
          MyPlayerRoute.name,
          path: '/my_player',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreenView]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.FavoritesView]
class FavoritesRoute extends _i8.PageRouteInfo<void> {
  const FavoritesRoute()
      : super(
          FavoritesRoute.name,
          path: '/favorites',
        );

  static const String name = 'FavoritesRoute';
}

/// generated route for
/// [_i4.FullImageView]
class FullImageRoute extends _i8.PageRouteInfo<FullImageRouteArgs> {
  FullImageRoute({
    _i9.Key? key,
    required int id,
    required String fullImagePath,
    required bool isAsset,
    required _i11.PreferenceService favoritesService,
  }) : super(
          FullImageRoute.name,
          path: '/full_image',
          args: FullImageRouteArgs(
            key: key,
            id: id,
            fullImagePath: fullImagePath,
            isAsset: isAsset,
            favoritesService: favoritesService,
          ),
        );

  static const String name = 'FullImageRoute';
}

class FullImageRouteArgs {
  const FullImageRouteArgs({
    this.key,
    required this.id,
    required this.fullImagePath,
    required this.isAsset,
    required this.favoritesService,
  });

  final _i9.Key? key;

  final int id;

  final String fullImagePath;

  final bool isAsset;

  final _i11.PreferenceService favoritesService;

  @override
  String toString() {
    return 'FullImageRouteArgs{key: $key, id: $id, fullImagePath: $fullImagePath, isAsset: $isAsset, favoritesService: $favoritesService}';
  }
}

/// generated route for
/// [_i5.GalleryView]
class GalleryRoute extends _i8.PageRouteInfo<GalleryRouteArgs> {
  GalleryRoute({
    _i9.Key? key,
    required String jsonUrl,
  }) : super(
          GalleryRoute.name,
          path: '/gallery',
          args: GalleryRouteArgs(
            key: key,
            jsonUrl: jsonUrl,
          ),
        );

  static const String name = 'GalleryRoute';
}

class GalleryRouteArgs {
  const GalleryRouteArgs({
    this.key,
    required this.jsonUrl,
  });

  final _i9.Key? key;

  final String jsonUrl;

  @override
  String toString() {
    return 'GalleryRouteArgs{key: $key, jsonUrl: $jsonUrl}';
  }
}

/// generated route for
/// [_i6.VideoListView]
class VideoListRoute extends _i8.PageRouteInfo<VideoListRouteArgs> {
  VideoListRoute({
    required String jsonUrl,
    _i9.Key? key,
  }) : super(
          VideoListRoute.name,
          path: '/video_list',
          args: VideoListRouteArgs(
            jsonUrl: jsonUrl,
            key: key,
          ),
        );

  static const String name = 'VideoListRoute';
}

class VideoListRouteArgs {
  const VideoListRouteArgs({
    required this.jsonUrl,
    this.key,
  });

  final String jsonUrl;

  final _i9.Key? key;

  @override
  String toString() {
    return 'VideoListRouteArgs{jsonUrl: $jsonUrl, key: $key}';
  }
}

/// generated route for
/// [_i7.MyPlayer]
class MyPlayerRoute extends _i8.PageRouteInfo<MyPlayerRouteArgs> {
  MyPlayerRoute({
    _i9.Key? key,
    required String videoUrl,
  }) : super(
          MyPlayerRoute.name,
          path: '/my_player',
          args: MyPlayerRouteArgs(
            key: key,
            videoUrl: videoUrl,
          ),
        );

  static const String name = 'MyPlayerRoute';
}

class MyPlayerRouteArgs {
  const MyPlayerRouteArgs({
    this.key,
    required this.videoUrl,
  });

  final _i9.Key? key;

  final String videoUrl;

  @override
  String toString() {
    return 'MyPlayerRouteArgs{key: $key, videoUrl: $videoUrl}';
  }
}
