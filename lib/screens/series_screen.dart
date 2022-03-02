import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:marvelous/models/series_model.dart';
import 'package:marvelous/widgets/series_card.dart';
import '../keys.dart';
import '../constants.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({Key? key}) : super(key: key);

  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  late String seriesUrl;
  List<SeriesModel> seriesList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMarvelComics(k50SeriesUrl);
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
                            seriesUrl = k50SeriesUrl +
                                "&titleStartsWith=" +
                                searchController.text;
                            getMarvelComics(seriesUrl);
                            setState(() {});
                          }
                        },
                      ),
                    )),
              ),
              const SizedBox(height: 30),
              const Text(
                "seRieS ",
                style: TextStyle(
                  fontFamily: "AvengeroDisassembled",
                  letterSpacing: 4.5,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: seriesList.isNotEmpty
                    ? RawScrollbar(
                        controller: scrollController,
                        thumbColor: kMarvelRed,
                        radius: const Radius.circular(5),
                        child: GridView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: seriesList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: MediaQuery.of(context).size.width,
                            crossAxisCount: 1,
                            mainAxisSpacing: 40,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return SeriesCard(
                              name: seriesList[index].title!,
                              startYear: seriesList[index].startYear!,
                              thumbnailUrl: seriesList[index].thumbnail!.path! +
                                  "/portrait_uncanny." +
                                  seriesList[index].thumbnail!.extension!,
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
    seriesList.clear();
    final uri = Uri.parse(url);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedJson = jsonDecode(responseBody);
        final marvelData = decodedJson['data'];
        final List resultsList = marvelData['results'];
        for (var i = 0; i < resultsList.length; i++) {
          if (resultsList[i]['thumbnail']['path'] == kImageUnavailable &&
              resultsList[i]['startYear'] == 0) {
          } else {
            final newSeries =
                SeriesModel.fromJson(resultsList[i] as Map<String, dynamic>);
            seriesList.add(newSeries);
          }
        }
        setState(() {});
      }
    }).catchError((e) {
      debugPrint("---------------------------$e-----------------------------");
    });
  }
}
