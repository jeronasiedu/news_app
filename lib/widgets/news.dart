// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/pages/news_details_page.dart';
import 'package:news_app/widgets/custom_image.dart';

class News extends StatelessWidget {
  const News({
    Key? key,
    required this.news,
  }) : super(key: key);
  final NewsModel news;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return NewsDetailsPage(news: news);
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImage(
                imageUrl: news.imageUrl,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${news.author} . ${news.time}",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    maxLines: 4,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
