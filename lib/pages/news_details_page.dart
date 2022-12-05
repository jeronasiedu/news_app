// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/widgets/custom_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({
    Key? key,
    required this.news,
  }) : super(key: key);
  final NewsModel news;
  @override
  Widget build(BuildContext context) {
    void readMore() async {
      final Uri uri = Uri.parse(news.url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error opening url")),
        );
      }
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.35,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.blurBackground,
              ],
              background: CustomImage(
                imageUrl: news.imageUrl,
              ),
              title: Text(
                news.title,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "By ${news.author}",
                        ),
                        Text(news.date)
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        readMore();
                      },
                      child: const Text("Read More"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
