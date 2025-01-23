import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/features/chat/presentation/pages/chat.dart';
import 'package:nopin_creative/features/favorites/presentation/views/favorite.dart';
import 'package:nopin_creative/features/home/presentation/views/offers.dart';
import 'package:nopin_creative/features/profile/presentation/pages/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController(initialPage: 0);

  List<Widget> homeScreens = const [OffersView(), ChatView(), FavoriteView(), ProfileView()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: homeScreens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9), topRight: Radius.circular(9)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Colors.black12)
            ]),
        height: kBottomNavigationBarHeight + 27,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedLabelStyle: TextStyle(fontSize: 10),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black87,
          showUnselectedLabels: true,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index){
            print("$index");
            controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
          },
          items: [
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.search),
            //   label: "Explorar",
            // ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble), label: "Mensagem"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_alt), label: "Ofertas"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart), label: "Favoritos"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person), label: "Meu Perfil"),
          ],
        ),
      ),
    );
  }
}
