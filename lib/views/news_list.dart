import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/providers/api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = true;
  bool _isLoadMoreRunning = true;
  bool _isLoadMoreButtonVisible = false;

  List<NewsPost> _availablePosts = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _loadFromApi(_currentPage);
    _scrollController = ScrollController()..addListener(_showMoreButton);
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
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi(1);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildNewsListView(),
    );
  }

  _loadFromApi(int page) async {
    setState(() {
      if (page == 1) {
        _isFirstLoadRunning = true;
      } else {
        _isLoadMoreRunning = true;
      }
    });

    var apiProvider = NewsPostApiProvider();

    var posts = await apiProvider.getNextPage(page);

    if (posts.isEmpty) {
      // We've reached end of list
      setState(() {
        _hasNextPage = false;
      });
    } else {
      setState(() {
        _availablePosts.addAll(posts);
        _currentPage += 1;
      });
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
      isLoading = true;
    });

    await DBProvider.db.deleteAllNews();

    setState(() {
      isLoading = false;
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
            onRefresh: () async => {_loadFromApi(1)},
            child: ListView.separated(
              separatorBuilder:
                  (context, index) => Divider(color: Colors.black12),
              itemCount: snapshot.data.length + 1,
              controller: _scrollController,
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
                              "Looks like there's no data, pull to refresh.",
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (index == snapshot.data.length) {
                  return Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width - 50,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                          ),
                          onPressed: () {
                            _loadFromApi(_currentPage);
                          },
                          child: Text(
                            "Load More",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  title: Text(snapshot.data[index].title),
                  subtitle: Text(snapshot.data[index].body),
                );
              },
            ),
          );
        }
      },
    );
  }

  void _showMoreButton() {
    setState(() {
      _isLoadMoreButtonVisible = true;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_showMoreButton);
    super.dispose();
  }
}
