import 'package:deliverit/config/app_color.dart';
import 'package:deliverit/cubit/select_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    required this.value,
    required this.title,
    required this.selectCubit,
  }) : super(key: key);

  final String title;
  final dynamic value;
  final SelectCubit selectCubit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectCubit.setSelectedValue(value),
      child: ListTile(
        title: Text(title),
        trailing: BlocBuilder<SelectCubit, dynamic>(
          bloc: selectCubit,
          builder: (context, state) {
            bool isSelected = value == state;

            return Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
