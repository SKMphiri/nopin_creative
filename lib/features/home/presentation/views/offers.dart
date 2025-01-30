
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/widgets/custom_input.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';
import 'package:nopin_creative/features/home/presentation/views/offers_details.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  final welcomeMessage = "Ola, Dhalitso!";

  late final TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                  BorderSide(width: 1, color: AppColors.primary))),
          child: const CircleAvatar(
            backgroundColor: Color(0XFFD9D9D9),
            radius: 25,
            child: Text(
              "D",
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(20),
            child: Image(image: AssetImage(AppIcons.notification)),
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                welcomeMessage,
                style: const TextStyle(fontSize: 24),
              ),
              CustomInput(
                controller: searchController,
                iconUri: AppIcons.search,
                iconSize: 6,
                placeholder: "Procurar...",
              ),
              const SizedBox(
                height: 30,
              ),
              //Quick options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: quickOptions.map((element) {
                  return Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 10,
                              color: Colors.black12)
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AppIcons.rent),
                          width: 30,
                        ),
                        Text(element),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 30,
              ),
              //On demand
              OfferViewPropertyList(
                title: "Propriedades em destaque",
                properties: properties,

              ),
              //recommend
              OfferViewPropertyList(
                title: "Recomendados",
                properties: properties,
                onDemand: false,
              ),
            ],
          ),
        ),
      )),

    );
  }
}

class OfferViewPropertyList extends StatefulWidget {
  const OfferViewPropertyList(
      {super.key, required this.title, required this.properties, this.onDemand = true});

  final String title;
  final List<Property> properties;
  final bool onDemand;

  @override
  State<OfferViewPropertyList> createState() => _OfferViewPropertyListState();
}

class _OfferViewPropertyListState extends State<OfferViewPropertyList> {
  bool isFavorite = false;

  // track favorite state
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Text(
              "Ver todos",
              style: TextStyle(fontSize: 14),
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.properties.map((element) {
              // TODO: NEW ELEMENT ADDED, BOTTOM MODAL SHEET
              return  GestureDetector( onTap: (){
                showModalBottomSheet(
                   isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  builder: (context) {
                    return OfferDetails(
                      title: element.title,
                      location: element.location,
                      price: element.price.toDouble(), bedrooms: 1, bathrooms: 3, parking: true, description: 'lorem', assetImagePath: 'assets/images/beach_house.png',
                    );
                  },
                );
              },
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 5),
                  padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4, top: 4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Colors.black12),
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 0,
                            spreadRadius: 0.5,
                            color: Colors.black12)
                      ]),
                  // height: 810,
                  constraints: const BoxConstraints(minHeight: 230),
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: AssetImage(
                                element.type == PropertyType.land
                                    ? AppImages.land
                                    : AppImages.beachHouse,
                              ),
                              fit: BoxFit.fitWidth,
                              height: 118,
                              width: double.maxFinite,
                            ),
                          ),
                          Visibility(
                            visible: widget.onDemand,
                            child: const Positioned(
                              left: 2,
                              top: 10,
                              child: Image(
                                image: AssetImage(AppImages.trustBadge),
                                width: 40,

                              ),
                            ),
                          ),
                          StatefulBuilder(builder: (context, setState) {
                            return Positioned(
                              bottom: 12,
                              right: 16,
                              child: HeartCircleButton(
                                isFavorite: isFavorite,
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              element.type == PropertyType.rent
                                  ? "Arrenda-se"
                                  : "Terreno",
                              style: const TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "MZN 125.000.00",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "/mês",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(element.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            )),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 8,
                            ),
                            Text(
                              element.location,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 5,
                          runSpacing: 5.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: element.attributes.entries.map(
                            (el) {
                              return renderPropertyAttribute(el);
                            },
                          ).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
//TODO: Scroll effect
  Widget renderPropertyAttribute(
      MapEntry<PropertyAttributeType, int> attribute) {
    String imageUri = "";
    String description = "";
    if (attribute.key == PropertyAttributeType.room) {
      imageUri = AppIcons.bed;
      description = "${attribute.value} Quartos";
    } else if (attribute.key == PropertyAttributeType.wc) {
      imageUri = AppIcons.spa;
      description = "${attribute.value} Casa de banho";
    } else if (attribute.key == PropertyAttributeType.pool) {
      imageUri = AppIcons.pool;
      description = "${attribute.value} Piscina";
    } else if (attribute.key == PropertyAttributeType.parking) {
      imageUri = AppIcons.car;
      description = "${attribute.value} Estacionamento";
    } else if (attribute.key == PropertyAttributeType.width) {
      imageUri = AppIcons.width;
      description = "${attribute.value}M";
    } else if (attribute.key == PropertyAttributeType.length) {
      imageUri = AppIcons.length;
      description = "${attribute.value}M";
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(imageUri),
          width: 12,
          height: 12,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 8),
        )
      ],
    );
  }
}

