import 'package:flutter/material.dart';
import 'models/databuku.dart';
import 'models/bookmodel.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<HomePage> createState() => _MainScreenState();
}

class _MainScreenState extends State<HomePage> {
  int _selectedIndex = 0; 
  final List<Widget> _pages = <Widget>[
    const HomePage(), // Halaman Beranda (Home)
    const Center(child: Text("Halaman Activity (Activity)", style: TextStyle(fontSize: 20))), 
    const Center(child: Text("Halaman Profil (Profile)", style: TextStyle(fontSize: 20))),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_timeline),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller untuk mengelola input search
  final TextEditingController _searchController = TextEditingController();
  // Daftar buku yang akan ditampilkan (hasil filter)
  List<BookModel> _filteredBooks = bookDummyData;

  @override
  void initState() {
    super.initState();
    
    _filteredBooks = bookDummyData;
    
    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBooks);
    _searchController.dispose();
    super.dispose();
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua data
        _filteredBooks = bookDummyData;
      } else {
        // Filter buku berdasarkan judul atau publisher
        _filteredBooks = bookDummyData.where((book) {
          final titleLower = book.title.toLowerCase();
          final publisherLower = book.publisher.toLowerCase();
          return titleLower.contains(query) || publisherLower.contains(query);
        }).toList();
      }
    });
  }

  // Widget untuk Search Bar
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController, 
      decoration: InputDecoration(
        hintText: 'Search books or authors...',
        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 47, 50, 70)), 
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 248, 248, 248),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        // Tambahkan tombol clear jika teks tidak kosong
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  _filterBooks(); 
                },
              )
            : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_filteredBooks.isEmpty && _searchController.text.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              _buildSearchBar(),
              const Expanded(
                child: Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Tampilan utama
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50.0), 
              
            
              _buildSearchBar(),
              
              const SizedBox(height: 24.0),

              
              if (_searchController.text.isEmpty) ...[
                
                _buildCarouselSlider(),
                
                const SizedBox(height: 24.0),

                
                _buildHorizontalSection(
                  context, 
                  title: 'Last Accessed', 
                  
                  data: bookDummyData.take(3).toList(),
                  isCompact: true,
                ),

                const SizedBox(height: 24.0),

                
                _buildHorizontalSection(
                  context, 
                  title: 'Recommendations for You', 
                
                  data: bookDummyData.reversed.take(4).toList(),
                  isCompact: false, 
                ),
                
                const SizedBox(height: 24.0),
              ],
              
              //  (Grid View)
              _buildResultSection(context),

              const SizedBox(height: 80.0), 
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildResultSection(BuildContext context) {
    final title = _searchController.text.isEmpty ? 'popular' : 'Search Results (${_filteredBooks.length})';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10.0),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(), 
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.70, // Disesuaikan untuk menghindari overflow
          ),
          itemCount: _filteredBooks.length, // Gunakan daftar yang sudah difilter
          itemBuilder: (context, index) {
            final book = _filteredBooks[index];
            return _buildPopularBookCard(book);
          },
        ),
      ],
    );
  }

  
  Widget _buildCarouselSlider() {
    return SizedBox(
      height: 180, 
      child: PageView.builder(
        itemCount: 3, 
        itemBuilder: (context, index) {
          final book = bookDummyData[index % bookDummyData.length];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
              image: DecorationImage(
                image: AssetImage(book.posterPath), 
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken), 
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Todays Book Picks: ${book.title}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover exciting promos now!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk bagian-bagian horizontal (Terakhir Diakses & Rekomendasi)
  Widget _buildHorizontalSection(
    BuildContext context, {
    required String title,
    required List<BookModel> data,
    required bool isCompact,
  }) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: isCompact ? 110 : 250, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final book = data[index];
              return isCompact 
                ? _buildCompactBookCard(book) 
                : _buildLargeBookCard(book);
            },
          ),
        ),
      ],
    );
  }
  
  // Card untuk Terakhir Diakses (Compact Card)
  Widget _buildCompactBookCard(BookModel book) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              book.posterPath, 
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Publisher: ${book.publisher}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                 Text(
                    'Status: ${book.status}',
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                      color: book.status == 'Available' ? Colors.green.shade600 : Colors.red.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card untuk Rekomendasi (Large Card)
  Widget _buildLargeBookCard(BookModel book) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              book.posterPath, 
              height: 180,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  book.publisher,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card untuk Populer (Card dengan detail publisher dan status)
  Widget _buildPopularBookCard(BookModel book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                book.posterPath, 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Detail Buku
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.publisher,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Rating Bintang
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${book.voteAverage}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Spacer(), 
                  //Status Buku
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: book.status == 'Available' ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.status,
                        style: TextStyle(
                          fontSize: 11, 
                          fontWeight: FontWeight.bold,
                          color: book.status == 'Available' ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}