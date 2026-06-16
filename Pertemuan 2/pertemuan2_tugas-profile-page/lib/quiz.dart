import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F4F9),
        primaryColor: const Color(0xFF5E5CE6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5E5CE6)),
        fontFamily: 'Roboto',
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'La Ode Muh. Ikhsan Mbala';
  String about = 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.';
  String education = 'Teknik Informatika - Semester 6';
  String location = 'Bandung, Jawa Barat';
  String contact = 'ikhsan@student.ac.id';
  String skillsString = 'Flutter, Dart, Java, Git';
  String? profileImageBase64;

  String pengTitle = '';
  String pengDesc = '';
  String? pengImageBase64;

  final Color primaryPurple = const Color(0xFF5E5CE6);
  final Color lightPurpleBg = const Color(0xFFEDECFA);
  final Color borderColor = const Color(0xFFDEDDF5);

  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? name;
      about = prefs.getString('about') ?? about;
      education = prefs.getString('education') ?? education;
      location = prefs.getString('location') ?? location;
      contact = prefs.getString('contact') ?? contact;
      skillsString = prefs.getString('skills') ?? skillsString;
      profileImageBase64 = prefs.getString('profileImageBase64');

      pengTitle = prefs.getString('pengTitle') ?? pengTitle;
      pengDesc = prefs.getString('pengDesc') ?? pengDesc;
      pengImageBase64 = prefs.getString('pengImageBase64');
    });
  }

  Future<void> _saveDataToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('about', about);
    await prefs.setString('education', education);
    await prefs.setString('location', location);
    await prefs.setString('contact', contact);
    await prefs.setString('skills', skillsString);
    if (profileImageBase64 != null) {
      await prefs.setString('profileImageBase64', profileImageBase64!);
    }

    await prefs.setString('pengTitle', pengTitle);
    await prefs.setString('pengDesc', pengDesc);
    if (pengImageBase64 != null) {
      await prefs.setString('pengImageBase64', pengImageBase64!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDECFA),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryPurple),
              child: const Text(
                'Menu Utama',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryHome()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadPengalamanPage(
                      currentTitle: pengTitle,
                      currentDesc: pengDesc,
                      currentImageBase64: pengImageBase64,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    pengTitle = result['title'];
                    pengDesc = result['desc'];
                    pengImageBase64 = result['image'];
                  });
                  await _saveDataToPrefs();
                }
              },
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: borderColor,
                    backgroundImage: profileImageBase64 != null
                        ? MemoryImage(base64Decode(profileImageBase64!))
                        : const NetworkImage('https://avatars.githubusercontent.com/u/145044598?v=4') as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Mahasiswa Teknik Informatika', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
            SectionCard(icon: Icons.info, title: 'Tentang Saya', content: about, iconColor: primaryPurple),
            SectionCard(icon: Icons.school, title: 'Pendidikan', content: education, iconColor: primaryPurple),
            SectionCard(icon: Icons.location_on, title: 'Lokasi', content: location, iconColor: primaryPurple),
            SectionCard(icon: Icons.email, title: 'Kontak', content: contact, iconColor: primaryPurple),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: primaryPurple, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Skills', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: skillsString.split(',').map((skill) {
                            return SkillChip(label: skill.trim(), color: primaryPurple);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.book, color: primaryPurple, size: 24),
                      const SizedBox(width: 16),
                      const Text('Pengalaman', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: lightPurpleBg, shape: BoxShape.circle),
                        child: Text(
                            pengTitle.isNotEmpty ? '1' : '0',
                            style: TextStyle(color: primaryPurple, fontSize: 10, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (pengTitle.isNotEmpty || pengDesc.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8FC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor.withOpacity(0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pengImageBase64 != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(
                                base64Decode(pengImageBase64!),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Container(
                              height: 50, width: 50,
                              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pengTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(pengDesc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: lightPurpleBg,
        foregroundColor: primaryPurple,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: borderColor)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                currentName: name,
                currentAbout: about,
                currentEducation: education,
                currentLocation: location,
                currentContact: contact,
                currentSkills: skillsString,
                currentImageBase64: profileImageBase64,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              name = result['name'];
              about = result['about'];
              education = result['education'];
              location = result['location'];
              contact = result['contact'];
              skillsString = result['skills'];
              if (result['image'] != null) profileImageBase64 = result['image'];
            });
            await _saveDataToPrefs();
          }
        },
        icon: const Icon(Icons.edit, size: 20),
        label: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class UploadPengalamanPage extends StatefulWidget {
  final String currentTitle;
  final String currentDesc;
  final String? currentImageBase64;

  const UploadPengalamanPage({
    super.key,
    required this.currentTitle,
    required this.currentDesc,
    this.currentImageBase64,
  });

  @override
  State<UploadPengalamanPage> createState() => _UploadPengalamanPageState();
}

class _UploadPengalamanPageState extends State<UploadPengalamanPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String? _selectedImageBase64;

  final Color primaryPurple = const Color(0xFF5E5CE6);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDesc);
    _selectedImageBase64 = widget.currentImageBase64;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBase64 = base64Encode(imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Upload Pengalaman', style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDEDDF5)),
                  image: _selectedImageBase64 != null
                      ? DecorationImage(image: MemoryImage(base64Decode(_selectedImageBase64!)), fit: BoxFit.contain)
                      : null,
                ),
                child: _selectedImageBase64 == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 48, color: primaryPurple.withOpacity(0.6)),
                    const SizedBox(height: 8),
                    Text('Ketuk untuk pilih gambar', style: TextStyle(color: primaryPurple.withOpacity(0.8), fontWeight: FontWeight.w500)),
                    Text('Bisa berjalan aman di Web & Mobile', style: TextStyle(color: primaryPurple.withOpacity(0.5), fontSize: 12)),
                  ],
                )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            Text('Informasi Pengalaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryPurple)),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul *',
                prefixIcon: const Icon(Icons.title),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDEDDF5))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDEDDF5))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Icon(Icons.description),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDEDDF5))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDEDDF5))),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A528E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'title': _titleController.text,
                  'desc': _descController.text,
                  'image': _selectedImageBase64,
                });
              },
              icon: const Icon(Icons.save, color: Colors.white, size: 18),
              label: const Text('Simpan Pengalaman', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentAbout;
  final String currentEducation;
  final String currentLocation;
  final String currentContact;
  final String currentSkills;
  final String? currentImageBase64;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentAbout,
    required this.currentEducation,
    required this.currentLocation,
    required this.currentContact,
    required this.currentSkills,
    this.currentImageBase64,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _aboutController;
  late TextEditingController _eduController;
  late TextEditingController _locationController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;
  String? _selectedImageBase64;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _aboutController = TextEditingController(text: widget.currentAbout);
    _eduController = TextEditingController(text: widget.currentEducation);
    _locationController = TextEditingController(text: widget.currentLocation);
    _contactController = TextEditingController(text: widget.currentContact);
    _skillsController = TextEditingController(text: widget.currentSkills);
    _selectedImageBase64 = widget.currentImageBase64;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBase64 = base64Encode(imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Foto Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Center(
              child: InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    image: _selectedImageBase64 != null
                        ? DecorationImage(image: MemoryImage(base64Decode(_selectedImageBase64!)), fit: BoxFit.cover)
                        : const DecorationImage(image: NetworkImage('https://avatars.githubusercontent.com/u/145044598?v=4'), fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Ketuk untuk pilih foto', style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 24),
            const Text('Informasi Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _aboutController, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio / Tentang', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _eduController, decoration: const InputDecoration(labelText: 'Pendidikan', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _contactController, decoration: const InputDecoration(labelText: 'Kontak', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
                controller: _skillsController,
                decoration: const InputDecoration(
                    labelText: 'Skills',
                    hintText: 'Pisahkan dengan koma (contoh: Flutter, Dart, Java)',
                    border: OutlineInputBorder()
                )
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A528E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'about': _aboutController.text,
                  'education': _eduController.text,
                  'location': _locationController.text,
                  'contact': _contactController.text,
                  'skills': _skillsController.text,
                  'image': _selectedImageBase64,
                });
              },
              child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
  final Color iconColor;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEDDF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(height: 1.4, color: Colors.black87, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  final Color color;
  const SkillChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Button', Icons.smart_button, Colors.orange),
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
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}