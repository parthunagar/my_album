import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [],
  dependencies: [
    LazySingleton(classType: NavigationService),
    Singleton(classType: DialogService),
    Singleton(classType: SnackbarService),
    Singleton(classType: BottomSheetService),
    Singleton(classType: PreferenceService)
  ],
  logger: StackedLogger(),
)
class $App {}
