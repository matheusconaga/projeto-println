import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String username;
  final String content;
  final String? imageUrl;

  const PostItem({
    super.key,
    required this.username,
    required this.content,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Image.network(imageUrl!),
              ),
          ],
        ),
      ),
    );
  }
}