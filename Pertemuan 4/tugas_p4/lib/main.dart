import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
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
        if (settings.name == '/edit') return MaterialPageRoute(builder: (_) => TambahCatatanPage(catatanLama: settings.arguments as Catatan));
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
    Catatan(
      id: DateTime.now().toString(),
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      email: 'mahasiswa@kampus.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  String _filterKategori = 'Semua';

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

  Future<void> _bukaDetail(Catatan c) async {
    final hasil = await Navigator.pushNamed(context, '/detail', arguments: c);
    if (hasil is Catatan) {
      final index = _catatan.indexWhere((element) => element.id == hasil.id);
      if (index != -1) {
        setState(() => _catatan[index] = hasil);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Catatan "${hasil.judul}" diperbarui')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCatatan = _filterKategori == 'Semua'
        ? _catatan
        : _catatan.where((c) => c.kategori == _filterKategori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          DropdownButton<String>(
            value: _filterKategori,
            dropdownColor: Colors.indigo.shade50,
            underline: const SizedBox(),
            icon: const Icon(Icons.filter_list),
            items: ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'].map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (v) => setState(() => _filterKategori = v!),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: filteredCatatan.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
        itemCount: filteredCatatan.length,
        itemBuilder: (context, i) {
          final c = filteredCatatan[i];
          return ListTile(
            title: Text(c.judul),
            subtitle: Text("${c.kategori} • ${_formatTanggal(c.dibuatPada)}"),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _hapus(c)),
            onTap: () => _bukaDetail(c),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _bukaTambahCatatan, child: const Icon(Icons.add)),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;
  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _kategori = 'Kuliah';

  @override
  void initState() {
    super.initState();
    if (widget.catatanLama != null) {
      _judulCtrl.text = widget.catatanLama!.judul;
      _isiCtrl.text = widget.catatanLama!.isi;
      _emailCtrl.text = widget.catatanLama!.email;
      _kategori = widget.catatanLama!.kategori;
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final catatanBaru = Catatan(
      id: widget.catatanLama?.id ?? DateTime.now().toString(),
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(),
    );
    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.catatanLama == null ? 'Tambah Catatan' : 'Edit Catatan')),
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
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Format email tidak valid';
                return null;
              },
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
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final hasil = await Navigator.pushNamed(context, '/edit', arguments: catatan);
              if (hasil != null) {
                Navigator.pop(context, hasil);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(catatan.judul, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(catatan.kategori)),
                Chip(
                  label: Text(catatan.email),
                  avatar: const Icon(Icons.email, size: 16),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(catatan.isi),
          ],
        ),
      ),
    );
  }
}