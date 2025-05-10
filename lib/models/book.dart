class Book {
  final String? title;
  final List<String>? tags;
  final String? coverImage;
  final String? category;
  final String? author;
  final String? publishedYear;
  final String? description;
  final String? characterName; // 주요 캐릭터 이름 추가
  final String? characterDescription; // 주요 캐릭터 설명 추가
  final String? characterImage; // 캐릭터 이미지 추가
  final int? characterId; // 캐릭터 ID
  final int? bookId;

  Book({
    this.title,
    this.tags = const ["태그 없음"], // 기본값 추가
    this.coverImage = "assets/books/broken_image.png", // 기본 이미지 추가
    this.category,
    this.author = "미상",
    this.publishedYear = "미상",
    this.description = "작품 소개글이 없습니다.",
    this.characterName = '',
    this.characterDescription = '',
    this.characterImage = 'assets/books/default_character.png', // 기본 캐릭터 이미지
    this.characterId,
    this.bookId,
  });

  // JSON을 Book 객체로 변환하는 factory 생성자
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? "제목 없음",
      tags: json['tags'] != null ? List<String>.from(json['tags']) : ["태그 없음"],
      coverImage: json['coverImage'] ?? "assets/books/broken_image.png",
      category: json['category'] ?? "미상",
      author: json['author'] ?? "미상",
      publishedYear: json['publishedYear'] ?? "미상",
      description: json['description'] ?? "작품 소개글이 없습니다.",
      bookId: json['bookId'],
    );
  }

  // Book 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'tags': tags,
      'coverImage': coverImage,
      'category': category,
      'author': author,
      'publishedYear': publishedYear,
      'description': description,
      'bookId': bookId,
    };
  }
}
