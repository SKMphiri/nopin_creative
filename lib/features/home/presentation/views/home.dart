import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/features/home/presentation/views/offers.dart';
import 'package:nopin_creative/features/profile/presentation/views/profile.dart';
import 'package:nopin_creative/features/favorites/presentation/views/favorite.dart';
import 'package:nopin_creative/features/chat/presentation/views/chat.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentIndex = 0;

  // Define the main views
  final List<Widget> pages = [
    const OffersView(),
    const FavoriteView(),
    const ChatView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: pages.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentIndex = tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primary;
    final isTablet = ResponsiveLayout.isTablet(context);
    final bottomNavHeight = isTablet ? 64.0 : 56.0;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: pages,
      ),
      floatingActionButton: _buildFloatingActionButton(accentColor, isTablet),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: bottomNavHeight + 0,
        elevation: 16,
        shadowColor: Colors.black.withOpacity(0.05),
        padding: EdgeInsets.zero,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
                0, CupertinoIcons.house_fill, 'Início', accentColor, isTablet),
            _buildNavItem(
                1, CupertinoIcons.heart_fill, 'Salvos', accentColor, isTablet),
            const SizedBox(width: 10), // Space for FAB
            _buildNavItem(2, CupertinoIcons.chat_bubble_fill, 'Mensagens',
                accentColor, isTablet),
            _buildNavItem(
                3, CupertinoIcons.person_fill, 'Perfil', accentColor, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    Color accentColor,
    bool isTablet,
  ) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = index;
            tabController.animateTo(index);
          });
        },
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        splashColor: accentColor.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 0 : 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? accentColor : Colors.grey.shade500,
                size: isTablet ? 24 : 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? accentColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(Color accentColor, bool isTablet) {
    final size = isTablet ? 56.0 : 52.0;

    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: () => _showActionSheet(context),
        elevation: 4,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor,
                accentColor.withBlue(accentColor.blue + 20),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    final accentColor = AppColors.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "O que gostaria de fazer?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButton(
                  context,
                  CupertinoIcons.house_alt,
                  "Adicionar Propriedade",
                  "Publique um novo imóvel",
                  accentColor,
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  CupertinoIcons.camera,
                  "Capturar Fotos",
                  "Tire fotos para sua propriedade",
                  Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  CupertinoIcons.doc_text,
                  "Documentos",
                  "Adicionar documentos para propriedade",
                  Colors.amber.shade700,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Add action handler here
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.grey.shade400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
