import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/screens/widget/tab_bar_item/artist_tab.dart';
import 'package:spotify_app_prueba/screens/widget/tab_bar_item/playlist_tab.dart';

class MyLibraryPage extends StatefulWidget {
  MyLibraryPageState createState() => MyLibraryPageState();
}

class MyLibraryPageState extends State<MyLibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, initialIndex: 0, length: 2)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Container tabBar = Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: Color(0xff1ed760),
        controller: tabController,
        indicatorColor: Colors.black,
        tabs: [
          Tab(
            text: 'Playlists',
            //child: Container(color: Colors.red),
          ),
          Tab(
            text: 'Artists',
          ),
        ],
      ),
    );

    Container tabBarView = Container(
      child: TabBarView(
        controller: tabController,
        children: [
          PlaylistTab(),
          ArtistTab(),
          //AlbumTab(),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        tabBar,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: tabBarView,
          ),
        )
      ],
    );
  }
}
