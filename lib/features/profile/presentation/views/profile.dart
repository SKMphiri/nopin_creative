import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/core/shared/widgets/publish_property.dart';
import 'package:nopin_creative/features/profile/presentation/views/verify_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final isMobile = ResponsiveLayout.isMobile(context);
    final accentColor = AppColors.primary;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // App Bar with profile verification banner
          SliverAppBar(
            expandedHeight:
                isTablet ? screenHeight * 0.27 : screenHeight * 0.25,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(context, accentColor, isTablet),
            ),
          ),

          // Stats section
          SliverToBoxAdapter(
            child: _buildStatsSection(context, accentColor, isTablet),
          ),

          // Credits card - conditionally show based on screen space
          SliverToBoxAdapter(
            child: _buildCreditsCard(context, accentColor, isTablet),
          ),

          // Action buttons section - conditionally show based on screen space
          if (!isMobile || screenHeight > 700)
            SliverToBoxAdapter(
              child: _buildActionSection(context, accentColor, isTablet),
            ),

          // Badges section - conditionally show based on screen space
          if (!isMobile || screenHeight > 750)
            SliverToBoxAdapter(
              child: _buildBadgesSection(context, accentColor, isTablet),
            ),

          // Tabs for properties and saved items
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: accentColor,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: accentColor,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "Minhas Propriedades"),
                  Tab(text: "Salvas"),
                ],
              ),
            ),
            pinned: true,
          ),
        ],
        // Use TabBarView outside of slivers for proper scrolling
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPropertiesList(context, accentColor, isTablet),
            _buildSavedPropertiesList(context, accentColor, isTablet),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPublishPropertySheet(context),
        backgroundColor: Colors.black,
        elevation: 2,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Publicar Propriedade',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showPublishPropertySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const PublishProperty(),
    );
  }

  // Profile header with avatar, name, and status
  Widget _buildProfileHeader(
      BuildContext context, Color accentColor, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accentColor.withOpacity(0.2),
                Colors.white,
              ],
            ),
          ),
        ),

        // Verification banner
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 10,
              left: 8,
              right: 8,
            ),
            color: Colors.amber.shade100.withOpacity(0.7),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerifyProfile()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Verifique sua conta para mais vantagens",
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Profile content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Avatar with edit button
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: isTablet ? screenWidth * 0.15 : screenWidth * 0.22,
                    width: isTablet ? screenWidth * 0.15 : screenWidth * 0.22,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "D",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            isTablet ? screenWidth * 0.09 : screenWidth * 0.13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: isTablet ? 15 : 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.camera_fill,
                        size: isTablet ? 20 : 16,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Name and join date
              Text(
                "Dhalitso",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: isTablet ? 14 : 12,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Entrou em 4 julho de 2020",
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12 : 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Stats section showing property counts and other metrics
  Widget _buildStatsSection(
      BuildContext context, Color accentColor, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: CupertinoIcons.home,
            count: "16",
            label: "Propriedades",
            color: accentColor,
            isTablet: isTablet,
          ),
          _buildStatItem(
            icon: CupertinoIcons.star_fill,
            count: "4.7",
            label: "Avaliação",
            color: Colors.amber.shade600,
            isTablet: isTablet,
          ),
          _buildStatItem(
            icon: CupertinoIcons.hand_thumbsup,
            count: "98%",
            label: "Resposta",
            color: Colors.green.shade600,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  // Individual stat item
  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 24 : 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 12 : 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Credits card showing nopin balance and actions
  Widget _buildCreditsCard(
      BuildContext context, Color accentColor, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.8),
            accentColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Créditos",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                CupertinoIcons.refresh_thick,
                color: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                AppIcons.coinOne,
                width: isTablet ? 48 : 38,
                height: isTablet ? 48 : 38,
              ),
              const SizedBox(width: 12),
              Text(
                "525",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 30 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "nopins",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPaymentButton(
                  image: AppIcons.mpesa,
                  label: "Mpesa",
                  isTablet: isTablet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentButton(
                  image: AppIcons.emola,
                  label: "Emola",
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Payment buttons
  Widget _buildPaymentButton({
    required String image,
    required String label,
    required bool isTablet,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle payment method
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: isTablet ? 32 : 28,
                height: isTablet ? 26 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                "Recarregar",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13 : 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action section with quick actions
  Widget _buildActionSection(
      BuildContext context, Color accentColor, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              "Acções Rápidas",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.favorite_border,
                  label: "Favoritos",
                  color: Colors.red.shade400,
                  isTablet: isTablet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.history,
                  label: "Histórico",
                  color: Colors.blue.shade400,
                  isTablet: isTablet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: CupertinoIcons.settings,
                  label: "Definições",
                  color: Colors.grey.shade700,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: isTablet ? 24 : 22,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Badges section
  Widget _buildBadgesSection(
      BuildContext context, Color accentColor, bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Text(
                  "Distintivos",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "12",
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        TextSpan(
                          text: "/42",
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "Ver todos",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14 : 12,
                    color: accentColor,
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: isTablet ? 16 : 14,
                  color: accentColor,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadge(
                  image: AppImages.registered,
                  bgImage: AppImages.hexagon,
                  label: "Registrei-me",
                  isTablet: isTablet,
                  accentColor: accentColor,
                ),
                _buildBadge(
                  image: AppImages.goal,
                  bgImage: AppImages.hexagon,
                  label: "Primeira Venda",
                  isTablet: isTablet,
                  accentColor: accentColor,
                ),
                _buildBadge(
                  image: AppImages.quality,
                  bgImage: AppImages.hexagon,
                  label: "Qualidade",
                  isTablet: isTablet,
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Individual badge item
  Widget _buildBadge({
    required String image,
    required String bgImage,
    required String label,
    required bool isTablet,
    required Color accentColor,
  }) {
    final double badgeSize = isTablet ? 70 : 56;
    final double iconSize = isTablet ? 40 : 30;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              bgImage,
              width: badgeSize,
            ),
            Image.asset(
              image,
              width: iconSize,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 12 : 10,
            fontWeight: FontWeight.w500,
            color: accentColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Properties list tab
  Widget _buildPropertiesList(
      BuildContext context, Color accentColor, bool isTablet) {
    return SafeArea(
      child: ListView.builder(
        key: const PageStorageKey('properties_list'),
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: 3, // Show a few sample items
        itemBuilder: (context, index) {
          return PropertyCard(
            title: "Casa com 3 quartos em Matola",
            price: "MZN 4,800,000",
            status: index % 2 == 0 ? "Activo" : "Pendente",
            views: "${200 + index * 50}",
            date: "12/06/2023",
            isActive: index % 2 == 0,
            isTablet: isTablet,
            accentColor: accentColor,
          );
        },
      ),
    );
  }

  // Saved properties list tab
  Widget _buildSavedPropertiesList(
      BuildContext context, Color accentColor, bool isTablet) {
    return SafeArea(
      child: ListView.builder(
        key: const PageStorageKey('saved_properties_list'),
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: 2, // Show a few sample items
        itemBuilder: (context, index) {
          return PropertyCard(
            title: "Apartamento T2 na Polana",
            price: "MZN 6,500,000",
            status: "Salvo",
            views: "-",
            date: "05/06/2023",
            isActive: true,
            isSaved: true,
            isTablet: isTablet,
            accentColor: accentColor,
          );
        },
      ),
    );
  }
}

// Extracted property card as a separate widget for cleaner implementation
class PropertyCard extends StatelessWidget {
  final String title;
  final String price;
  final String status;
  final String views;
  final String date;
  final bool isActive;
  final bool isTablet;
  final Color accentColor;
  final bool isSaved;

  const PropertyCard({
    Key? key,
    required this.title,
    required this.price,
    required this.status,
    required this.views,
    required this.date,
    required this.isActive,
    required this.isTablet,
    required this.accentColor,
    this.isSaved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = isTablet ? 160.0 : (screenHeight < 700 ? 110.0 : 140.0);

    // Calculate button sizes based on screen width
    final bool showThreeButtons = screenWidth > 360; // For wider screens
    final bool useCompactLayout = screenWidth < 320; // For very narrow screens

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image with status
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  AppImages.beachHouse,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.8)
                        : isSaved
                            ? accentColor.withOpacity(0.8)
                            : Colors.amber.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Property details
          Padding(
            padding: EdgeInsets.all(useCompactLayout ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                SizedBox(height: useCompactLayout ? 8 : 12),

                // Stats row - make more responsive
                useCompactLayout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPropertyStat(
                            icon: CupertinoIcons.eye,
                            value: views,
                            label: "visualizações",
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 8),
                          _buildPropertyStat(
                            icon: CupertinoIcons.calendar,
                            value: date,
                            label: "publicado",
                            isTablet: isTablet,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPropertyStat(
                            icon: CupertinoIcons.eye,
                            value: views,
                            label: "visualizações",
                            isTablet: isTablet,
                          ),
                          _buildPropertyStat(
                            icon: CupertinoIcons.calendar,
                            value: date,
                            label: "publicado",
                            isTablet: isTablet,
                          ),
                        ],
                      ),

                SizedBox(height: useCompactLayout ? 12 : 16),

                // Action buttons - adapt based on screen width
                if (showThreeButtons && !isSaved && screenHeight > 700)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPropertyActionButton(
                          icon: CupertinoIcons.pen,
                          label: "Editar",
                          color: Colors.blue.shade600,
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPropertyActionButton(
                          icon: CupertinoIcons.chart_bar,
                          label: "Estatísticas",
                          color: Colors.amber.shade700,
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPropertyActionButton(
                          icon: isActive
                              ? Icons.visibility_off
                              : Icons.visibility,
                          label: isActive ? "Desativar" : "Ativar",
                          color: isActive
                              ? Colors.grey.shade700
                              : Colors.green.shade600,
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildPropertyActionButton(
                          icon:
                              isSaved ? CupertinoIcons.eye : CupertinoIcons.pen,
                          label: isSaved ? "Ver" : "Editar",
                          color: isSaved ? accentColor : Colors.blue.shade600,
                          isTablet: isTablet,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPropertyActionButton(
                          icon: isSaved
                              ? Icons.delete_outline
                              : isActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                          label: isSaved
                              ? "Remover"
                              : isActive
                                  ? "Desativar"
                                  : "Ativar",
                          color: isSaved
                              ? Colors.red.shade400
                              : isActive
                                  ? Colors.grey.shade700
                                  : Colors.green.shade600,
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Property stats item
  Widget _buildPropertyStat({
    required IconData icon,
    required String value,
    required String label,
    required bool isTablet,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 12 : 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Property action button
  Widget _buildPropertyActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Handle property action
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isTablet ? 18 : 16,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12 : 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Delegate for sliver app bar with tabs
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
