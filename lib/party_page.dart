/// This page contains the code for the specific page of every party.
///

// External libraries imports
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

// Internal imports
import 'party.dart';
import 'drawer.dart';
import 'theme.dart';
import 'party_choosing/take_part_page.dart';
import 'privacy.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class PartyPage extends StatelessWidget {
  final Party party;

  final String routeName = '/party-page';
  final GlobalKey<ScaffoldState> homeScaffoldKey;

  final AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  final double _appBarHeight = 256.0;

  PartyPage({this.party, this.homeScaffoldKey});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
        drawer: new Drawer(
          child: new PinderyDrawer(),
        ),
        body: new CustomScrollView(slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: _appBarBehavior == AppBarBehavior.pinned,
            floating: _appBarBehavior == AppBarBehavior.floating ||
                _appBarBehavior == AppBarBehavior.snapping,
            snap: _appBarBehavior == AppBarBehavior.snapping,
            flexibleSpace: new FlexibleSpaceBar(
              title: new Text(party.name),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  //todo : fix progress indicator (cannot be seen)
                  new Center(child : new CircularProgressIndicator(),),
                  new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: party.imageUrl,
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, -0.4),
                        colors: const <Color>[
                          const Color(0x60000000),
                          const Color(0x00000000)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                new BlackPartyHeader(
                  organiser: party.organiserUID,
                  rating: party.rating,
                  ratingNumber: party.ratingNumber,
                  party: party,
                ),
                new WhitePartyBlock(
                  data: party.place,
                  icon: const IconData(0xe0c8, fontFamily: 'MaterialIcons'),
                ),
                new WhitePartyBlock(
                  data: party.fromDayTime.day.toString() +
                      '/' +
                      party.fromDayTime.month.toString() +
                      '/' +
                      party.fromDayTime.year.toString(),
                  icon: const IconData(0xe192, fontFamily: 'MaterialIcons'),
                ),
                new WhitePartyBlock(
                  data: 'Necessary points: ' + party.pinderPoints.toString(),
                  icon: const IconData(0xe5ca, fontFamily: 'MaterialIcons'),
                ),
                new WhitePartyBlock(
                  data: Privacy.options[party.privacy.type],
                  icon: Privacy.optionsIcons[party.privacy.type],
                ),
                new Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Padding(
                    padding: const EdgeInsets.only(
                        left: 26.0, top: 13.0, right: 26.0, bottom: 13.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Text(
                            'Description',
                            style: new TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: primary),
                          ),
                        ),
                        new Text(
                          party.description,
                          style: pinderyTextStyle,
                        )
                      ],
                    ),
                  ),
                ),

            ]
          ),
        )
        ]
        )
    );
  }
}

class BlackPartyHeader extends StatelessWidget {
  BlackPartyHeader({this.organiser, this.rating, this.ratingNumber, this.party});

  final Party party;
  final String organiser;
  final num rating;
  final int ratingNumber;
  final List<Icon> stars = new List(5);

  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: primary,
      ),
      height: 86.0,
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'by ' + organiser,
                  style: new TextStyle(
                    color: secondary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        rating.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: new RatingStars(
                          number: rating,
                        ),
                      ),
                      new Text(
                        ratingNumber.toString() + ' reviews',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            new Expanded(
              child: new Container(
                alignment: Alignment.centerRight,
                child: new FloatingActionButton(
                  onPressed: () {
                    /*Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text(
                            "Pressed mate",
                            textAlign: TextAlign.center,
                          ),
                        ));*/
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => new TakePartPage(party: party,)),
                    );
                  },
                  child: new Icon(Icons.local_bar),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int ratingmethod(int rating) {
    if (rating == 1) {}
    return 1;
  }
}

class WhitePartyBlock extends StatelessWidget {
  WhitePartyBlock({this.data, this.icon});

  final String data;
  final IconData icon;

  Widget build(BuildContext context) {
    return new Container(
      height: 55.0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: new BoxDecoration(
        border: new Border(bottom: new BorderSide(color: dividerColor)),
        color: Colors.white,
      ),
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  width: 72.0,
                  child: new Icon(
                    icon,
                    color: secondary,
                    size: 20.0,
                  )),
              new Expanded(
                  child: new Text(
                data,
                style: new TextStyle(
                  color: primary,
                  fontSize: 17.0,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  RatingStars({this.number});

  final num number;
  final List<bool> active = new List(5);

  void starsMethod(num number) {
    int i = 0;
    for (i; i < 5 && i < number; i++) {
      active[i] = true;
    }
    for (i + 1; i < 5; i++) {
      active[i] = false;
    }
  }

  Widget build(BuildContext context) {
    starsMethod(number);

    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        new Icon( active[0]? (number<=0.5? Icons.star_half: Icons.star): Icons.star_border,
            color: active[0] ? secondary : Colors.white, size: 14.0),
        new Icon( active[1]? (number<=1.5? Icons.star_half: Icons.star): Icons.star_border,
          color: active[1] ? secondary : Colors.white, size: 14.0, ),
        new Icon(active[2]? (number<=2.5? Icons.star_half: Icons.star): Icons.star_border,
            color: active[2] ? secondary : Colors.white, size: 14.0),
        new Icon(active[3]? (number<=3.5? Icons.star_half: Icons.star): Icons.star_border,
            color: active[3] ? secondary : Colors.white, size: 14.0),
        new Icon(active[4]? (number<=4.5? Icons.star_half: Icons.star): Icons.star_border,
            color: active[4] ? secondary : Colors.white, size: 14.0),
      ],
    );
  }
}
