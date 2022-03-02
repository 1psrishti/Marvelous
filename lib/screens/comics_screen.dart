import 'dart:convert';
import '../keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marvelous/models/comics_model.dart';
import '../constants.dart';
import '../widgets/comic_card.dart';

class ComicsScreen extends StatefulWidget {
  const ComicsScreen({Key? key}) : super(key: key);

  @override
  _ComicsScreenState createState() => _ComicsScreenState();
}

class _ComicsScreenState extends State<ComicsScreen> {
  late String comicsUrl;
  List<ComicsModel> comicsList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMarvelComics(k50ComicsUrl);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: TextField(
                    keyboardType:
                        TextInputType.visiblePassword, // removes emojis
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: kLavender,
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search_rounded),
                        color: kLavender,
                        onPressed: () {
                          if (searchController.text.trim().isNotEmpty) {
                            comicsUrl = k50ComicsUrl +
                                "&titleStartsWith=" +
                                searchController.text;
                            getMarvelComics(comicsUrl);
                            setState(() {});
                          }
                        },
                      ),
                    )),
              ),
              const SizedBox(height: 30),
              const Text(
                "coMicS ",
                style: TextStyle(
                  fontFamily: "AvengeroDisassembled",
                  letterSpacing: 4.5,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: comicsList.isNotEmpty
                    ? RawScrollbar(
                        controller: scrollController,
                        thumbColor: kMarvelRed,
                        radius: const Radius.circular(5),
                        child: GridView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: comicsList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: MediaQuery.of(context).size.width,
                            crossAxisCount: 1,
                            mainAxisSpacing: 40,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ComicCard(
                              name: comicsList[index].title!,
                              pageCount: comicsList[index].pageCount!,
                              thumbnailUrl: comicsList[index].thumbnail!.path! +
                                  "/portrait_uncanny." +
                                  comicsList[index].thumbnail!.extension!,
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                        color: kMarvelRed,
                      )),
              ),
              const SizedBox(height: 30),
            ],
          )),
    );
  }

  void getMarvelComics(String url) {
    debugPrint("------------------------RUNNING---------------------------");
    comicsList.clear();
    final uri = Uri.parse(url);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedJson = jsonDecode(responseBody);
        final marvelData = decodedJson['data'];
        final List resultsList = marvelData['results'];
        for (var i = 0; i < resultsList.length; i++) {
          if (resultsList[i]['thumbnail']['path'] == kImageUnavailable &&
              resultsList[i]['pageCount'] == 0) {
          } else {
            final newComic =
                ComicsModel.fromJson(resultsList[i] as Map<String, dynamic>);
            comicsList.add(newComic);
          }
        }
        setState(() {});
      }
    }).catchError((e) {
      debugPrint("---------------------------$e-----------------------------");
    });
  }
}
