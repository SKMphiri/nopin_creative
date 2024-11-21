import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController pageController;

  bool lastSlide = false;
  int active = 0;
  @override
  void initState() {
    super.initState();
    lastSlide = (0 == OnboardingContent.data.length - 1); // Assuming `D.Onboarding.data` contains the slides

    pageController = PageController(initialPage: 0);
    pageController.addListener((){
      int page = pageController.page?.round() ?? 0;
      if(page != active){
        setState(() {
          active  = page;
          lastSlide = (page == OnboardingContent.data.length - 1); // Assuming `D.Onboarding.data` contains the slides
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 600,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: PageView(
                  controller: pageController,
                  children: OnboardingContent.data
                      .map(
                        (e) => OnboardingWidget(
                      data: e,
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: OnboardingContent.data.map((e) {
                final isActive = OnboardingContent.data.indexOf(e) == active;
                return AnimatedContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  duration: const Duration(milliseconds: 300),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(16 * 2),
                    color: isActive ?  Colors.black : const Color(0XFFE2E8F0),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 2.5 * 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if(lastSlide){
                          //
                          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const SignUp()));
                        }else{
                          pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 55),
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        // lastSlide ? "Get Started" : "Next",
                        "Comece agora",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({super.key, required this.data});

  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2 * 16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5 * 16),
              child: Image(
                image: AssetImage(data["image"]!),
                fit: BoxFit.contain, // Use BoxFit to control image scaling
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4 * 16),
              child: Text(
                data["title"]!,
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 3 * 16, right: 3 * 16, top: 14),
              child: Text(
                data["description"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0XFF858585), fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
