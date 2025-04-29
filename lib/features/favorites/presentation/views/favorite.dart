import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/features/home/presentation/views/offers_details.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  // Tabs for different favorite categories
  final List<String> _categories = [
    "Todos",
    "Terrenos",
    "Casas",
    "Apartamentos",
    "Comercial"
  ];

  String _selectedCategory = "Todos";

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final accentColor = AppColors.primary;
    final useCompactLayout = screenWidth < 360; // For very narrow screens

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // App Bar
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _showSearchBar
                  ? _buildSearchField()
                  : Text(
                      "Favoritos",
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 22 : 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  _showSearchBar ? CupertinoIcons.xmark : CupertinoIcons.search,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _showSearchBar = !_showSearchBar;
                    if (!_showSearchBar) {
                      _searchController.clear();
                    } else {
                      // Focus the text field when showing search bar
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  });
                },
              ),
              if (!_showSearchBar)
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.bell,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    // Navigate to notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Notificações em breve!',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: accentColor,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      ),
                    );
                  },
                ),
            ],
          ),

          // Category tabs
          SliverPersistentHeader(
            delegate: _SliverCategoryTabsDelegate(
              child: _buildCategoryTabs(isTablet, accentColor),
              height: isTablet ? 60 : 50,
            ),
            pinned: true,
          ),

          // Stats banner
          SliverToBoxAdapter(
            child: _buildStatsBanner(
                isTablet, accentColor, useCompactLayout, screenWidth),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            // Simulate a refresh operation with a delay
            await Future.delayed(const Duration(milliseconds: 1500));
            setState(() {
              // Refresh data would happen here
            });
          },
          color: accentColor,
          child: _buildFavoritesList(isTablet, accentColor, screenHeight,
              useCompactLayout, screenWidth),
        ),
      ),
      // Add a floating action button for filtering
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterOptions(context);
        },
        backgroundColor: accentColor,
        child:
            const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      cursorColor: AppColors.primary,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Procurar propriedade favorita...",
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCategoryTabs(bool isTablet, Color accentColor) {
    return Container(
      height: isTablet ? 60 : 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? accentColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accentColor.withValues(alpha:0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                category,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: isTablet ? 15 : 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsBanner(bool isTablet, Color accentColor,
      bool useCompactLayout, double screenWidth) {
    // For very narrow screens, use a simpler layout
    if (useCompactLayout) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildStatItem(
              icon: CupertinoIcons.heart_fill,
              count: "24",
              label: "Propriedades salvas",
              color: Colors.red.shade400,
              isTablet: isTablet,
            ),
            const SizedBox(height: 12),
            _buildStatItem(
              icon: CupertinoIcons.bell_fill,
              count: "12",
              label: "Alertas ativos",
              color: accentColor,
              isTablet: isTablet,
            ),
          ],
        ),
      );
    }

    // For wider screens, use a row layout
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: CupertinoIcons.heart_fill,
            count: "24",
            label: "Propriedades salvas",
            color: Colors.red.shade400,
            isTablet: isTablet,
          ),
          Container(
            height: isTablet ? 40 : 30,
            width: 1,
            color: Colors.grey.shade200,
          ),
          _buildStatItem(
            icon: CupertinoIcons.bell_fill,
            count: "12",
            label: "Alertas ativos",
            color: accentColor,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 20 : 16,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                fontSize: isTablet ? 13 : 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoritesList(bool isTablet, Color accentColor,
      double screenHeight, bool useCompactLayout, double screenWidth) {
    // Generate some sample data
    final favoriteItems = List.generate(
      8,
      (index) => {
        "title": index % 2 == 0
            ? "Casa com ${2 + index % 3} quartos em Matola"
            : "Terreno ${200 + index * 50}m² em Costa do Sol",
        "price": "MZN ${(2 + index) * 1000000}",
        "location": index % 2 == 0 ? "Matola, Maputo" : "Costa do Sol, Maputo",
        "type": index % 2 == 0 ? "Casa" : "Terreno",
        "date": "Salvo em ${10 + index % 30}/06/2023",
        "image": index % 3 == 0
            ? AppImages.beachHouse
            : index % 3 == 1
                ? AppImages.beachHouse2
                : AppImages.beachHouse3,
        "features": index % 2 == 0
            ? [
                "${2 + index % 3} quartos",
                "${1 + index % 2} banheiros",
                "Estacionamento"
              ]
            : ["${200 + index * 50}m²", "Terreno", "Documentos em dia"],
      },
    );

    if (favoriteItems.isEmpty) {
      return _buildEmptyState(isTablet);
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
          16, 8, 16, 80), // Added bottom padding for FAB
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? (screenWidth > 900 ? 3 : 2) : 1,
        childAspectRatio:
            isTablet ? 0.8 : (screenWidth / (screenHeight * 0.62)),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        final item = favoriteItems[index];
        return _buildFavoriteCard(
          title: item["title"] as String,
          price: item["price"] as String,
          location: item["location"] as String,
          type: item["type"] as String,
          date: item["date"] as String,
          image: item["image"] as String,
          features: (item["features"] as List<dynamic>).cast<String>(),
          isTablet: isTablet,
          accentColor: accentColor,
          screenHeight: screenHeight,
          useCompactLayout: useCompactLayout,
        );
      },
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.heart,
            size: isTablet ? 80 : 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            "Sem favoritos",
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "As propriedades que você marcar como favoritas aparecerão aqui",
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to offers view
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              "Explorar propriedades",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard({
    required String title,
    required String price,
    required String location,
    required String type,
    required String date,
    required String image,
    required List<String> features,
    required bool isTablet,
    required Color accentColor,
    required double screenHeight,
    required bool useCompactLayout,
  }) {
    final imageHeight = isTablet ? 160.0 : (screenHeight < 700 ? 140.0 : 160.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image with favorite button
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _showPropertyDetails(context);
                },
                child: Hero(
                  tag: 'property_image_$title',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showRemoveConfirmation(context);
                    },
                    child: Icon(
                      CupertinoIcons.heart_fill,
                      color: Colors.red.shade400,
                      size: isTablet ? 22 : 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha:0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12 : 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Property details
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showPropertyDetails(context);
              },
              child: Padding(
                padding: EdgeInsets.all(useCompactLayout ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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

                    // Price
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),

                    // Features row
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 26,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: features.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              features[index],
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 11 : 10,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Location and date
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.location,
                                size: 15,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  location,
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 12 : 10,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12 : 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha:0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isTablet ? 18 : 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13 : 11,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPropertyDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: OfferDetails(
              title: "Casa com 3 quartos em Matola",
              location: "Matola, Maputo",
              price: 4800000,
              assetImagePath: AppImages.beachHouse,
              bedrooms: 3,
              bathrooms: 2,
              parking: true,
              description:
                  "Linda casa moderna com 3 quartos, 2 banheiros, cozinha equipada e jardim amplo. Localizada em área tranquila da Matola, próxima a escolas e comércio.",
            ),
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Remover dos favoritos",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          "Tem certeza que deseja remover esta propriedade dos seus favoritos?",
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Remove property from favorites
              Navigator.pop(context);

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Propriedade removida dos favoritos",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.red.shade400,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  action: SnackBarAction(
                    label: "Desfazer",
                    textColor: Colors.white,
                    onPressed: () {
                      // Add property back to favorites
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: Text(
              "Remover",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final accentColor = AppColors.primary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Header with drag handle
            Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      Text(
                        "Filtrar favoritos",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: accentColor,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Reset filters
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Limpar",
                          style: GoogleFonts.poppins(
                            color: accentColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tipo de Propriedade",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filter options would go here
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildFilterChip("Todos", true),
                        _buildFilterChip("Terrenos", false),
                        _buildFilterChip("Casas", false),
                        _buildFilterChip("Apartamentos", false),
                        _buildFilterChip("Comercial", false),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "Preço",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Price range slider would go here

                    const SizedBox(height: 24),
                    Text(
                      "Localização",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Location options would go here
                  ],
                ),
              ),
            ),

            // Apply button
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Apply filters
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Aplicar filtros",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      onSelected: (value) {
        // Handle filter selection
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      showCheckmark: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _SliverCategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverCategoryTabsDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: height,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
