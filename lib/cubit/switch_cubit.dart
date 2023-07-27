import 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

class SwitchCubit extends Cubit<bool> {
  SwitchCubit(bool initialValue) : super(initialValue);

  void toggleSwitch() {
    emit(!state);
  }
}
