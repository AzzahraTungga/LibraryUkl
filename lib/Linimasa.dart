import 'package:flutter/material.dart';

// Model Book
class Book {
  final String title;
  final String publisher;
  final double rating;
  final String imageUrl;
  final String synopsis;
  final String status;

  Book({
    required this.title,
    required this.publisher,
    required this.rating,
    required this.imageUrl,
    required this.synopsis,
    required this.status,
  });
}

final List<Book> dummyBooks = [
  Book(
    title: 'Hujan',
    publisher: 'Tere Liye',
    rating: 4.5,
    imageUrl: 'assets/Hujan.png',
    synopsis:
        'Cerita ini menyoroti bagaimana manusia menghadapi trauma, pilihan sulit untuk melupakan kenangan pahit...',
    status: 'Available',
  ),
  Book(
    title: 'BUMI',
    publisher: 'Tere Liye',
    rating: 3.8,
    imageUrl: 'assets/BUMI.png',
    synopsis:
        'Novel seri petualangan dunia paralel tentang tiga remaja dengan kemampuan khusus...',
    status: 'Unavailable',
  ),
  Book(
    title: 'Lemon Tress',
    publisher: 'Zoulfa Katouh',
    rating: 5.0,
    imageUrl: 'assets/LemonTress.png',
    synopsis:
        'Kisah tentang perjuangan seorang mahasiswi di tengah perang saudara Suriah...',
    status: 'Available',
  ),
];

class Linimasa extends StatefulWidget {
  const Linimasa({super.key});

  @override
  State<Linimasa> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<Linimasa> {
  final List<Book> _books = List.from(dummyBooks);

  
  late TextEditingController _titleController;
  late TextEditingController _publisherController;
  late TextEditingController _synopsisController;
  late TextEditingController _imageUrlController;
  double _rating = 3.0;
  String _status = 'Available';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _publisherController = TextEditingController();
    _synopsisController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _publisherController.dispose();
    _synopsisController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.grey, size: 16));
      }
    }
    return Row(children: stars);
  }


  void _showBookModal({Book? book}) {
    final isEditing = book != null;

    if (isEditing) {
      _titleController.text = book.title;
      _publisherController.text = book.publisher;
      _synopsisController.text = book.synopsis;
      _imageUrlController.text = book.imageUrl;
      _rating = book.rating;
      _status = book.status;
    } else {
      _titleController.clear();
      _publisherController.clear();
      _synopsisController.clear();
      _imageUrlController.clear();
      _rating = 3.0;
      _status = 'Available';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Change Book' : 'Add Book',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

      
                    TextField(
                      controller: _publisherController,
                      decoration: const InputDecoration(
                        labelText: 'Publisher',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    
                    TextField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL Gambar (mis: assets/Hujan.png)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                  
                    TextField(
                      controller: _synopsisController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Synopsis',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                  
                    Row(
                      children: [
                        const Text('Rating: '),
                        Expanded(
                          child: Slider(
                            value: _rating,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            label: _rating.toStringAsFixed(1),
                            onChanged: (value) {
                              setModalState(() => _rating = value);
                            },
                          ),
                        ),
                        Text(_rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    
                    DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      items: ['Available', 'Unavailable'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setModalState(() => _status = newValue!);
                      },
                    ),
                    const SizedBox(height: 20),

                    
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isEmpty || _publisherController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Title dan Publisher wajib diisi')),
                          );
                          return;
                        }

                        setState(() {
                          if (isEditing) {
                            final index = _books.indexWhere((b) => b.title == book.title);
                            _books[index] = Book(
                              title: _titleController.text,
                              publisher: _publisherController.text,
                              rating: _rating,
                              imageUrl: _imageUrlController.text,
                              synopsis: _synopsisController.text,
                              status: _status,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book updated successfully')),
                            );
                          } else {
                            _books.add(
                              Book(
                                title: _titleController.text,
                                publisher: _publisherController.text,
                                rating: _rating,
                                imageUrl: _imageUrlController.text,
                                synopsis: _synopsisController.text,
                                status: _status,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book added successfully')),
                            );
                          }
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: Text(isEditing ? 'Save Changes' : 'Add Book'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void _showDeleteDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBook(book);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  
  void _deleteBook(Book book) {
    setState(() {
      _books.removeWhere((b) => b.title == book.title);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Book "${book.title}" deleted successfully')),
    );
  }


  Widget _buildBookCard(BuildContext context, Book book) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    book.imageUrl,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(book.publisher,
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      _buildRatingStars(book.rating),
                      const SizedBox(height: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: book.status == 'Available'
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          book.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: book.status == 'Available'
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => _showBookModal(book: book),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange)),
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showDeleteDialog(book),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linimasa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showBookModal(),
            tooltip: 'Add Book',
          ),
        ],
      ),
      body: _books.isEmpty
          ? const Center(child: Text('No books available. Add some!'))
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) =>
                  _buildBookCard(context, _books[index]),
            ),
    );
  }
}
