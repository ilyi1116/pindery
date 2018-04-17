import 'package:flutter/material.dart';
import '../catalogue_element.dart';
import '../theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String partyStuffCollection = "party_stuff";

class CatalogueChoosingList extends StatelessWidget {
  CatalogueChoosingList(
      {this.catalogue});

  final GlobalKey scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<CatalogueElement> catalogue;

  final Category drinksCategory = new Category(
    title: 'Drinks',
    dbName: 'drinks',
    dbSubcategories: ['alcohol', 'soft_drinks'],
    icon: Icons.local_bar,
  );

  final Category foodCategory = new Category(
    title: 'Food',
    dbName: 'food',
    dbSubcategories: ['simple_food'],
    icon: Icons.local_pizza,
  );

  final Category utilitiesCategory = new Category(
    title: 'Utilities',
    dbName: 'utilities',
    dbSubcategories: ['to_eat'],
    icon: Icons.settings,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Choose something'),
      ),
      body: new Theme(
        data: pinderyTheme,
        child: new ListView(
          children: <Widget>[
            new CategoryTilesBlock(
              category: drinksCategory,
              catalogue: catalogue,
            ),
            new CategoryTilesBlock(
              category: foodCategory,
              catalogue: catalogue,
            ),
            new CategoryTilesBlock(
              category: utilitiesCategory,
              catalogue: catalogue,
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogueTileTitle extends StatelessWidget {
  CatalogueTileTitle({this.title, this.iconData});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(iconData),
          const SizedBox(width: 12.0),
          new Text(title),
        ],
      ),
    );
  }
}

class CategoryTilesList extends StatelessWidget {
  CategoryTilesList({this.category, this.categoryTypes, this.catalogue});

  final String category;
  final List<String> categoryTypes;
  final List<CatalogueElement> catalogue;

  @override
  Widget build(BuildContext context) {
    print("Entered the main list builder");
    return new ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        return new CategoryTilesSublist(
          category: category,
          subcategory: categoryTypes[index],
          catalogue: catalogue,
        );
      },
      itemCount: categoryTypes.length,
    );
  }
}

class CategoryTilesSublist extends StatelessWidget {
  CategoryTilesSublist({this.category, this.subcategory, this.catalogue});

  final String category;
  final String subcategory;
  final List<CatalogueElement> catalogue;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _getReference().snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return new Container();
        }
        return new ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            List<DocumentSnapshot> documentsList = snapshot.data.documents;
            final DocumentSnapshot document = documentsList[index];
            CatalogueElement element =
                new CatalogueElement.fromFirestore(document);
            if (isNotPresentInCatalogue(element))
            return new CatalogueTile(
              element: element,
              catalogue: catalogue,
            );
          },
          itemCount: snapshot.data.documents.length,
        );
      },
    );
  }

  bool isNotPresentInCatalogue(CatalogueElement element) {
    bool isNotPresent = true;
    for (CatalogueElement item in catalogue) {
      if (element.elementName == item.elementName) {
        isNotPresent = false;
      }
    }
    return isNotPresent;
  }

  CollectionReference _getReference() => Firestore.instance
      .collection(partyStuffCollection)
      .document(category)
      .collection(subcategory);
}

class CatalogueTile extends StatelessWidget {
  CatalogueTile({this.element, this.catalogue});

  final CatalogueElement element;
  final List<CatalogueElement> catalogue;

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 32.0),
            new Expanded(child: new Text(element.elementName)),
            new Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: new Text(element.elementValue.toString()),
            )
          ],
        ),
      ),
      onTap: () {
        if (!catalogue.contains(element)) {
          catalogue.add(element);
        }
        for (CatalogueElement item in catalogue) {
          print(item.elementName);
        }
        Navigator.of(context).pop();
      },
    );
  }
}

class CategoryTilesBlock extends StatelessWidget {
  CategoryTilesBlock({this.category, this.catalogue});

  final Category category;
  final List<CatalogueElement> catalogue;

  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new CatalogueTileTitle(
          title: category.title, iconData: category.icon),
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Container(
              height: 32.0,
              child: new ListTile(
                title: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 32.0),
                      new Expanded(
                        child: new Text(
                          'Name',
                          style: new TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 13.0),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: new Text(
                          'Value',
                          style: new TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 13.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            new CategoryTilesList(
              categoryTypes: category.dbSubcategories,
              category: category.dbName,
              catalogue: catalogue,
            ),
          ],
        )
      ],
    );
  }
}

class Category {
  Category({this.title, this.icon, this.dbName, this.dbSubcategories});

  final String title;
  final IconData icon;
  final String dbName;
  final List<String> dbSubcategories;
}