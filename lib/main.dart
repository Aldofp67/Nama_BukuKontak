import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BerandaPage(),
    );
  }
}

// ==================== MODEL KONTAK ====================

class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori;

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori,
  });
}

// ==================== BERANDA ====================

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final List<Kontak> _daftarKontak = [];

  // Data favorit
  final List<Kontak> _daftarFavorit = [
    Kontak(
      nama: "Aldo Felicia Pratama",
      email: "aldofeliciapratama1000@gmail.com",
      noHp: "085681323455",
      kategori: "Teman",
    ),
  ];

  // ==================== TUGAS 6 ====================

  // Stream untuk pencarian kontak
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  void _navigasiKeTambahKontak() async {
    final Kontak? kontakBaru = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahKontakPage(),
      ),
    );

    if (kontakBaru != null) {
      setState(() {
        _daftarKontak.add(kontakBaru);
      });
    }
  }

  void _navigasiKeTentang() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TentangPage(),
      ),
    );
  }

  // ==================== TUGAS 3 ====================

  // Membuat CircleAvatar dengan inisial nama
  Widget _avatarInisial(String nama) {
    String inisial = nama.trim().isNotEmpty
        ? nama.trim()[0].toUpperCase()
        : '?';

    return CircleAvatar(
      child: Text(
        inisial,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==================== TUGAS 6 ====================

  Widget _daftarKontakWidget() {
    return StreamBuilder<String>(
      stream: _searchController.stream,
      initialData: '',
      builder: (context, snapshot) {
        final kataKunci = snapshot.data?.toLowerCase() ?? '';

        final hasilPencarian = _daftarKontak.where((kontak) {
          final nama = kontak.nama.toLowerCase();
          final kategori = (kontak.kategori ?? '').toLowerCase();

          return nama.contains(kataKunci) ||
              kategori.contains(kataKunci);
        }).toList();

        if (hasilPencarian.isEmpty) {
          return const Center(
            child: Text('Belum ada kontak'),
          );
        }

        return ListView.builder(
          itemCount: hasilPencarian.length,
          itemBuilder: (context, index) {
            final item = hasilPencarian[index];

            return ListTile(
              // TUGAS 3
              leading: _avatarInisial(item.nama),

              title: Text(item.nama),

              subtitle: Text(
                '${item.email}\n'
                '${item.noHp}\n'
                'Kategori: ${item.kategori ?? "Tanpa kategori"}',
              ),
            );
          },
        );
      },
    );
  }

  // ==================== FAVORIT ====================

  Widget _daftarFavoritWidget() {
    if (_daftarFavorit.isEmpty) {
      return const Center(
        child: Text('Belum ada kontak favorit'),
      );
    }

    return ListView.builder(
      itemCount: _daftarFavorit.length,
      itemBuilder: (context, index) {
        final item = _daftarFavorit[index];

        return ListTile(
          leading: _avatarInisial(item.nama),
          title: Text(item.nama),
          subtitle: Text(
            '${item.email}\n'
            '${item.noHp}\n'
            'Kategori: ${item.kategori ?? "Tanpa kategori"}',
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TUGAS 6
    _searchController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BUKU KONTAK'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,

          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.purpleAccent,
            tabs: [
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'Kontak',
              ),
              Tab(
                icon: Icon(Icons.star),
                text: 'Favorit',
              ),
            ],
          ),
        ),

        // ==================== DRAWER ====================

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'BUKU KONTAK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Kontak'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Kontak'),
                onTap: () {
                  Navigator.pop(context);
                  _navigasiKeTambahKontak();
                },
              ),

              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorit'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang'),
                onTap: _navigasiKeTentang,
              ),
            ],
          ),
        ),

        // ==================== TAB ====================

        body: TabBarView(
          children: [
            // ==================== TAB KONTAK ====================

            Column(
              children: [
                // TUGAS 6
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cari kontak',
                      hintText: 'Cari berdasarkan nama atau kategori',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // Kirim teks ke Stream
                    onChanged: (teks) {
                      _searchController.add(teks);
                    },
                  ),
                ),

                Expanded(
                  child: _daftarKontakWidget(),
                ),
              ],
            ),

            // ==================== TAB FAVORIT ====================

            _daftarFavoritWidget(),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _navigasiKeTambahKontak,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// ==================== TAMBAH KONTAK ====================

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  // ==================== TUGAS 5 ====================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();

  // ==================== TUGAS 4 ====================

  final _kategoriController = TextEditingController();

  // ==================== SIMPAN ====================

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final kontakBaru = Kontak(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        noHp: _hpController.text.trim(),
        kategori: _kategoriController.text.trim().isEmpty
            ? null
            : _kategoriController.text.trim(),
      );

      Navigator.pop(context, kontakBaru);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _kategoriController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // ==================== TUGAS 5 ====================

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ==================== NAMA ====================

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              // ==================== EMAIL ====================

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }

                  if (!value.contains('@')) {
                    return 'Email harus mengandung @';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              // ==================== NO HP ====================

              TextFormField(
                controller: _hpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No Handphone',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No Handphone wajib diisi';
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'No Handphone hanya boleh angka';
                  }

                  if (value.trim().length < 10) {
                    return 'No Handphone minimal 10 digit';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 10),

              // ==================== KATEGORI ====================

              TextField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Contoh: Keluarga, Teman, Kerja',
                ),
              ),

              const SizedBox(height: 20),

              // ==================== SIMPAN ====================

              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== TENTANG ====================

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/profile.jpg',
              ),
            ),

            SizedBox(height: 15),

            Text(
              'Aldo FP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text('XII PPLG / RPL'),

            SizedBox(height: 5),

            Text('SMK Negeri 5 Surakarta'),
          ],
        ),
      ),
    );
  }
}