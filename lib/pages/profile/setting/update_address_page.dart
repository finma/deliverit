import 'package:deliverit/model/address.dart';
import 'package:flutter/material.dart';

import '/config/app_asset.dart';
import '/config/app_color.dart';
import '/cubit/select_cubit.dart';
import '/widgets/custom_button_widget.dart';
import '/widgets/custom_radio_button_widget.dart';
import '/widgets/custom_text_form_field_widget.dart';

class UpdateAddressPage extends StatefulWidget {
  const UpdateAddressPage({super.key, required this.address});

  final Address address;

  @override
  State<UpdateAddressPage> createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  // controller
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController provinceController;
  late TextEditingController cityController;
  late TextEditingController subdistrictController;
  late TextEditingController postalCodeController;
  late TextEditingController addressController;

  final _formKey = GlobalKey<FormState>();
  late SelectCubit _selectCubit;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.address.name);
    phoneController = TextEditingController(text: widget.address.phoneNumber);
    provinceController = TextEditingController(text: widget.address.province);
    cityController = TextEditingController(text: widget.address.city);
    subdistrictController =
        TextEditingController(text: widget.address.subdistrict);
    postalCodeController =
        TextEditingController(text: widget.address.postalCode);
    addressController = TextEditingController(text: widget.address.address);

    _selectCubit = SelectCubit(widget.address.isMain);
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('${address.name}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Alamat',
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
                    controller: phoneController,
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
                    controller: postalCodeController,
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
                    controller: addressController,
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
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
                    Icon(
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
                  Address address = Address(
                    name: nameController.text,
                    phoneNumber: phoneController.text,
                    province: provinceController.text,
                    city: cityController.text,
                    subdistrict: subdistrictController.text,
                    postalCode: postalCodeController.text,
                    address: addressController.text,
                    isMain: _selectCubit.state,
                  );

                  if (_formKey.currentState!.validate()) {
                    debugPrint('${address.toJson()}');
                  }
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
