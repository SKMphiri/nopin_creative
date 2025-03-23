import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/core/shared/widgets/custom_input.dart';
import 'package:nopin_creative/core/shared/widgets/property_attribure.dart';
import 'package:nopin_creative/features/explore/presentation/views/explore.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';
import 'package:nopin_creative/features/home/presentation/views/offers_details.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView>
    with AutomaticKeepAliveClientMixin {
  final welcomeMessage = "Ola, Dhalitso!";
  late final TextEditingController searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // Prevent rebuilding when switching tabs

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showPropertyDetails(Property property) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) => OfferDetails(
        title: property.title,
        location: property.location,
        price: property.price,
        assetImagePath: _getImageForProperty(property),
        bedrooms: property.attributes[PropertyAttributeType.room] ?? 0,
        bathrooms: property.attributes[PropertyAttributeType.wc] ?? 0,
        parking: (property.attributes[PropertyAttributeType.parking] ?? 0) > 0,
        description: property.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    final isTablet = ResponsiveLayout.isTablet(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final gridCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    // Color theme
    final Color primaryTextColor = Colors.black87;
    final Color secondaryTextColor = Colors.black54;
    final Color accentColor = AppColors.primary;
    final Color bgColor = Colors.white;
    final Color cardShadowColor = Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
        titleSpacing: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(left: isTablet ? 24 : 20),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            radius: 25,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 22,
                child: const Text(
                  "D",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcomeMessage,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            Text(
              "Encontre seu imóvel ideal",
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.normal,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: isTablet ? 26 : 22,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ExploreView()));
            },
            icon: Icon(
              CupertinoIcons.location,
              color: primaryTextColor,
            ),
          ),
          IconButton(
            iconSize: isTablet ? 26 : 22,
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.bell,
              color: primaryTextColor,
            ),
          ),
          SizedBox(width: isTablet ? 16 : 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: context.paddingDefault,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CustomInput(
                        controller: searchController,
                        hint: "Pesquisar propriedades...",
                        leadingIcon: Icon(
                          CupertinoIcons.search,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick options
                    Text(
                      "Explorar por categoria",
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Responsive quick option menu
                    ResponsiveLayout(
                      mobile: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            buildQuickOption("Arrendar",
                                CupertinoIcons.house_alt, accentColor),
                            buildQuickOption(
                                "Comprar", CupertinoIcons.cart, accentColor),
                            buildQuickOption(
                                "Terreno", CupertinoIcons.tree, accentColor),
                            buildQuickOption(
                                "Explorar", CupertinoIcons.map, accentColor,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ExploreView()))),
                          ],
                        ),
                      ),
                      tablet: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          buildQuickOption(
                              "Arrendar", CupertinoIcons.house_alt, accentColor,
                              isLarge: true),
                          buildQuickOption(
                              "Comprar", CupertinoIcons.cart, accentColor,
                              isLarge: true),
                          buildQuickOption(
                              "Terreno", CupertinoIcons.tree, accentColor,
                              isLarge: true),
                          buildQuickOption(
                              "Explorar", CupertinoIcons.map, accentColor,
                              isLarge: true,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExploreView()))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Featured properties
                    PropertyListSection(
                      title: "Propriedades em destaque",
                      subtitle: "Imóveis escolhidos para você",
                      properties: properties,
                      onPropertyTap: _showPropertyDetails,
                      isFeatured: true,
                    ),

                    const SizedBox(height: 32),

                    // Recommended properties
                    PropertyListSection(
                      title: "Recomendados",
                      subtitle: "Baseado em suas preferências",
                      properties: properties,
                      onPropertyTap: _showPropertyDetails,
                      isFeatured: false,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(
              child:
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickOption(String label, IconData icon, Color accentColor,
      {bool isLarge = false, VoidCallback? onTap}) {
    final container = Container(
      margin: const EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 14,
        vertical: isLarge ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isLarge ? 24 : 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }

  // Helper method to get image based on property type
  String _getImageForProperty(Property property) {
    switch (property.type) {
      case PropertyType.house:
        return AppImages.beachHouse;
      case PropertyType.rent:
        return AppImages.beachHouse2;
      case PropertyType.land:
        return AppImages.land;
      default:
        return AppImages.house;
    }
  }
}

class PropertyListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Property> properties;
  final Function(Property) onPropertyTap;
  final bool isFeatured;

  const PropertyListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.properties,
    required this.onPropertyTap,
    this.isFeatured = true,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Row(
                children: [
                  Text(
                    "Ver todos",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Properties list
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return PropertyCard(
                property: property,
                onTap: () => onPropertyTap(property),
                isFeatured: isFeatured,
              );
            },
          ),
        ),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  final bool isFeatured;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRental = property.type == PropertyType.rent;
    final accentColor = AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                // Property image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    _getImagePath(),
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),

                // Featured badge
                if (isFeatured)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.star_fill,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Destaque",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Property type badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isRental ? Colors.blue : accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isRental ? "Aluguel" : "Venda",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Favorite button
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.heart,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Row(
                    children: [
                      Text(
                        "MZN ${property.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      if (isRental)
                        Text(
                          "/mês",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Features
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildFeature(
                        CupertinoIcons.bed_double,
                        "${property.attributes[PropertyAttributeType.room] ?? 0}",
                      ),
                      const SizedBox(width: 16),
                      _buildFeature(
                        CupertinoIcons.drop,
                        "${property.attributes[PropertyAttributeType.wc] ?? 0}",
                      ),
                      const SizedBox(width: 16),
                      _buildFeature(
                        CupertinoIcons.car_detailed,
                        "${property.attributes[PropertyAttributeType.parking] ?? 0}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _getImagePath() {
    switch (property.type) {
      case PropertyType.house:
        return AppImages.beachHouse;
      case PropertyType.rent:
        return AppImages.beachHouse2;
      case PropertyType.land:
        return AppImages.land;
      default:
        return AppImages.house;
    }
  }
}
