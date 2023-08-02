import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/select_cubit.dart';
import '/cubit/select_date_cubit.dart';
import '/widgets/custom_button_widget.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final Map<String, dynamic> user = {
    'name': 'John Doe',
    'email': 'abc@gmail.comabc@gmail.comabc@gmail.com',
    'noTelp': '081234567890',
  };

  final SelectCubit selectedGender = SelectCubit(null);
  final SelectDateCubit selectedBirth = SelectDateCubit(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 152,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColor.primary, Colors.white],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //* AVATAR
                    Positioned(
                      top: 100,
                      left: (MediaQuery.of(context).size.width - 100) / 2,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            AppAsset.profile,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    itemAccount(title: 'Nama', value: '${user['name']}'),
                    const Divider(thickness: 3, height: 0),
                    itemAccount(
                        title: 'No Telepon', value: '${user['noTelp']}'),
                    const Divider(thickness: 3, height: 0),
                    itemAccount(title: 'Email', value: '${user['email']}'),
                    const Divider(thickness: 3, height: 0),
                    itemAccountGender(title: 'Jenis Kelamin'),
                    const Divider(thickness: 3, height: 0),
                    itemAccountBirth(title: 'Tanggal Lahir', context: context),
                    const Divider(thickness: 3, height: 0),
                    const Spacer(),
                    ButtonCustom(
                      label: 'Simpan',
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding itemAccount({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Padding itemAccountGender({required String title}) {
    final List<String> genderOptions = ['Pria', 'Wanita'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<SelectCubit, dynamic>(
            bloc: selectedGender,
            builder: (context, state) {
              return Expanded(
                // flex: 2,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: state,
                    onChanged: (value) {
                      selectedGender.setSelectedValue(value);
                    },
                    isExpanded: true,
                    hint: const Text(
                      'Atur sekarang',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    items: genderOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    style: const TextStyle(fontSize: 16),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding itemAccountBirth({
    required String title,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<SelectDateCubit, DateTime?>(
            bloc: selectedBirth,
            builder: (context, state) {
              return Expanded(
                flex: 6,
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != DateTime.now()) {
                      selectedBirth.setSelectedValue(picked);
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        // isDense: true,
                        isCollapsed: true,
                        hintText:
                            state != null ? formatDate(state) : 'Atur sekarang',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: state != null ? Colors.black : Colors.grey,
                        ),
                        border: InputBorder.none,
                        suffixIcon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        suffixIconConstraints: const BoxConstraints()),
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
