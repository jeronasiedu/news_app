import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  // open bottom sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.48,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/profile.jpg'),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Tetteh Jeron Asiedu",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // some short note about me, social icons and a button to open my website
                              const Text(
                                "Hi there, thanks for downloading my app, I'm a software developer and this is my first flutter app. I hope you like it. If you do, please consider giving it a 5 star rating on the play store. Thanks!",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Ionicons.logo_github),
                                    splashRadius: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Ionicons.logo_linkedin),
                                    color: Colors.blue[800],
                                    splashRadius: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Ionicons.logo_twitter),
                                    color: Colors.blue,
                                    splashRadius: 22,
                                  ),
                                ],
                              ),
                              // privacy policy
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Ionicons.document_text),
                                label: const Text("Privacy Policy"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                splashRadius: 22,
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
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
