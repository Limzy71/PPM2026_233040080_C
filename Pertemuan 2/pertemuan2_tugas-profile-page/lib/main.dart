import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            const ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
            // const ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Menu Pengaturan'),
                    content: const Text('Fitur pengaturan belum tersedia saat ini.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: const NetworkImage('https://avatars.githubusercontent.com/u/145044598?v=4'),
                    // child: Icon(Icons.person, size: 60, color: Colors.white),
                    // child: Text('😎', style: TextStyle(fontSize: 50)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'La Ode Muh, Ikhsan Mbala',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')),
                Expanded(child: StatBox(label: 'Teman', value: '128')),
                Expanded(child: StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),
            const SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.',
            ),
            const SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: 'Universitas Pasundan - Semester 6\nIPK: 3.75',
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Colors.blue, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Skills',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: const [
                              Chip(label: Text('Laravel')),
                              Chip(label: Text('Flutter')),
                              Chip(label: Text('PHP')),
                              Chip(label: Text('HTML')),
                              Chip(label: Text('CSS')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: 'Coding, Membaca, Game',
            ),
            const SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: 'laodemuhikhsan18.com\n+62 812-4231-0477',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),

      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      //     BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      //   ],
      // ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String label;
  final String value;
  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CategoryPage(name: name)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const DisplayDemo(),
      'Button' => const ButtonDemo(),
    // 'Input' => const InputDemo(),
    // 'Feedback' => const FeedbackDemo(),
    // 'Layout' => const LayoutDemo(),
      _ => const Center(child: Text('Belum Dibuat')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

class DisplayDemo extends StatelessWidget {
  const DisplayDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text('CircleAvatar & Icon', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: const [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 12),
            CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check)),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
          ],
        ),
      ],
    );
  }
}

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        const SizedBox(height: 8),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    );
  }
}
