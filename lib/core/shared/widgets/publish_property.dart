import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/features/profile/presentation/views/property_submition_summary.dart';

class PublishProperty extends StatefulWidget {
  const PublishProperty({super.key});

  @override
  State<PublishProperty> createState() => _PublishPropertyState();
}

class _PublishPropertyState extends State<PublishProperty> {
  final _formKey = GlobalKey<FormState>();
  final images = const [AppImages.beachHouse2, AppImages.beachHouse3];
  String? selectedCategory = "Terreno";
  String? selectedParking = "Sim";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    _priceController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final accentColor = AppColors.primary;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final useCompactLayout = screenWidth < 360; // For very narrow screens

    return Container(
      width: double.infinity,
      height: screenHeight * 0.94,
      padding: EdgeInsets.all(useCompactLayout ? 12 : 16),
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
          // Header with drag handle
          Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title and close button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      "Publicar Propriedade",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 20 : (useCompactLayout ? 16 : 18),
                        color: accentColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
          // Scrollable Content
          SizedBox(
            height: screenHeight * 0.84 - bottomPadding,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildImageSection(useCompactLayout),
                    _buildRequiredTextField(
                      title: "Título",
                      keyboardType: TextInputType.text,
                      controller: _titleController,
                      hintText: "Ex: Casa com 3 quartos em Matola",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira um título";
                        }
                        return null;
                      },
                    ),
                    _buildRequiredTextField(
                      title: "Endereço",
                      keyboardType: TextInputType.streetAddress,
                      controller: _addressController,
                      hintText: "Ex: Avenida Julius Nyerere, Maputo",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira um endereço";
                        }
                        return null;
                      },
                    ),
                    _buildCategorySection(),
                    selectedCategory == "Terreno"
                        ? _buildLandSection(useCompactLayout)
                        : _buildNumberInputSection(useCompactLayout),
                    _buildPriceSection(),
                    _buildContactSection(),
                    _buildDescriptionSection(),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(bool useCompactLayout) {
    return PublishPropertySection(
      title: "Adicionar fotos",
      isRequired: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            // Calculate appropriate image height
            final imageSize = useCompactLayout
                ? 100.0
                : constraints.maxWidth < 400
                    ? 110.0
                    : 120.0;

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: imageSize,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage(images[index]),
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    // Remove image functionality would be implemented here
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: imageSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          // Image selection functionality would be implemented here
                        },
                        child: Column(
                          children: [
                            const Spacer(flex: 3),
                            Icon(
                              CupertinoIcons.camera_fill,
                              size: useCompactLayout ? 22 : 28,
                              color: AppColors.primary,
                            ),
                            const Spacer(flex: 2),
                            Text(
                              "Adicionar",
                              style: GoogleFonts.poppins(
                                fontSize: useCompactLayout ? 10 : 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(flex: 3),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
          const SizedBox(height: 6),
          Text(
            "Adicione pelo menos 3 fotos da propriedade",
            style: GoogleFonts.poppins(
              fontSize: useCompactLayout ? 10 : 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredTextField({
    required String title,
    required TextInputType keyboardType,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return PublishPropertySection(
      title: title,
      isRequired: true,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.red.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return PublishPropertySection(
      title: "Categoria",
      isRequired: true,
      child: Row(
        children: [
          _buildCategoryButton("Terreno", "Terreno"),
          const SizedBox(width: 10),
          _buildCategoryButton("Arrendar", "Arrendar"),
          const SizedBox(width: 10),
          _buildCategoryButton("A Venda", "A Venda"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, String value) {
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() => selectedCategory = value),
        style: selectedCategory == value
            ? selectedButtonStyle
            : unselectedButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: selectedCategory == value ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandSection(bool useCompactLayout) {
    return LayoutBuilder(builder: (context, constraints) {
      // For very narrow screens, stack the inputs vertically
      if (constraints.maxWidth < 320) {
        return Column(
          children: [
            PublishPropertySection(
              title: "Largura (M)",
              isRequired: true,
              child: _buildNumberInput(_widthController),
            ),
            PublishPropertySection(
              title: "Comprimento (M)",
              isRequired: true,
              child: _buildNumberInput(_lengthController),
            ),
          ],
        );
      }

      // Otherwise use the row layout
      return Row(
        children: [
          Expanded(
            child: PublishPropertySection(
              title: "Largura (M)",
              isRequired: true,
              child: _buildNumberInput(_widthController),
            ),
          ),
          SizedBox(width: useCompactLayout ? 8 : 16),
          Expanded(
            child: PublishPropertySection(
              title: "Comprimento (M)",
              isRequired: true,
              child: _buildNumberInput(_lengthController),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNumberInputSection(bool useCompactLayout) {
    return LayoutBuilder(builder: (context, constraints) {
      // For very narrow screens, stack vertically
      if (constraints.maxWidth < 320) {
        return Column(
          children: [
            PublishPropertySection(
              title: "Quartos",
              isRequired: true,
              child: _buildNumberInput(_roomsController,
                  textAlign: TextAlign.center),
            ),
            PublishPropertySection(
              title: "Banheiros",
              isRequired: true,
              child: _buildNumberInput(_bathroomsController,
                  textAlign: TextAlign.center),
            ),
            PublishPropertySection(
              title: "Estacionamento",
              isRequired: false,
              child: _buildParkingButtons(),
            ),
          ],
        );
      }

      // For medium screens, use two rows
      if (constraints.maxWidth < 420) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PublishPropertySection(
                    title: "Quartos",
                    isRequired: true,
                    child: _buildNumberInput(_roomsController,
                        textAlign: TextAlign.center),
                  ),
                ),
                SizedBox(width: useCompactLayout ? 8 : 16),
                Expanded(
                  child: PublishPropertySection(
                    title: "Banheiros",
                    isRequired: true,
                    child: _buildNumberInput(_bathroomsController,
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
            PublishPropertySection(
              title: "Estacionamento",
              isRequired: false,
              child: _buildParkingButtons(),
            ),
          ],
        );
      }

      // For larger screens, use the full row layout
      return Row(
        children: [
          Expanded(
            child: PublishPropertySection(
              title: "Quartos",
              isRequired: true,
              child: _buildNumberInput(_roomsController,
                  textAlign: TextAlign.center),
            ),
          ),
          SizedBox(width: useCompactLayout ? 8 : 16),
          Expanded(
            child: PublishPropertySection(
              title: "Banheiros",
              isRequired: true,
              child: _buildNumberInput(_bathroomsController,
                  textAlign: TextAlign.center),
            ),
          ),
          SizedBox(width: useCompactLayout ? 8 : 16),
          Expanded(
            child: PublishPropertySection(
              title: "Estacionamento",
              isRequired: false,
              child: _buildParkingButtons(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNumberInput(TextEditingController controller,
      {TextAlign textAlign = TextAlign.start}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: textAlign,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Obrigatório";
        }
        if (double.tryParse(value) == null) {
          return "Número inválido";
        }
        return null;
      },
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildParkingButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => selectedParking = "Sim"),
            style: _parkingButtonStyle("Sim"),
            child: Text(
              "Sim",
              style: GoogleFonts.poppins(
                color: selectedParking == "Sim" ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => setState(() => selectedParking = "Não"),
            style: _parkingButtonStyle("Não"),
            child: Text(
              "Não",
              style: GoogleFonts.poppins(
                color: selectedParking == "Não" ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ButtonStyle _parkingButtonStyle(String value) {
    return TextButton.styleFrom(
      backgroundColor:
          selectedParking == value ? AppColors.primary : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.grey.shade300),
        borderRadius: value == "Sim"
            ? const BorderRadius.horizontal(left: Radius.circular(10))
            : const BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      minimumSize: const Size(0, 48),
    );
  }

  Widget _buildPriceSection() {
    return PublishPropertySection(
      title: "Preço",
      isRequired: true,
      child: TextFormField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, insira um preço";
          }
          if (double.tryParse(value) == null) {
            return "Valor inválido";
          }
          return null;
        },
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          suffixText: "MT",
          suffixStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return PublishPropertySection(
      title: "Contactos",
      isRequired: true,
      child: TextFormField(
        controller: _contactController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, insira um número de telefone";
          }
          if (value.length < 9) {
            return "Número de telefone inválido";
          }
          return null;
        },
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "+258 ",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return PublishPropertySection(
      title: "Descrição",
      isRequired: true,
      child: TextFormField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        minLines: 4,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, adicione uma descrição";
          }
          if (value.length < 20) {
            return "A descrição deve ter pelo menos 20 caracteres";
          }
          return null;
        },
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          hintText: "Descreva a propriedade em detalhes...",
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: ElevatedButton(
        onPressed: () {
          // Validate the form
          if (_formKey.currentState!.validate()) {
            // If validation passes, show the property submission summary
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
                return const PropertySubmitionSummary();
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
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
    );
  }
}

class PublishPropertySection extends StatelessWidget {
  const PublishPropertySection({
    super.key,
    required this.title,
    required this.child,
    this.isRequired = false,
  });

  final String title;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                Text(
                  "*",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
