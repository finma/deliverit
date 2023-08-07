import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCubit<T> extends Cubit<T> {
  SelectCubit(T initialValue) : super(initialValue);

  void setSelectedValue(T value) {
    emit(value);
  }
}
