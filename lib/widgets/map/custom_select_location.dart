import 'dart:convert';

import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';

class CustomSelectLocationWidget extends StatefulWidget {
  const CustomSelectLocationWidget({
    super.key,
    this.administration,
  });
  final SelectedAdministration? administration;

  static Future<SelectedAdministration?> go(BuildContext context,
      {SelectedAdministration? administration}) async {
    return Navigator.push<SelectedAdministration?>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomSelectLocationWidget(
          administration: administration,
        ),
      ),
    );
  }

  @override
  State<CustomSelectLocationWidget> createState() =>
      _CustomSelectLocationWidgetState();
}

class _CustomSelectLocationWidgetState
    extends State<CustomSelectLocationWidget> {
  List<AdministrationModel> provinces = [];
  List<AdministrationModel> cities = [];
  List<AdministrationModel> districts = [];
  List<AdministrationModel> subDistricts = [];
  List<AdministrationModel> postalCodes = [];
  AdministrationModel? province;
  AdministrationModel? city;
  AdministrationModel? district;
  AdministrationModel? subDistrict;
  AdministrationModel? postalCode;

  TextEditingController searchController = TextEditingController();

  int menuIndex = 0;

  var client = getIt<BaseNetworkClient>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAdministration();
    });
  }

  void getAdministration() {
    if (widget.administration != null) {
      province = widget.administration?.province;
      city = widget.administration?.city;
      district = widget.administration?.district;
      subDistrict = widget.administration?.subDistrict;
      postalCode = widget.administration?.postalCode;
      menuIndex = 3;
      setState(() {});
    }
    fetchProvince();
    if (province != null) fetchCity(province!.id);
    if (city != null) fetchDistrict(city!.id);
    if (district != null) fetchSubDistrictV2(district!.id);
    if (city != null && district != null) {
      fetchPostalCodesV2(city!.name, district!.name);
    }
  }

  void fetchProvince() async {
    try {
      var res = await client
          .get(Uri.parse("https://api.wilayah.site/wilayah/province"));

      final List data = jsonDecode(res.body)['data'];

      provinces = data
          .map((e) => AdministrationModel(
                id: e['code'],
                name: e['nama'],
              ))
          .toList();

      setState(() {});
    } catch (e) {
      // Handle error silently or show log if needed
    }
  }

  void fetchCity(String provinceCode) async {
    try {
      final res = await client.get(
        Uri.parse("https://api.wilayah.site/wilayah/city?code=$provinceCode"),
      );

      final body = jsonDecode(res.body);
      final data = body['data'];

      if (data != null && data is List) {
        cities = data
            .map((e) => AdministrationModel(
                  id: e['code'] ?? '',
                  name: e['nama'] ?? '',
                ))
            .toList();
      } else {
        cities = [];
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetchCity: $e");
    }
  }

  void fetchDistrict(String cityCode) async {
    try {
      var res = await client.get(
        Uri.parse("https://api.wilayah.site/wilayah/district?code=$cityCode"),
      );

      final body = jsonDecode(res.body);
      final data = body['data'];

      if (data != null && data is List) {
        districts = data
            .map((e) => AdministrationModel(
                  id: e['code'] ?? '',
                  name: e['nama'] ?? '',
                ))
            .toList();
      } else {
        districts = [];
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetchDistrict: $e");
    }
  }

  void fetchSubDistrictV2(String districtCode) async {
    try {
      var res = await client.get(
        Uri.parse(
            "https://api.wilayah.site/wilayah/subdistrict?code=$districtCode"),
      );

      final body = jsonDecode(res.body);
      final data = body['data'];

      if (data != null && data is List) {
        subDistricts = data
            .map((e) => AdministrationModel(
                  id: e['code'] ?? '',
                  name: e['nama'] ?? '',
                ))
            .toList();
      } else {
        subDistricts = [];
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetchSubDistrictV2: $e");
    }
  }

  void fetchPostalCodesV2(String cityName, String districtName) async {
    try {
      final code = subDistrict?.id;
      if (code == null) {
        debugPrint("subDistrict ID null, tidak bisa fetch postal code");
        return;
      }

      debugPrint("Fetching postal code with code: $code");

      final res = await client.get(
        Uri.parse("https://api.wilayah.site/wilayah/postalcode?code=$code"),
      );

      final data = jsonDecode(res.body)['data'];

      debugPrint("Postal code API response: $data");

      if (data != null && data is Map<String, dynamic>) {
        postalCodes = [
          AdministrationModel(
            id: data['postal_code'],
            name: data['postal_code'],
          )
        ];
      } else {
        postalCodes = [];
      }

      setState(() {});
    } catch (e) {
      debugPrint("Error fetchPostalCodesV2: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headers,
            _subMenuSelected,
            _titleSelected,
            _listContent,
          ],
        ),
      ),
    );
  }

  Widget get _headers => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (text) {
                      setState(() {});
                    },
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search ${titleSelectedString(menuIndex)}',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              )
            ],
          ),
        ),
      );

  Widget get _subMenuSelected => Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Location',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: List.generate(menuIndex + 1, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      menuIndex = index;
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: index == menuIndex
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          index == menuIndex
                              ? getChooseByIndex(index) != '-'
                                  ? getChooseByIndex(index)
                                  : "Select ${titleSelectedString(index)}"
                              : getChooseByIndex(index),
                          style: TextStyle(
                              fontWeight: index == menuIndex
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: index == menuIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : null),
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      );

  Widget get _titleSelected => Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Text(
          titleSelectedString(menuIndex),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );

  Widget get _listContent {
    final list = getListByMenu(menuIndex);
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: List.generate(list.length, (index) {
          final data = list[index];
          return ListTile(
            onTap: () {
              switch (menuIndex) {
                case 0:
                  province = data;
                  city = null;
                  district = null;
                  subDistrict = null;
                  postalCode = null;

                  cities = [];
                  districts = [];
                  subDistricts = [];
                  postalCodes = [];

                  menuIndex = 1;
                  searchController.text = '';
                  fetchCity(data.id);
                  setState(() {});
                  return;

                case 1:
                  city = data;
                  district = null;
                  subDistrict = null;
                  postalCode = null;

                  districts = [];
                  subDistricts = [];
                  postalCodes = [];

                  menuIndex = 2;
                  searchController.text = '';
                  fetchDistrict(data.id);
                  setState(() {});
                  return;

                case 2:
                  district = data;
                  subDistrict = null;
                  postalCode = null;

                  subDistricts = [];
                  postalCodes = [];

                  menuIndex = 3;
                  searchController.text = '';
                  fetchSubDistrictV2(data.id);
                  setState(() {});
                  return;

                case 3:
                  subDistrict = data;
                  postalCode = null;

                  postalCodes = [];

                  menuIndex = 4;
                  fetchPostalCodesV2(city!.name, district!.name);
                  setState(() {});
                  return;

                case 4:
                  postalCode = data;
                  Navigator.pop(
                    context,
                    SelectedAdministration(
                      city: city!,
                      province: province!,
                      district: district!,
                      subDistrict: subDistrict!,
                      postalCode: postalCode!,
                    ),
                  );
                  return;
              }
            },
            title: Text(
              data.name,
            ),
          );
        }),
      ),
    );
  }

  String titleSelectedString(int index) {
    switch (index) {
      case 1:
        return 'City';
      case 2:
        return 'District';
      case 3:
        return 'Subdistrict';
      case 4:
        return 'Postal Code';
      default:
        return 'Province';
    }
  }

  String getChooseByIndex(int index) {
    switch (index) {
      case 1:
        return city?.name ?? '-';
      case 2:
        return district?.name ?? '-';
      case 3:
        return subDistrict?.name ?? '-';
      case 4:
        return postalCode?.name ?? '-';
      default:
        return province?.name ?? '-';
    }
  }

  List<AdministrationModel> getListByMenu(int index) {
    List<AdministrationModel> list = [];
    switch (index) {
      case 0:
        list = provinces;
        break;
      case 1:
        list = cities;
        break;
      case 2:
        list = districts;
        break;
      case 3:
        list = subDistricts;
        break;
      case 4:
        list = postalCodes;
        break;
    }

    return list
        .where((element) => element.name
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
  }
}

class SelectedAdministration {
  final AdministrationModel province;
  final AdministrationModel city;
  final AdministrationModel district;
  final AdministrationModel subDistrict;
  final AdministrationModel postalCode;

  SelectedAdministration({
    required this.province,
    required this.city,
    required this.district,
    required this.subDistrict,
    required this.postalCode,
  });
}

class AdministrationModel {
  final String id;
  final String name;
  final String? subdistrictName;

  AdministrationModel({
    required this.id,
    required this.name,
    this.subdistrictName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'subdistricts_name': subdistrictName,
    };
  }

  factory AdministrationModel.fromMap(Map<String, dynamic> map) {
    return AdministrationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      subdistrictName: map['subdistricts_name'] as String?,
    );
  }

  /// Tambahan khusus untuk API https://api.wilayah.site
  factory AdministrationModel.fromWilayahAPI(Map<String, dynamic> map) {
    return AdministrationModel(
      id: map['code'].toString(),
      name: map['nama'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdministrationModel.fromJson(String source) =>
      AdministrationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
