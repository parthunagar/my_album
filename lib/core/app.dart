import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [],
  dependencies: [
    
    // LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: NavigationService),
    Singleton(classType: DialogService),
    Singleton(classType: SnackbarService),
    Singleton(classType: BottomSheetService),
  ],
  logger: StackedLogger(),
)
class $App {
  /** Serves no purpose besides having an annotation attached to it */
}
