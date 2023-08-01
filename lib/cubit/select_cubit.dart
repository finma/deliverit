import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCubit extends Cubit<String?> {
  SelectCubit(String? initialValue) : super(null);

  void setSelectedValue(String? value) {
    emit(value);
  }
}
