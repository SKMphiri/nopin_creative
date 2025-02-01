import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/features/profile/presentation/views/verify_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const VerifyProfile()));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verifiy Profile",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage(AppIcons.warningTwo),
                width: 16,
                height: 16,
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: const Color(0XFF949AA8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        const BoxShadow(
                            offset: Offset(0, 10),
                            color: Colors.black12,
                            blurRadius: 14,
                            spreadRadius: 10),
                        BoxShadow(
                            offset: const Offset(0, 0),
                            color: AppColors.primary.withAlpha(100),
                            spreadRadius: 6),
                        const BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.white,
                            spreadRadius: 3),
                      ]),
                  alignment: Alignment.center,
                  child: const Text(
                    "D",
                    style: TextStyle(color: Colors.white, fontSize: 64),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                        color: Color(0XFFF4F4F4),
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                            BorderSide(width: 2, color: Colors.white))),
                    child: const Icon(
                      Icons.edit,
                      size: 14,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Dhalitso",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              "Entrou em 4 julho de 2020",
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0XFFB1B1B1)),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "16",
                      style: GoogleFonts.poppins(
                          color: const Color(0XFF333333),
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: " Propriedades no nopin",
                      style: GoogleFonts.poppins(
                          color: const Color(0XFF949494),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                      color: Colors.black12,
                      blurRadius: 4),
                  BoxShadow(
                    offset: Offset.zero,
                    spreadRadius: 0.5,
                    color: const Color(0XFF333333).withAlpha(100),
                  )
                ],
              ),
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Créditos",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0XFF555555),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        const Image(
                          image: AssetImage(AppIcons.coinOne),
                          width: 38,
                          height: 38,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "525",
                                  style: GoogleFonts.poppins(
                                      color: const Color(0XFF333333),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              TextSpan(
                                text: " nopins",
                                style: GoogleFonts.poppins(
                                    color: const Color(0XFF949494),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            elevation: 2,
                            // maximumSize: const Size(155, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  width: 0.8, color: Colors.black26),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Image(
                                image: AssetImage(AppIcons.mpesa),
                                width: 29,
                                height: 24,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Recarregar",
                                style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: const Color(0xFF333333),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        width: 0.8, color: Colors.black26))),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Image(
                                  image: AssetImage(AppIcons.emola),
                                  width: 29,
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Recarregar",
                                  style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: const Color(0xFF333333),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ), //credits contains,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: const Border.fromBorderSide(
                            BorderSide(width: 1, color: Colors.black26)),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black12,
                              blurRadius: 4)
                        ]),
                    height: 75,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 25,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Publicar propriedade",
                          style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        const Image(
                          image: AssetImage(AppImages.house),
                          width: 52,
                        )
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Distintivos",
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "12",
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF701AA7),
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "/42",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFA6A6A6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ])),
                  const Spacer(),
                  Text(
                    "Ver todos",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const Icon(Icons.chevron_right_outlined)
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: const Border.fromBorderSide(
                    BorderSide(width: 1, color: Colors.black26)),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 2),
                      color: Colors.black12,
                      blurRadius: 4)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const  Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.hexagon),
                            width: 60,
                          ),
                          Image(
                            image: AssetImage(AppImages.registered),
                            width: 34,
                          ),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("Registrei-me", style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF701AA7), fontWeight: FontWeight.w500),)
                    ],
                  ),
                  Column(
                    children: [
                      const  Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.hexagon),
                            width: 60,
                          ),
                          Image(
                            image: AssetImage(AppImages.goal),
                            width: 30,
                          ),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("Registrei-me", style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF701AA7), fontWeight: FontWeight.w500),)
                    ],
                  ),
                  Column(
                    children: [
                      const  Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage(AppImages.hexagon),
                            width: 60,
                          ),
                          Image(
                            image: AssetImage(AppImages.quality),
                            width: 34,
                          ),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text("Registrei-me", style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF701AA7), fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
