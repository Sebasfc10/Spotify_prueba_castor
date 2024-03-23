import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/models/profile_model.dart';
import 'package:spotify_app_prueba/screens/tab_bottom_pages/dashboard_page.dart';
import 'package:spotify_app_prueba/screens/tab_bottom_pages/my_library_page.dart';
import 'package:spotify_app_prueba/screens/tab_bottom_pages/search_page.dart';
import 'package:spotify_app_prueba/services/profile_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;
  final ProfileService _profileService = ProfileService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: FutureBuilder<SpotifyUser>(
        future: _profileService.getDataprofile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final SpotifyUser user = snapshot.data!;
            return Text(
              'Bienvenido ${user.displayName}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            );
          }
        },
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0.0,
      leading: FutureBuilder<SpotifyUser>(
        future: _profileService.getDataprofile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final SpotifyUser user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                  user.images.isNotEmpty ? user.images[0].url! : '',
                ),
              ),
            );
          }
        },
      ),
    );

    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      selectedItemColor: Color(0xff1ed760),
      unselectedItemColor: Colors.white,
      //unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            label: 'Inicio',
            icon: Icon(
              Icons.home,
            )),
        BottomNavigationBarItem(
            label: 'Buscar',
            icon: Icon(
              Icons.search,
            )),
        BottomNavigationBarItem(
            label: 'Mi biblioteca',
            icon: Icon(
              Icons.my_library_music_outlined,
            )),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );

    List<Widget> listPages = [
      StartPage(),
      SearchPage(),
      MyLibraryPage(),
    ];

    Scaffold scaffold = new Scaffold(
      appBar: appBar,
      body: listPages.elementAt(selectedIndex),
      bottomNavigationBar: bottomNavigationBar,
    );

    return scaffold;
  }
}
