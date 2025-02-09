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
  final LatLng _isutc = LatLng(-25.955582410694454, 32.59946372579154);
  final LatLng _isctem = LatLng(-25.977376277196925, 32.58152365031621);
  bool _isExpandedCard = false; // State to control card expansion

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(target: _isutc, zoom: 15),
            markers: {
              Marker(
                markerId: MarkerId("_currentLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: _isutc,
              ),
              Marker(
                markerId: MarkerId("_otherLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: _isctem,
              )
            },
          ),
          AnimatedPositioned(
            // Changed to AnimatedPositioned for smooth transition
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: _isExpandedCard ? screenHeight * 0.8 : 160,
            // Expanded height, adjust as needed
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      _isExpandedCard ? 30 : 10), // Rounded corners on expand
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3, // Increased blur for expanded state
                        offset: Offset(0, 0),
                        spreadRadius: 2) // Increased spread for expanded state
                  ]),
              child: _isExpandedCard
                  ? buildExpandedCardContent() // Build expanded content
                  : buildCollapsedCardContent(), // Build collapsed content
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCollapsedCardContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const Image(
            image: AssetImage(AppImages.beachHouse),
            width: 120,
            height: 130,
            fit: BoxFit.fitHeight,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "MZN 125.000.00",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "/mês",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ])),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      properties[0].location,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 12,
                  runSpacing: 5.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: properties[0]
                      .attributes
                      .entries
                      .map(
                        (el) {
                          return renderPropertyAttribute(el, size: 1.3);
                        },
                      )
                      .toList()
                      .sublist(0, properties[0].attributes.entries.length - 2),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isExpandedCard =
                            !_isExpandedCard; // Toggle expansion state
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF333333),
                      minimumSize: const Size(double.maxFinite, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Ver Detalhes",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildExpandedCardContent() {
    return SingleChildScrollView(
      // Added SingleChildScrollView for scrollable content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            // More rounded in expanded state
            child: const Image(
              image: AssetImage(AppImages.beachHouse),
              width: double.infinity,
              // Image takes full width in expanded state
              height: 200,
              // Adjust height as needed in expanded state
              fit: BoxFit.cover, // Use BoxFit.cover for expanded image
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "MZN 125.000.00",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 22, // Larger font in expanded state
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "/mês",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16, // Larger font in expanded state
                      fontWeight: FontWeight.bold)),
            ])),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 14, // Slightly larger icon
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  properties[0].location,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12, // Larger font in expanded state
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 12,
              runSpacing: 8.0,
              // Increased runSpacing in expanded
              crossAxisAlignment: WrapCrossAlignment.center,
              children: properties[0].attributes.entries.map(
                (el) {
                  return renderPropertyAttribute(el,
                      size: 1.5); // Slightly larger attribute icons
                },
              ).toList(), // Show all attributes in expanded state, no sublist
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isExpandedCard =
                      !_isExpandedCard; // Toggle back to collapsed
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                minimumSize: const Size(double.maxFinite, 50),
                // Larger button in expanded
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Ver Detalhes",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16, // Larger font in expanded
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
