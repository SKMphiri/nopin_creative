import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/shared/widgets/property_attribure.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';
import 'package:permission_handler/permission_handler.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  late LatLng _initialCameraPosition;
  bool _isExpandedCard = false;
  Property? _selectedProperty;
  bool _isContainerVisible = false;
  String? _activeFilter;
  late final TextEditingController controller;
  bool _isPriceFilterApplied = false;
  double _minPrice = 0;
  double _maxPrice = 12000000;
  bool _hasLocationPermission = false;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _selectedProperty = properties.isNotEmpty ? properties[0] : null;
    _isContainerVisible = _selectedProperty != null;
    controller = TextEditingController();
    _initialCameraPosition = properties.isNotEmpty
        ? properties.first.position
        : const LatLng(-25.966667, 32.583333); // Default to Maputo
    _requestLocationPermission();
  }

  @override
  void dispose() {
    controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (mounted) {
      setState(() {
        _hasLocationPermission = status.isGranted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Map takes the entire screen
          SizedBox.expand(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition,
                zoom: 12,
              ),
              myLocationEnabled: _hasLocationPermission,
              myLocationButtonEnabled: _hasLocationPermission,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: _createMarkers(),
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),

          // Search bar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left_outlined,
                          size: screenWidth * 0.07,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),

                    // Search bar
                    Expanded(
                      child: Container(
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30.0),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black87,
                              size: screenWidth * 0.05,
                            ),
                            hintText: 'Procurar propriedades...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: screenWidth * 0.04,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + screenHeight * 0.09,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterButton(
                    'Comprar',
                    _activeFilter == 'Comprar',
                    () => setState(() {
                      _activeFilter =
                          _activeFilter == 'Comprar' ? null : 'Comprar';
                    }),
                    screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  _buildFilterButton(
                    'Arrendar',
                    _activeFilter == 'Arrendar',
                    () => setState(() {
                      _activeFilter =
                          _activeFilter == 'Arrendar' ? null : 'Arrendar';
                    }),
                    screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  _buildFilterButton(
                    'Terreno',
                    _activeFilter == 'Terreno',
                    () => setState(() {
                      _activeFilter =
                          _activeFilter == 'Terreno' ? null : 'Terreno';
                    }),
                    screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  _buildPriceFilterButton(screenWidth),
                ],
              ),
            ),
          ),

          // Property details card
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom:
                _isContainerVisible ? screenHeight * 0.02 : -screenHeight * 0.4,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            height: _isExpandedCard ? screenHeight * 0.75 : screenHeight * 0.18,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_isExpandedCard ? 30 : 20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: _isContainerVisible && _selectedProperty != null
                  ? _isExpandedCard
                      ? _buildExpandedCardContent(_selectedProperty!)
                      : _buildCollapsedCardContent(_selectedProperty!)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      String label, bool isActive, VoidCallback onPressed, double screenWidth) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045,
          vertical: screenWidth * 0.025,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.white : Colors.black87,
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFilterButton(double screenWidth) {
    return GestureDetector(
      onTap: _showPriceFilterBottomSheet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(screenWidth * 0.025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPriceFilterApplied
              ? Colors.black87
              : Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.tune,
          size: screenWidth * 0.05,
          color: _isPriceFilterApplied ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  void _showPriceFilterBottomSheet() {
    double tempMinPrice = _minPrice;
    double tempMaxPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar por Preço',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Intervalo de Preço (MZN)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              RangeSlider(
                values: RangeValues(tempMinPrice, tempMaxPrice),
                min: 0,
                max: 12000000,
                divisions: 24,
                labels: RangeLabels(
                  'MZN ${tempMinPrice.toStringAsFixed(0)}',
                  'MZN ${tempMaxPrice.toStringAsFixed(0)}',
                ),
                activeColor: Colors.black87,
                inactiveColor: Colors.grey[300],
                onChanged: (RangeValues values) {
                  setModalState(() {
                    tempMinPrice = values.start;
                    tempMaxPrice = values.end;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _minPrice = tempMinPrice;
                          _maxPrice = tempMaxPrice;
                          _isPriceFilterApplied = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        minimumSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.064,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Aplicar',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _minPrice = 0;
                        _maxPrice = 12000000;
                        _isPriceFilterApplied = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Limpar',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    if (properties.isEmpty) return {};

    var filteredProperties = properties.where((property) {
      bool matchesType = _activeFilter == null ||
          (_activeFilter == 'Comprar' && property.type == PropertyType.house) ||
          (_activeFilter == 'Arrendar' && property.type == PropertyType.rent) ||
          (_activeFilter == 'Terreno' && property.type == PropertyType.land);
      bool matchesPrice =
          property.price >= _minPrice && property.price <= _maxPrice;
      return matchesType && matchesPrice;
    }).toList();

    // Limit to 15 properties to prevent rendering issues
    filteredProperties = filteredProperties.take(15).toList();

    return filteredProperties.map((property) {
      return Marker(
        markerId: MarkerId(property.id),
        position: property.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            _getHueForPropertyType(property.type)),
        onTap: () {
          setState(() {
            _selectedProperty = property;
            _isExpandedCard = false;
            _isContainerVisible = true;
          });
        },
      );
    }).toSet();
  }

  double _getHueForPropertyType(PropertyType type) {
    switch (type) {
      case PropertyType.land:
        return BitmapDescriptor.hueGreen;
      case PropertyType.rent:
        return BitmapDescriptor.hueBlue;
      case PropertyType.house:
        return BitmapDescriptor.hueRed;
    }
  }

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

  Widget _buildCollapsedCardContent(Property property) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => setState(() => _isExpandedCard = true),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                _getImageForProperty(property),
                width: screenWidth * 0.28,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "MZN ${property.price.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: property.type == PropertyType.rent ? "/mês" : "",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.015),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: Text(
                        property.location,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: screenWidth * 0.03,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                if (property.attributes.isNotEmpty)
                  Wrap(
                    spacing: screenWidth * 0.02,
                    runSpacing: screenWidth * 0.01,
                    children: property.attributes.entries
                        .take(3)
                        .map((entry) =>
                            _buildSmallAttributeChip(entry, screenWidth))
                        .toList(),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.black87,
              size: screenWidth * 0.06,
            ),
            onPressed: () => setState(() => _isExpandedCard = true),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAttributeChip(
      MapEntry<PropertyAttributeType, int> entry, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForAttribute(entry.key),
            size: screenWidth * 0.035,
            color: Colors.black87,
          ),
          SizedBox(width: screenWidth * 0.01),
          Text(
            '${entry.value}',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForAttribute(PropertyAttributeType type) {
    switch (type) {
      case PropertyAttributeType.room:
        return Icons.bed;
      case PropertyAttributeType.wc:
        return Icons.bathroom;
      case PropertyAttributeType.pool:
        return Icons.pool;
      case PropertyAttributeType.parking:
        return Icons.directions_car;
      case PropertyAttributeType.width:
        return Icons.width_normal;
      case PropertyAttributeType.length:
        return Icons.straighten;
    }
  }

  Widget _buildExpandedCardContent(Property property) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30.0)),
                child: Image.asset(
                  _getImageForProperty(property),
                  width: double.infinity,
                  height: screenWidth * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: screenWidth * 0.04,
                right: screenWidth * 0.04,
                child: GestureDetector(
                  onTap: () => setState(() => _isExpandedCard = false),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.02,
                      height: screenWidth * 0.02,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      _getPropertyTypeLabel(property.type),
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.03),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "MZN ${property.price.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: property.type == PropertyType.rent ? "/mês" : "",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: screenWidth * 0.04,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Expanded(
                      child: Text(
                        property.location,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.04),
                Wrap(
                  spacing: screenWidth * 0.03,
                  runSpacing: screenWidth * 0.02,
                  children: property.attributes.entries
                      .map((entry) => _buildAttributeChip(entry, screenWidth))
                      .toList(),
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  property.description,
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          minimumSize: Size(0, screenWidth * 0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        icon: Icon(
                          Icons.message,
                          color: Colors.white,
                          size: screenWidth * 0.05,
                        ),
                        label: Text(
                          "Mensagem",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: Size(0, screenWidth * 0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        icon: Icon(
                          Icons.call,
                          color: Colors.black87,
                          size: screenWidth * 0.05,
                        ),
                        label: Text(
                          "Contactar",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildAttributeChip(
      MapEntry<PropertyAttributeType, int> entry, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForAttribute(entry.key),
            size: screenWidth * 0.04,
            color: Colors.black87,
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            '${entry.value}',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getPropertyTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.house:
        return 'À Venda';
      case PropertyType.rent:
        return 'Arrenda-se';
      case PropertyType.land:
        return 'Terreno';
    }
  }
}
