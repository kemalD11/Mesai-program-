
import 'package:flutter/material.dart';

void main() => runApp(MesaiTakipApp());

class MesaiTakipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesai Takip Programı',
      home: MesaiTakipEkrani(),
    );
  }
}

class MesaiTakipEkrani extends StatefulWidget {
  @override
  _MesaiTakipEkraniState createState() => _MesaiTakipEkraniState();
}

class _MesaiTakipEkraniState extends State<MesaiTakipEkrani> {
  TimeOfDay? girisSaati;
  TimeOfDay? cikisSaati;
  String sonuc = '';

  Duration _hesaplaNetSure(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final totalMinutes = endMinutes - startMinutes - 45;
    return Duration(minutes: totalMinutes);
  }

  void _hesapla() {
    if (girisSaati != null && cikisSaati != null) {
      final netSure = _hesaplaNetSure(girisSaati!, cikisSaati!);
      final hedef = Duration(hours: 8);
      final fark = hedef - netSure;

      setState(() {
        if (fark.inMinutes > 0) {
          sonuc = 'Çalışma süresi: \${netSure.inHours} sa \${netSure.inMinutes % 60} dk\n'
              'Hedefe \${fark.inMinutes} dakika kaldı.';
        } else {
          sonuc = 'Çalışma süresi: \${netSure.inHours} sa \${netSure.inMinutes % 60} dk\n'
              'Günlük hedef tamamlandı!';
        }
      });
    }
  }

  Future<void> _saatSec(bool isGiris) async {
    final saat = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (saat != null) {
      setState(() {
        if (isGiris) {
          girisSaati = saat;
        } else {
          cikisSaati = saat;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mesai Takip Programı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _saatSec(true),
              child: Text(girisSaati == null
                  ? 'Giriş Saati Seç'
                  : 'Giriş: \${girisSaati!.format(context)}'),
            ),
            ElevatedButton(
              onPressed: () => _saatSec(false),
              child: Text(cikisSaati == null
                  ? 'Çıkış: \${cikisSaati!.format(context)}'
                  : 'Çıkış: \${cikisSaati!.format(context)}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hesapla,
              child: Text('Hesapla'),
            ),
            SizedBox(height: 20),
            Text(sonuc, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
