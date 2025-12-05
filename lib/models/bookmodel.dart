class BookModel {
  final int id;
  final String title;
  final String overview;
  final String publisher;
  final String status;
  final double voteAverage;
  final String posterPath;

  BookModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.publisher,
    required this.status,
    required this.voteAverage,
    required this.posterPath,
  });

  factory BookModel.fromMap(Map<String, dynamic> m) => BookModel(
        id: m['id'] as int,
        title: m['title'] as String,
        overview: m['overview'] as String,
        publisher: m['publisher'] as String,
        status: m['status'] as String,
        voteAverage: (m['voteAverage'] as num).toDouble(),
        posterPath: m['posterPath'] as String,
      );
}