class HeartCirclePainter extends CustomPainter {
  final bool isFavorite;

  HeartCirclePainter(this.isFavorite);

  /// Returns a [Path] matching the Material "favorite" icon (24x24 viewport).
  /// We'll scale it to fit our [size].
  Path _createFavoritePath(Size size) {
    // The Material icon is defined for a 24x24 "viewBox".
    // We scale that path to fit the painter's size.
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;

    Path path = Path();

    // M12 21.35
    path.moveTo(12 * scaleX, 21.35 * scaleY);
    // L10.55 20.03
    path.lineTo(10.55 * scaleX, 20.03 * scaleY);

    // C5.4 15.36 2 12.28 2 8.5
    path.cubicTo(
      5.4 * scaleX,
      15.36 * scaleY,
      2 * scaleX,
      12.28 * scaleY,
      2 * scaleX,
      8.5 * scaleY,
    );

    // C2 5.42 4.42 3 7.5 3
    path.cubicTo(
      2 * scaleX,
      5.42 * scaleY,
      4.42 * scaleX,
      3 * scaleY,
      7.5 * scaleX,
      3 * scaleY,
    );

    // c1.74 0 3.41.81 4.5 2.09
    // (heart's top arcs)
    path.cubicTo(
      9.24 * scaleX,
      3 * scaleY,
      10.91 * scaleX,
      3.81 * scaleY,
      12 * scaleX,
      5.09 * scaleY,
    );
    path.cubicTo(
      13.09 * scaleX,
      3.81 * scaleY,
      14.76 * scaleX,
      3 * scaleY,
      16.5 * scaleX,
      3 * scaleY,
    );

    // C19.58 3 22 5.42 22 8.5
    path.cubicTo(
      19.58 * scaleX,
      3 * scaleY,
      22 * scaleX,
      5.42 * scaleY,
      22 * scaleX,
      8.5 * scaleY,
    );

    // c0 3.78-3.4 6.86-8.55 11.54l-1.45 1.31z
    path.cubicTo(
      22 * scaleX,
      12.28 * scaleY,
      18.6 * scaleX,
      15.36 * scaleY,
      13.45 * scaleX,
      20.04 * scaleY,
    );
    path.lineTo(12 * scaleX, 21.35 * scaleY);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paints we’ll use
    final Paint whitePaint = Paint()..color = Colors.white;
    final Paint redPaint = Paint()..color = Colors.red;

    // Draw a white circle first.
    double radius = min(size.width / 1.1, size.height / 1.1);
    final circlePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2.1, size.height / 2.2),
        radius: radius,
      ));

    // Create the heart path, scaled to fill this painter's 36x36 area.
    Path heartPath = _createFavoritePath(size);

    if (isFavorite) {
      // 1. Draw the entire circle in white
      canvas.drawPath(circlePath, whitePaint);
      // 2. Draw a red heart on top
      canvas.drawPath(heartPath, redPaint);
    } else {
      // Subtract the heart from the white circle to reveal the image behind
      Path finalPath = Path.combine(
        PathOperation.difference,
        circlePath,
        heartPath,
      );
      canvas.drawPath(finalPath, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant HeartCirclePainter oldDelegate) {
    return oldDelegate.isFavorite != isFavorite;
  }
}

class HeartCircleButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const HeartCircleButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: HeartCirclePainter(isFavorite),
        child: const SizedBox(
          width: 18,
          height: 18,
        ),
      ),
    );
  }
}
