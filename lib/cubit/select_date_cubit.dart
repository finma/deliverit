import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDateCubit extends Cubit<DateTime?> {
  SelectDateCubit(DateTime? initialValue) : super(null);

  void setSelectedValue(DateTime? value) {
    emit(value);
  }
}
