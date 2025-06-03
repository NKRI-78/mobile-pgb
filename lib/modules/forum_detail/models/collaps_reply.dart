class Reply {
  final String id;
  final String content;

  Reply({required this.id, required this.content});
}

class Comment {
  final String id;
  final String content;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.content,
    required this.replies,
  });
}
