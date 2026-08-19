import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_use_case.dart';
import 'home_state.dart';

import 'package:diamond_customer/features/addresses/domain/usecases/get_current_location_use_case.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  HomeCubit({
    required this.getHomeDataUseCase,
    required this.getCurrentLocationUseCase,
  }) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    
    // Default location (e.g., Riyadh) if we fail to get user location
    double latitude = 24.7136;
    double longitude = 46.6753;

    final locationResult = await getCurrentLocationUseCase();
    locationResult.fold(
      (failure) {
        // Continue with default location if permission denied or error
      },
      (position) {
        latitude = position.latitude;
        longitude = position.longitude;
      },
    );

    final result = await getHomeDataUseCase(
      latitude: latitude,
      longitude: longitude,
    );
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (homeData) => emit(HomeLoaded(homeData)),
    );
  }
}
