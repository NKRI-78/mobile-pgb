import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../cubit/register_ktp_cubit.dart';

class CustomTextfieldRegisterKtp extends StatelessWidget {
  const CustomTextfieldRegisterKtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FieldNik(),
        _FieldNama(),
        _FieldTTL(),
        _FieldJenisKelaminDanGolDarah(),
        _FieldAlamat(),
        _FieldRTRW(),
        _FieldKeldanDesa(),
        _FieldKecamatan(),
        _FieldKabupaten(),
        _FieldProvinsi(),
        _FieldAgama(),
        _FieldStatusPerkawinan(),
        _FieldPekerjaan(),
        _FieldKewarganegaraan(),
        _FieldBerlakuHingga(),
      ],
    );
  }
}

class _FieldNik extends StatelessWidget {
  const _FieldNik();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'NIK',
          keyboardType: TextInputType.number,
          initialValue: state.nik,
          maxLength: 16,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'NIK tidak boleh kosong';
            } else if (value.length != 16) {
              return 'NIK harus terdiri dari 16 digit';
            }
            return null;
          },
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(nik: value));
          },
        );
      },
    );
  }
}

class _FieldNama extends StatelessWidget {
  const _FieldNama();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Nama',
          initialValue: state.nama,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(nama: value));
          },
        );
      },
    );
  }
}

class _FieldTTL extends StatelessWidget {
  const _FieldTTL();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Tempat/Tanggal Lahir',
          initialValue: state.ttl,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(ttl: value));
          },
        );
      },
    );
  }
}

class _FieldJenisKelaminDanGolDarah extends StatelessWidget {
  const _FieldJenisKelaminDanGolDarah();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        final cubit = context.read<RegisterKtpCubit>();
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildTextFormField(
                label: 'Jenis Kelamin',
                initialValue: state.jenisKelamin,
                onChanged: (value) => cubit.copyState(
                  newState: state.copyWith(jenisKelamin: value),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: _buildTextFormField(
                label: 'Gol. Darah',
                initialValue: state.golDarah,
                onChanged: (value) => cubit.copyState(
                  newState: state.copyWith(golDarah: value),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FieldAlamat extends StatelessWidget {
  const _FieldAlamat();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Alamat',
          initialValue: state.alamat,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(alamat: value));
          },
        );
      },
    );
  }
}

class _FieldRTRW extends StatelessWidget {
  const _FieldRTRW();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'RT/RW',
          initialValue: state.rtRw,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(rtRw: value));
          },
        );
      },
    );
  }
}

class _FieldKeldanDesa extends StatelessWidget {
  const _FieldKeldanDesa();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Kel/Desa',
          initialValue: state.kelDesa,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(kelDesa: value));
          },
        );
      },
    );
  }
}

class _FieldKecamatan extends StatelessWidget {
  const _FieldKecamatan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Kecamatan',
          initialValue: state.kecamatan,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(kecamatan: value));
          },
        );
      },
    );
  }
}

class _FieldKabupaten extends StatelessWidget {
  const _FieldKabupaten();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Kabupaten',
          initialValue: state.kabupaten,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(kabupaten: value));
          },
        );
      },
    );
  }
}

class _FieldProvinsi extends StatelessWidget {
  const _FieldProvinsi();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Provinsi',
          initialValue: state.provinsi,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(provinsi: value));
          },
        );
      },
    );
  }
}

class _FieldAgama extends StatelessWidget {
  const _FieldAgama();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Agama',
          initialValue: state.agama,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(agama: value));
          },
        );
      },
    );
  }
}

class _FieldStatusPerkawinan extends StatelessWidget {
  const _FieldStatusPerkawinan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Status Perkawinan',
          initialValue: state.statusPerkawinan,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(
                newState: cubit.state.copyWith(statusPerkawinan: value));
          },
        );
      },
    );
  }
}

class _FieldPekerjaan extends StatelessWidget {
  const _FieldPekerjaan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Pekerjaan',
          initialValue: state.pekerjaan,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(newState: cubit.state.copyWith(pekerjaan: value));
          },
        );
      },
    );
  }
}

class _FieldKewarganegaraan extends StatelessWidget {
  const _FieldKewarganegaraan();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Kewarganegaraan',
          initialValue: state.kewarganegaraan,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(
                newState: cubit.state.copyWith(kewarganegaraan: value));
          },
        );
      },
    );
  }
}

class _FieldBerlakuHingga extends StatelessWidget {
  const _FieldBerlakuHingga();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Berlaku Hingga',
          initialValue: state.berlakuHingga,
          onChanged: (value) {
            var cubit = context.read<RegisterKtpCubit>();
            cubit.copyState(
                newState: cubit.state.copyWith(berlakuHingga: value));
          },
        );
      },
    );
  }
}

Widget _buildTextFormField({
  required String label,
  required ValueChanged<String> onChanged,
  TextInputType keyboardType = TextInputType.text,
  String? initialValue,
  bool readOnly = true,
  int? maxLength,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: TextFormField(
          readOnly: readOnly,
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            counterText: '',
          ),
          style: AppTextStyles.textStyleNormal.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
      ),
    ),
  );
}
