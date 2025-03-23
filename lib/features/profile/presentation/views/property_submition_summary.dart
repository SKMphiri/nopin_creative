import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';
import 'package:nopin_creative/core/constants/colors.dart';

class PropertySubmitionSummary extends StatefulWidget {
  const PropertySubmitionSummary({super.key});

  @override
  State<PropertySubmitionSummary> createState() =>
      _PropertySubmitionSummaryState();
}

class _PropertySubmitionSummaryState extends State<PropertySubmitionSummary> {
  final ButtonStyle selectedButtonStyle = TextButton.styleFrom(
    backgroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(width: 1, color: Color(0xFFA6A6A6)),
    ),
  );

  final ButtonStyle unselectedButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(width: 1, color: Color(0xFFA6A6A6)),
    ),
  );

  String selectedCredit = "3";

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final useCompactLayout = screenWidth < 360; // For very narrow screens

    return Container(
      width: double.infinity,
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with drag handle
          Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: useCompactLayout ? 12 : 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        "Resumo de Publicação",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize:
                              isTablet ? 20 : (useCompactLayout ? 16 : 18),
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Property Images - make responsive
          SizedBox(
            height: useCompactLayout ? 80 : 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding:
                  EdgeInsets.symmetric(horizontal: useCompactLayout ? 12 : 20),
              itemBuilder: (context, index) {
                final imageSize = useCompactLayout ? 80.0 : 100.0;
                return Container(
                  width: imageSize,
                  height: imageSize,
                  margin: EdgeInsets.only(right: useCompactLayout ? 8 : 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/beach_house_${index + 1}.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Property Summary
          Expanded(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: useCompactLayout ? 12 : 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      "Informações da Propriedade", useCompactLayout),
                  SizedBox(height: useCompactLayout ? 12 : 16),
                  _buildSummaryCard([
                    _buildSummaryItem("Título", "Casa com 3 quartos em Matola",
                        useCompactLayout),
                    _buildSummaryItem("Localização",
                        "Avenida Julius Nyerere, Maputo", useCompactLayout),
                    _buildSummaryItem(
                        "Preço", "5,000,000 MT", useCompactLayout),
                    _buildSummaryItem("Categoria", "A Venda", useCompactLayout),
                  ]),
                  SizedBox(height: useCompactLayout ? 20 : 24),
                  _buildSectionTitle("Características", useCompactLayout),
                  SizedBox(height: useCompactLayout ? 12 : 16),
                  _buildSummaryCard([
                    _buildSummaryItem("Quartos", "3", useCompactLayout),
                    _buildSummaryItem("Banheiros", "2", useCompactLayout),
                    _buildSummaryItem(
                        "Estacionamento", "Sim", useCompactLayout),
                    _buildSummaryItem(
                        "Contacto", "+258 84 123 4567", useCompactLayout),
                  ]),
                  SizedBox(height: useCompactLayout ? 20 : 24),
                  _buildSectionTitle("Descrição", useCompactLayout),
                  SizedBox(height: useCompactLayout ? 12 : 16),
                  _buildDescriptionCard(
                    "Casa espaçosa com 3 quartos, localizada na Matola, próxima de escolas e comércio. Possui jardim amplo e é segura para famílias.",
                    useCompactLayout,
                  ),
                  SizedBox(height: useCompactLayout ? 20 : 24),
                  _buildSectionTitle("Visibilidade", useCompactLayout),
                  SizedBox(height: useCompactLayout ? 12 : 16),
                  _buildCreditOptions(useCompactLayout),
                  const SizedBox(height: 16),
                  _buildCreditSummary(useCompactLayout),
                  SizedBox(height: useCompactLayout ? 24 : 32),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                useCompactLayout ? 12 : 20,
                16,
                useCompactLayout ? 12 : 20,
                16 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Handle property submission
                Navigator.pop(context);
                Navigator.pop(context); // Pop both modals

                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Propriedade publicada com sucesso!',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.fromLTRB(useCompactLayout ? 12 : 16, 0,
                        useCompactLayout ? 12 : 16, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, useCompactLayout ? 48 : 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Text(
                "Publicar Propriedade",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: useCompactLayout ? 14 : 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool useCompactLayout) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: useCompactLayout ? 14 : 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSummaryCard(List<Widget> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildDescriptionCard(String description, bool useCompactLayout) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: useCompactLayout ? 12 : 14,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, bool useCompactLayout) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: useCompactLayout ? 6 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: useCompactLayout ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: useCompactLayout ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditOptions(bool useCompactLayout) {
    // For narrow screens, use a more compact layout
    if (useCompactLayout) {
      return Column(
        children: [
          _buildCreditOptionCompact("3", "Normal", "3 dias"),
          const SizedBox(height: 8),
          _buildCreditOptionCompact("5", "Destacado", "7 dias"),
          const SizedBox(height: 8),
          _buildCreditOptionCompact("10", "Premium", "30 dias"),
        ],
      );
    }

    // For wider screens, use the row layout
    return Row(
      children: [
        _buildCreditOption("3", "Normal", "3 dias"),
        const SizedBox(width: 10),
        _buildCreditOption("5", "Destacado", "7 dias"),
        const SizedBox(width: 10),
        _buildCreditOption("10", "Premium", "30 dias"),
      ],
    );
  }

  Widget _buildCreditOptionCompact(
      String credits, String title, String duration) {
    final isSelected = selectedCredit == credits;

    return GestureDetector(
      onTap: () => setState(() => selectedCredit = credits),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.grey.shade200,
              ),
              child: Icon(
                isSelected ? Icons.check : null,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        "$credits créditos",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color:
                              isSelected ? AppColors.primary : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        duration,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
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

  Widget _buildCreditOption(String credits, String title, String duration) {
    final isSelected = selectedCredit == credits;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedCredit = credits),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.grey.shade200,
                ),
                child: Icon(
                  isSelected ? Icons.check : null,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$credits créditos",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditSummary(bool useCompactLayout) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle_fill,
                color: AppColors.primary,
                size: useCompactLayout ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Resumo",
                style: GoogleFonts.poppins(
                  fontSize: useCompactLayout ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: useCompactLayout ? 10 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Créditos disponíveis:",
                  style: GoogleFonts.poppins(
                    fontSize: useCompactLayout ? 12 : 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "15",
                style: GoogleFonts.poppins(
                  fontSize: useCompactLayout ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: useCompactLayout ? 6 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Créditos necessários:",
                  style: GoogleFonts.poppins(
                    fontSize: useCompactLayout ? 12 : 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                selectedCredit,
                style: GoogleFonts.poppins(
                  fontSize: useCompactLayout ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: useCompactLayout ? 10 : 12),
            child: const DottedLine(
              dashColor: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Saldo após publicação:",
                  style: GoogleFonts.poppins(
                    fontSize: useCompactLayout ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                (15 - int.parse(selectedCredit)).toString(),
                style: GoogleFonts.poppins(
                  fontSize: useCompactLayout ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
