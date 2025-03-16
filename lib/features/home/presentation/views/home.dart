import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/widgets/publish_property.dart';
import 'package:nopin_creative/features/chat/presentation/views/chat.dart';
import 'package:nopin_creative/features/favorites/presentation/views/favorite.dart';
import 'package:nopin_creative/features/home/presentation/views/offers.dart';
import 'package:nopin_creative/features/profile/presentation/views/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    controller.addListener(() {
      setState(() {
        currentIndex = controller.page!.round();
      });
    });
  }

  List<Widget> homeScreens = const [
    OffersView(),
    ChatView(),
    FavoriteView(),
    ProfileView()
  ];

  void _onFabPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => const PublishProperty(),
    );
  }

  void _showFavoritesBottomSheet() {
    setState(() {
      currentIndex = 2; // Set Favorites as active
    });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: const FavoriteView(),
      ),
    ).then((_) {
      if (controller.page != null) {
        setState(() {
          currentIndex = controller.page!.round();
        });
      }
    });
  }

  void _navigateToPage(int navIndex) {
    if (navIndex == 2) {
      _showFavoritesBottomSheet();
    } else {
      int pageIndex;
      if (navIndex == 0) {
        pageIndex = 0; // Offers
      } else if (navIndex == 1) {
        pageIndex = 1; // Chat
      } else if (navIndex == 3) {
        pageIndex = 3; // Profile
      } else {
        return;
      }

      controller.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: homeScreens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: kBottomNavigationBarHeight + 20,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(CupertinoIcons.house_alt, "Ofertas", 0),
              _buildNavItem(CupertinoIcons.chat_bubble, "Mensagem", 1),
              const SizedBox(width: 40),
              _buildNavItem(CupertinoIcons.heart, "Favoritos", 2),
              _buildNavItem(CupertinoIcons.person, "Meu Perfil", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => _navigateToPage(index),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: currentIndex == index ? AppColors.primary : Colors.black87,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: currentIndex == index ? AppColors.primary : Colors.black87,
                fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}