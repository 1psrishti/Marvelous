import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marvelous/constants.dart';
import 'package:http/http.dart' as http;
import 'package:marvelous/models/events_model.dart';
import '../widgets/event_card.dart';
import '../keys.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late String eventsUrl;
  List<EventsModel> eventsList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMarvelEvents(k50EventsUrl);
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
      onTap: (){FocusScope.of(context).unfocus();},
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: TextField(
                    keyboardType: TextInputType.visiblePassword,  // removes emojis
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
                        onPressed: (){
                          if(searchController.text.trim().isNotEmpty) {
                            eventsUrl = k50EventsUrl +
                                "&nameStartsWith=" +
                                searchController.text;
                            getMarvelEvents(eventsUrl);
                            if(mounted) {
                              setState(() {});
                            }
                          }
                        },
                      ),
                    )
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "eVEntS ",
                style: TextStyle(
                  fontFamily: "AvengeroDisassembled",
                  letterSpacing: 4.5,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: eventsList.isNotEmpty
                    ? RawScrollbar(
                  controller: scrollController,
                  thumbColor: kMarvelRed,
                  radius: const Radius.circular(5),
                  child: GridView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: eventsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: MediaQuery.of(context).size.width,
                      crossAxisCount: 1,
                      mainAxisSpacing: 40,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return EventCard(
                        title: eventsList[index].title!,
                        description: eventsList[index].description!,
                        thumbnailUrl: eventsList[index].thumbnail!.path! +
                            "/portrait_uncanny." +
                            eventsList[index].thumbnail!.extension!,
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


  void getMarvelEvents(String url) {
    debugPrint("------------------------RUNNING---------------------------");
    eventsList.clear();
    final uri = Uri.parse(url);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedJson = jsonDecode(responseBody);
        final marvelData = decodedJson['data'];
        final List resultsList = marvelData['results'];
        for (var i = 0; i < resultsList.length; i++) {
          if (resultsList[i]['thumbnail']['path'] == kImageUnavailable &&
              resultsList[i]['description'] == "") {
          } else {
            final newEvent =
            EventsModel.fromJson(resultsList[i] as Map<String, dynamic>);
            eventsList.add(newEvent);
          }
        }
        setState(() {});
      }
    }).catchError((e) {
      debugPrint("---------------------------$e-----------------------------");
    });
  }

}