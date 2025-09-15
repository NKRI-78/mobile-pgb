import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  NfcPageState createState() => NfcPageState();
}

class NfcPageState extends State<NfcPage> {
  String result = "Tempel kartu untuk test";

  Future<void> _startNFC() async {
    try {
      print("🔍 Mulai polling NFC...");

      // Cek ketersediaan NFC
      var availability = await FlutterNfcKit.nfcAvailability;
      print("📡 NFC Availability: $availability");

      if (availability != NFCAvailability.available) {
        setState(() {
          result = "NFC tidak tersedia di device ini";
        });
        return;
      }

      // Mulai polling NFC
      NFCTag tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
        iosAlertMessage: "Tempelkan kartu Anda",
      );

      print("✅ Tag ketemu: ${tag.toString()}");

      setState(() {
        result = '''
Type: ${tag.type}
ID: ${tag.id}
Standard: ${tag.standard}
ATQA: ${tag.atqa}
SAK: ${tag.sak}
Historical Bytes: ${tag.historicalBytes}
Protocol Info: ${tag.protocolInfo}
Application Data: ${tag.applicationData}
Manufacturer: ${tag.manufacturer}
System Code: ${tag.systemCode}
HiLayerResponse: ${tag.hiLayerResponse}

NDEF Available: ${tag.ndefAvailable}
NDEF Type: ${tag.ndefType}
''';
      });

      // Tutup sesi
      await FlutterNfcKit.finish(iosAlertMessage: "Sukses");
      print("🔒 Session selesai");
    } catch (e) {
      print("❌ NFC Error: $e");
      setState(() {
        result = "Error: $e";
      });
      await FlutterNfcKit.finish(iosErrorMessage: "Gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test NFC")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFC,
              child: const Text("Scan NFC"),
            ),
          ],
        ),
      ),
    );
  }
}
