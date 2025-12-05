import 'package:flutter/material.dart';

// Model dummy untuk Riwayat Pinjam
class BorrowedBookModel {
  final int id;
  final String title;
  final String posterPath;

  BorrowedBookModel({required this.id, required this.title, required this.posterPath});
}

// Dummy Data Riwayat Pinjam
final List<BorrowedBookModel> dummyBorrowedBooks = [
  BorrowedBookModel(id: 1, title: "Tentang Kamu", posterPath: 'assets/Tentang Kamu.png'),
  BorrowedBookModel(id: 2, title: "Negeri Para Bedebah", posterPath: 'assets/NegeriParaBedebah.png'),
  BorrowedBookModel(id: 3, title: "Filosofi", posterPath: 'assets/Filosofi.png'),
  BorrowedBookModel(id: 4, title: "Pulang", posterPath: 'assets/Pulang.png'),
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildBookItem(BorrowedBookModel book) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: book.posterPath.isNotEmpty
                  ? Image.asset(book.posterPath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40, color: Color(0xFF4A6572)))
                  : const Icon(Icons.book, size: 40, color: Color(0xFF4A6572)),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            book.title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Dialog Logout dengan konfirmasi
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('What are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logout dan kembali ke halaman login
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 8),

          // Avatar Profil
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: const Color(0xFF4A6572), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/kimi.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Color(0xFF4A6572),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            '𝐉oy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF344955),
            ),
          ),

          const SizedBox(height: 12),

          // Tombol Edit Profil
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile clicked!')),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white, size: 18),
            label: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6572),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
          ),

          const SizedBox(height: 30),

          // Riwayat Pinjam title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'History of Borrowing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Horizontal list riwayat pinjam
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: dummyBorrowedBooks.length,
              itemBuilder: (context, index) {
                return _buildBookItem(dummyBorrowedBooks[index]);
              },
            ),
          ),

          const SizedBox(height: 24),

          const Divider(indent: 20, endIndent: 20, thickness: 1),

          // Email
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF4A6572)),
            title: const Text('Email'),
            subtitle: const Text('joypacarkimi@email.com'),
            onTap: () {},
          ),

          // Nomor Telepon
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF4A6572)),
            title: const Text('Number Phone'),
            subtitle: const Text('+62 812-3456-7890'),
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Tombol Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 45),
                elevation: 5,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}