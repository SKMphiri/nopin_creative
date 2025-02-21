import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/shared/widgets/property_attribure.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final LatLng _initialCameraPosition = const LatLng(-25.955582410694454, 32.59946372579154);
  bool _isExpandedCard = false;
  Property? _selectedProperty;
  bool _isContainerVisible = false;
  String? _activeFilter;
  late final TextEditingController controller;
  bool _isPriceFilterApplied = false;
  double _minPrice = 0;
  double _maxPrice = 12000000;

  @override
  void initState() {
    super.initState();
    _selectedProperty = properties[0];
    _isContainerVisible = true;
    controller = TextEditingController();
  }

  Set<Marker> _createMarkers() {
    var filteredProperties = properties.where((property) {
      bool matchesType = _activeFilter == null ||
          (_activeFilter == 'Comprar' && property.type == PropertyType.house) ||
          (_activeFilter == 'Arrendar' && property.type == PropertyType.rent) ||
          (_activeFilter == 'Terreno' && property.type == PropertyType.land);
      bool matchesPrice = property.price >= _minPrice && property.price <= _maxPrice;
      return matchesType && matchesPrice;
    }).toList();

    return filteredProperties.map((property) {
      return Marker(
        markerId: MarkerId(property.id),
        position: property.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(_getHueForPropertyType(property.type)),
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showPriceFilterBottomSheet(BuildContext context) {
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Responsive padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar por Preço',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Intervalo de Preço (MZN)',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
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
                        minimumSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.064),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FutureBuilder<Set<Marker>>(
              future: _buildMarkersWithIcons(),
              builder: (context, snapshot) {
                Set<Marker> markers = snapshot.data ?? _createMarkers();
                return GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 12),
                  markers: markers,
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.95),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
                            BoxShadow(color: Colors.white70, blurRadius: 8, offset: Offset(-2, -2)),
                          ],
                        ),
                        child: Icon(Icons.chevron_left_outlined, size: screenWidth * 0.07, color: Colors.black87),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: screenHeight * 0.06, // Responsive height
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.3),
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: Colors.white.withValues(alpha:0.5)),
                            ),
                            child: TextField(
                              controller: controller,
                              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04, color: Colors.black87),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  child: Image.asset(AppIcons.search, color: Colors.black87, width: screenWidth * 0.05, height: screenWidth * 0.05),
                                ),
                                hintText: 'Procurar propriedades...',
                                hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: screenWidth * 0.04),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                              ),
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
          Positioned(
            top: MediaQuery.of(context).padding.top + screenHeight * 0.1, // Adjust for SafeArea and responsive spacing
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterButton(
                    label: 'Comprar',
                    isActive: _activeFilter == 'Comprar',
                    onPressed: () => setState(() {
                      _activeFilter = _activeFilter == 'Comprar' ? null : 'Comprar';
                    }),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  FilterButton(
                    label: 'Arrendar',
                    isActive: _activeFilter == 'Arrendar',
                    onPressed: () => setState(() {
                      _activeFilter = _activeFilter == 'Arrendar' ? null : 'Arrendar';
                    }),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  FilterButton(
                    label: 'Terreno',
                    isActive: _activeFilter == 'Terreno',
                    onPressed: () => setState(() {
                      _activeFilter = _activeFilter == 'Terreno' ? null : 'Terreno';
                    }),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  InkWell(
                    onTap: () => _showPriceFilterBottomSheet(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(screenWidth * 0.025),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isPriceFilterApplied ? Colors.black87 : Colors.white.withValues(alpha: 0.95),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Icon(
                        Icons.tune,
                        size: screenWidth * 0.05,
                        color: _isPriceFilterApplied ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isContainerVisible ? screenHeight * 0.02 : -screenHeight * 0.4,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            height: _isExpandedCard ? screenHeight * 0.8 : screenHeight * 0.16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_isExpandedCard ? 30 : 20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 0), spreadRadius: 2),
                ],
              ),
              child: _isContainerVisible
                  ? _isExpandedCard
                  ? buildExpandedCardContent(_selectedProperty!)
                  : buildCollapsedCardContent(_selectedProperty!)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Future<Set<Marker>> _buildMarkersWithIcons() async {
    Set<Marker> markers = {};
    var filteredProperties = properties.where((property) {
      bool matchesType = _activeFilter == null ||
          (_activeFilter == 'Comprar' && property.type == PropertyType.house) ||
          (_activeFilter == 'Arrendar' && property.type == PropertyType.rent) ||
          (_activeFilter == 'Terreno' && property.type == PropertyType.land);
      bool matchesPrice = property.price >= _minPrice && property.price <= _maxPrice;
      return matchesType && matchesPrice;
    }).toList();

    for (var property in filteredProperties) {
      // bool isSelected = property.id == _selectedProperty?.id;
      BitmapDescriptor customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        AppIcons.locationPin,
      );
      markers.add(
        Marker(
          markerId: MarkerId(property.id),
          icon: customIcon,
          position: property.position,
          onTap: () {
            setState(() {
              _selectedProperty = property;
              _isExpandedCard = false;
              _isContainerVisible = true;
            });
          },
        ),
      );
    }
    return markers;
  }

  Widget buildCollapsedCardContent(Property property) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => setState(() => _isExpandedCard = true),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(AppImages.beachHouse, width: screenWidth * 0.35, height: double.maxFinite,  fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
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
                    Icon(Icons.location_on_rounded, size: screenWidth * 0.035, color: Colors.grey[600]),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: Text(
                        property.location,
                        style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: screenWidth * 0.03),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                Wrap(
                  spacing: screenWidth * 0.02,
                  runSpacing: screenWidth * 0.01,
                  children: property.attributes.entries
                      .take(3)
                      .map((el) => renderPropertyAttribute(el, size: 1.2))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpandedCardContent(Property property) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Image.asset(AppImages.beachHouse, width: double.infinity, height: screenWidth * 0.6, fit: BoxFit.cover),
              ),
              Positioned(
                top: screenWidth * 0.04,
                right: screenWidth * 0.04,
                child: GestureDetector(
                  onTap: () => setState(() => _isExpandedCard = false),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: Icon(Icons.close, color: Colors.white, size: screenWidth * 0.05),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.02,
                      height: screenWidth * 0.02,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      property.type == PropertyType.rent ? "Arrenda-se" : "À Venda",
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.black87),
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
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: property.type == PropertyType.rent ? "/mês" : "",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: screenWidth * 0.04, color: Colors.grey[600]),
                    SizedBox(width: screenWidth * 0.015),
                    Expanded(
                      child: Text(
                        property.location,
                        style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.04),
                Wrap(
                  spacing: screenWidth * 0.03,
                  runSpacing: screenWidth * 0.02,
                  children: property.attributes.entries
                      .map((el) => renderPropertyAttribute(el, size: 1.4))
                      .toList(),
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  property.description,
                  style: GoogleFonts.poppins(color: Colors.black87, fontSize: screenWidth * 0.035),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 5,
                        ),
                        icon: Icon(Icons.alternate_email, color: Colors.white, size: screenWidth * 0.05),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 5,
                        ),
                        icon: Icon(Icons.call, color: Colors.black87, size: screenWidth * 0.05),
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
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045, vertical: screenWidth * 0.025),
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.white.withValues(alpha:0.9),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:0.1), blurRadius: 6, offset: const Offset(0, 2)),
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
}