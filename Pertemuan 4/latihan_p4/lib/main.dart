import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
      onGenerateRoute: (settings) {
        if (settings.name == '/tambah') return MaterialPageRoute(builder: (_) => const TambahCatatanPage());
        if (settings.name == '/detail') return MaterialPageRoute(builder: (_) => DetailCatatanPage(catatan: settings.arguments as Catatan));
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(judul: 'Belajar Flutter', isi: 'Mempelajari Stateful Widget, Form, dan Navigation.', kategori: 'Kuliah', dibuatPada: DateTime.now()),
  ];

  String _formatTanggal(DateTime t) => "${t.day}/${t.month}/${t.year} ${t.hour}:${t.minute.toString().padLeft(2, '0')}";

  void _hapus(Catatan c) {
    setState(() {
      _catatan.remove(c);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan "${c.judul}" telah dihapus'),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),
      body: _catatan.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
        itemCount: _catatan.length,
        itemBuilder: (context, i) {
          final c = _catatan[i];
          return ListTile(
            title: Text(c.judul),
            subtitle: Text("${c.kategori} • ${_formatTanggal(c.dibuatPada)}"),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _hapus(c)),
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: c),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _bukaTambahCatatan, child: const Icon(Icons.add)),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});
  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  String _kategori = 'Kuliah';

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, Catatan(judul: _judulCtrl.text.trim(), isi: _isiCtrl.text.trim(), kategori: _kategori, dibuatPada: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Minimal 3 karakter' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _kategori,
              items: ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (v) => setState(() => _kategori = v!),
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: _simpan, icon: const Icon(Icons.save), label: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(catatan.judul, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Chip(label: Text(catatan.kategori)),
            const Divider(height: 32),
            Text(catatan.isi),
          ],
        ),
      ),
    );
  }
}