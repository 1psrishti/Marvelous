import 'package:flutter/material.dart';
import 'package:marvelous/constants.dart';

class ComicCard extends StatelessWidget {
  final String name;
  final int pageCount;
  final String thumbnailUrl;

  ComicCard({
    required this.name,
    required this.pageCount,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: kRedDark,
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: "SyneTactile",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(25)),
                    gradient: LinearGradient(
                      colors: [
                        kRedSelected,
                        kRedSelected.withOpacity(0.8),
                        kRedSelected.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                ),
              ),
            ],
          ),
          Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              alignment: Alignment.bottomRight,
              child: Text(pageCount == 0
                  ? "Pages not available"
                  : pageCount.toString() + " pages",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(25)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topLeft,
                  )),
            ),
          ]),
        ],
      ),
    );
  }
}
