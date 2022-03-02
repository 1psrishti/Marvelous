//TODO check imports
import 'package:flutter/material.dart';
import 'package:marvelous/screens/characters_screen.dart';
import 'package:marvelous/screens/comics_screen.dart';
import 'package:marvelous/screens/series_screen.dart';
import 'package:marvelous/screens/events_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';
import 'keys.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = NavigationItem.characters;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == NavigationItem.characters) {
      container = const CharactersScreen();
    } else if (currentPage == NavigationItem.comics) {
      container = const ComicsScreen();
    } else if (currentPage == NavigationItem.series) {
      container = const SeriesScreen();
    } else if (currentPage == NavigationItem.stories) {
      container = const EventsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'images/logo.png',
            height: 60,
          ),
        ),
        backgroundColor: kMarvelRed,
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: (){showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Visit MARVEL's official website?",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: kLavender,
                          fontSize: 18
                        ),
                      ),
                      onPressed: () async {
                        if (await canLaunch(kMarvelWebsite)) {
                          await launch(kMarvelWebsite);
                        } else {
                          throw 'Could not launch $kMarvelWebsite';
                        }
                      },
                    ),
                    // TextButton(
                    //   child: const Text("No"),
                    //   onPressed: (){ },
                    // ),
                  ],
                );
              }
            );}
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            const SizedBox(
              height: 200,
              child: DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                    color: kRedDark,
                    image: DecorationImage(
                        //TODO fix image
                        image: AssetImage("images/image.jpg"),
                        fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 100),
            createListItem(
              id: 1,
              title: "CHARACTERS",
              icon: LineIcons.mask,
              isSelected:
                  currentPage == NavigationItem.characters ? true : false,
            ),
            createListItem(
              id: 2,
              title: "COMICS",
              icon: LineIcons.bookOpen,
              isSelected: currentPage == NavigationItem.comics ? true : false,
            ),
            createListItem(
              id: 3,
              title: "SERIES",
              icon: LineIcons.television,
              isSelected: currentPage == NavigationItem.series ? true : false,
            ),
            createListItem(
              id: 4,
              title: "EVENTS",
              icon: LineIcons.bookOfTheDead,
              isSelected: currentPage == NavigationItem.stories ? true : false,
            ),
          ],
        ),
      ),
      body: container,
    );
  }

  Widget createListItem({
    required int id,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return ListTile(
      selected: isSelected,
      selectedColor: kBackground,
      selectedTileColor: kRedSelected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 26),
      leading: Icon(icon, size: 30.0),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontFamily: "Marvel",
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if (id == 1) {
            currentPage = NavigationItem.characters;
          } else if (id == 2) {
            currentPage = NavigationItem.comics;
          } else if (id == 3) {
            currentPage = NavigationItem.series;
          } else if (id == 4) {
            currentPage = NavigationItem.stories;
          }
        });
      },
    );
  }
}

enum NavigationItem {
  characters,
  comics,
  series,
  stories,
}





