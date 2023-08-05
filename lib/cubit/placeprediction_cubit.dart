import 'package:bloc/bloc.dart';

import '/model/place_prediction.dart';

class PlacePredictionCubit extends Cubit<List<PlacePrediction>> {
  PlacePredictionCubit(List<PlacePrediction> initialValue) : super([]);

  int get length => state.length;

  void addPlacePredictionList(List<PlacePrediction> value) {
    emit(value);
  }
}
