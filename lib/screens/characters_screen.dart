import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marvelous/constants.dart';
import 'package:http/http.dart' as http;
import 'package:marvelous/models/characters_model.dart';
import '../keys.dart';
import '../widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}


class _CharactersScreenState extends State<CharactersScreen> {
  late String charactersUrl;
  List<CharacterModel> charactersList = [];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMarvelCharacters(k50CharactersUrl);
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
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: kLavender,
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search_rounded),
                        color: kLavender,
                        onPressed: (){
                          if(searchController.text.trim().isNotEmpty) {
                            charactersUrl = k50CharactersUrl +
                                "&nameStartsWith=" +
                                searchController.text;
                            getMarvelCharacters(charactersUrl);
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
                "chAracterS ",
                style: TextStyle(
                  fontFamily: "AvengeroDisassembled",
                  letterSpacing: 4.5,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: charactersList.isNotEmpty
                    ? RawScrollbar(
                      controller: scrollController,
                      thumbColor: kMarvelRed,
                      radius: const Radius.circular(5),
                      child: GridView.builder(
                        controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: charactersList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: MediaQuery.of(context).size.width,
                            crossAxisCount: 1,
                            mainAxisSpacing: 40,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return CharacterCard(
                              name: charactersList[index].name.toString(),
                              description: charactersList[index].description!,
                              thumbnailUrl: charactersList[index].thumbnail!.path! +
                                  "/portrait_uncanny." +
                                  charactersList[index].thumbnail!.extension!,
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


  void getMarvelCharacters(String url) {
    debugPrint("------------------------RUNNING---------------------------");
    charactersList.clear();
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
            final newCharacter =
            CharacterModel.fromJson(resultsList[i] as Map<String, dynamic>);
            charactersList.add(newCharacter);
          }
        }
        setState(() {});
      }
    }).catchError((e) {
      debugPrint("---------------------------$e-----------------------------");
    });
  }

}
