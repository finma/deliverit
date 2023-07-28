import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountdownCubit extends Cubit<int> {
  final int initialCountdown;
  late Timer _timer;

  CountdownCubit(this.initialCountdown) : super(initialCountdown);

  void startCountdown() {
    emit(initialCountdown);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        emit(state - 1);
      } else {
        _timer.cancel();
      }
    });
  }

  void dispose() {
    _timer.cancel();
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
