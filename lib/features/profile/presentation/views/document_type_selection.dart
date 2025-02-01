import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/features/profile/presentation/views/capture_document.dart';

class DocumentTypeSelection extends StatefulWidget {
  const DocumentTypeSelection({super.key});

  @override
  State<DocumentTypeSelection> createState() => _DocumentTypeSelectionState();
}

class _DocumentTypeSelectionState extends State<DocumentTypeSelection> {
  final docs = const [
    {
      "type": "Bilhete de Identidade",
      "icon": AppIcons.idCard,
    },
    {
      "type": "Passaporte",
      "icon": AppIcons.passport,
    },
    {
      "type": "Carta de Condução ",
      "icon": AppIcons.licensePlate,
    },
  ];

  int selectedDocType = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * .92,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
              const Spacer(),
              Text(
                "Escolher o documento",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
            ],
          ),
          Text(
            "Escolha o documento de verificação",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          Column(
            children: docs
                .map((doc) => InkWell(
                      onTap: () {
                        int index = docs.indexOf(doc);
                        setState(() {
                          if (selectedDocType != index) {
                            selectedDocType = index;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: selectedDocType == docs.indexOf(doc)
                                  ? 1.2
                                  : 1,
                              color: Colors.black45,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(
                                doc["icon"]!,
                              ),
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(doc["type"]!),
                            const Spacer(),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    width: selectedDocType == docs.indexOf(doc)
                                        ? 3
                                        : 1,
                                    color: const Color(0xFF5A5A5A),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
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
                    return const CaptureDocument();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Continuar",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
