import 'package:flutter/material.dart';

class OfferDetails extends StatelessWidget {
  final String title;
  final String location;
  final double price;
  final String assetImagePath;
  final int bedrooms;
  final int bathrooms;
  final bool parking;
  final String description;

  const OfferDetails({
    super.key,
    required this.title,
    required this.location,
    required this.price,
    required this.assetImagePath,
    required this.bedrooms,
    required this.bathrooms,
    required this.parking,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      clipBehavior: Clip.hardEdge,
      child: Column(
 mainAxisSize: MainAxisSize.min, // Ensures the co
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Asset Image
          Stack(
            clipBehavior: Clip.hardEdge,
            children: [
               ClipRRect(
                 borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
      topRight: Radius.circular(30),),
                child: Image.asset(
                  assetImagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.fitWidth ,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        // Add share functionality here
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.flag, color: Colors.white),
                      onPressed: () {
                        // Add report functionality here
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  location,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  "MZN ${price.toStringAsFixed(2)}/mes",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.bed),
                        Text("$bedrooms Quartos"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.bathtub),
                        Text("$bathrooms Casas de Banho"),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.local_parking),
                        Text(parking ? "Estacionamento" : "Sem Estacionamento"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Placeholder for a map or other content
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Message functionality
                      },
                      icon: const Icon(Icons.message),
                      label: const Text("Mensagem"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Call functionality
                      },
                      icon: const Icon(Icons.call),
                      label: const Text("Chamada"),
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
