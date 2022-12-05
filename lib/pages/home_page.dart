import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/utils/my_logger.dart';
import 'package:news_app/widgets/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final today = DateFormat('EEEE, MMMM d').format(DateTime.now());
  // API URL = "https://inshorts.deta.dev/news?category={}"
  final tabs = [
    "All",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
    "Politics",
    "Startup",
    "World",
    "Hatke",
    "Automobile",
  ];
  bool isLoading = true;

  Future<Response> fetcher(String category) async {
    try {
      return Dio().get('https://inshorts.deta.dev/news?category=$category');
    } on DioError catch (error) {
      MyLogger.print(error.message);
      return Response(
        statusCode: 400,
        statusMessage: error.message,
        requestOptions: error.requestOptions,
      );
    }
  }

  List<List<NewsModel>> categoryNews = [];
  Future<void> fetchAllCategories() async {
    final List<List<NewsModel>> allNews = [];
    final response = await Future.wait(List.generate(
      tabs.length,
      (index) {
        return fetcher(tabs[index].toLowerCase());
      },
    ));
    for (var element in response) {
      final Map<String, dynamic> singleCategory = element.data;
      final List singleCategoryNewsData = singleCategory['data'];
      final List<NewsModel> categoryNews =
          singleCategoryNewsData.map((e) => NewsModel.fromMap(e)).toList();
      allNews.add(categoryNews);
    }
    setState(() {
      categoryNews = allNews;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    // get today's date formatted like this Friday, June 16th

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                today,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const Text("Daily Feed")
            ],
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.label,
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            tabs: tabs
                .map((e) => Tab(
                      child: Chip(
                        label: Text(e),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: List.generate(tabs.length, (tabsIndex) {
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.4),
                    onRefresh: () {
                      return fetchAllCategories();
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: categoryNews[tabsIndex].length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Theme.of(context).highlightColor,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final news = categoryNews[tabsIndex][index];
                        return News(
                          news: news,
                        );
                      },
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
