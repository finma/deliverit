import 'package:flutter/material.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/select_cubit.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_radio_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class CreateAddressPage extends StatelessWidget {
  CreateAddressPage({super.key});

  // controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController subdistrictController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final SelectCubit _selectCubit = SelectCubit(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alamat Baru',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //* FULL NAME
                  CustomTextFormField(
                    controller: nameController,
                    hintText: 'Nama',
                    iconAsset: AppAsset.iconProfile,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* NO TELP
                  CustomTextFormField(
                    controller: noTelpController,
                    hintText: 'No Telepon',
                    iconAsset: AppAsset.iconCall,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'No Telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* PROVINCE
                  CustomTextFormField(
                    controller: provinceController,
                    hintText: 'Provinsi',
                    icon: const Icon(Icons.location_city_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Provinsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* CITY
                  CustomTextFormField(
                    controller: cityController,
                    hintText: 'Kota/Kabupaten',
                    icon: const Icon(Icons.location_city_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kota/Kabupaten tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* subdistrict
                  CustomTextFormField(
                    controller: subdistrictController,
                    hintText: 'Kecamatan',
                    icon: const Icon(Icons.location_city_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kecamatan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* POST CODE
                  CustomTextFormField(
                    controller: postCodeController,
                    hintText: 'Kode Pos',
                    icon: const Icon(Icons.numbers),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode Pos tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //* FULL ADDRESS
                  CustomTextFormField(
                    controller: fullAddressController,
                    hintText: 'Alamat Lengkap',
                    iconAsset: AppAsset.iconLocation,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode Pos tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            //* SELECT ADDRESS
            CustomRadioButton(
              value: 1,
              selectCubit: _selectCubit,
              title: 'Jadikan sebagai alamat utama',
            ),
            CustomRadioButton(
              value: 2,
              selectCubit: _selectCubit,
              title: 'Jadikan sebagai alamat toko',
            ),
            CustomRadioButton(
              value: 3,
              selectCubit: _selectCubit,
              title: 'Atur sebagai alamat pengembalian',
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                // TODO: Pilih Lokasi
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        ImageIcon(
                          AssetImage(AppAsset.iconLocation),
                          color: AppColor.primary,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Pilih Lokasi',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            ButtonCustom(
                label: 'SIMPAN',
                onTap: () {
                  // TODO: Simpan Alamat
                  var address = {
                    'name': nameController.text,
                    'noTelp': noTelpController.text,
                    'province': provinceController.text,
                    'city': cityController.text,
                    'subdistrict': subdistrictController.text,
                    'postCode': postCodeController.text,
                    'fullAddress': fullAddressController.text,
                    'isMain': _selectCubit.state,
                  };

                  if (_formKey.currentState!.validate()) {
                    debugPrint('$address');
                  }
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
