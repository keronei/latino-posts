import 'package:flutter/foundation.dart';
import 'package:latin_news/models/details_content.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:provider/provider.dart';
import '../utils/shared_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    super.initState();
    _loadFromApi(_currentPage, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latino News'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final shouldProceed = await showConfirmationDialog(context);
                if (shouldProceed == true) {
                  await _deleteData();
                  if (context.mounted) {
                    showSnackBar(context, "Deleting all local posts");
                  }
                }
              },
            ),
          ),
        ],
      ),
      body:
          _isFirstLoadRunning
              ? Center(child: CircularProgressIndicator())
              : _buildNewsListView(),
    );
  }

  _loadFromApi(int page, bool isRefresh) async {
    var apiProvider = Provider.of<NewsPostApiProvider>(context, listen: false);

    setState(() {
      if (page == 1) {
        _isFirstLoadRunning = true;
      } else {
        _isLoadMoreRunning = true;
      }
    });

    var postsData = await apiProvider.getNextPage(page, isRefresh);

    if (postsData.newsPostsCount == 0) {
      if (postsData.responseMessage == null) {
        // We've reached end of list
        _hasNextPage = false;
      }
      var responseMessage = postsData.responseMessage;
      if (responseMessage != null) {
        if (mounted) {
          showSnackBar(context, responseMessage);
        }
      }
    } else {
      _currentPage += 1;
      _hasNextPage = true;
    }

    setState(() {
      if (page == 1) {
        _isFirstLoadRunning = false;
      } else {
        _isLoadMoreRunning = false;
      }
    });
  }

  _deleteData() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    await DBProvider.db.deleteAllPosts();
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  _buildNewsListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllNewsPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || _isFirstLoadRunning) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh:
                () async => {
                  _currentPage = 1,
                  _loadFromApi(_currentPage, true),
                },
            child: ListView.builder(
              itemCount: snapshot.data.length + 1,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data.length && index == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Text(
                              "Looks like there's no posts, pull to refresh.",
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (index == snapshot.data.length && _hasNextPage) {
                  final _allData = snapshot.data.length;
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width - 50,
                      child:
                          _isLoadMoreRunning
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircularProgressIndicator(),
                                  Text("Getting more posts..."),
                                ],
                              )
                              : Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder
                                    >(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _loadFromApi(
                                      _currentPage > (_allData / apiPageSize)
                                          ? _currentPage
                                          : (_allData / apiPageSize).toInt() +
                                              1,
                                      false,
                                    );
                                  },
                                  child: Text(
                                    "Load More",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                    ),
                  );
                } else if (index == snapshot.data.length && !_hasNextPage) {
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "You've reached the end, no more posts.",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                final pointedPost = snapshot.data[index] as NewsPost;

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    pointedPost.title.capitalizeSentences(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  label: Text(
                                    "# ${pointedPost.id}",
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(pointedPost.body.capitalizeFirstLetter()),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print("${snapshot.data[index].title}");
                        }
                        Navigator.pushNamed(
                          context,
                          detailsDestination,
                          arguments: DetailsContent(
                            snapshot.data,
                            pointedPost.id,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
