
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/widgets/custom_button.dart';
import 'package:nopin_creative/core/shared/widgets/custom_input.dart';
import 'package:nopin_creative/features/authentication/presentation/views/sign_up.dart';
import 'package:nopin_creative/features/authentication/presentation/widgets/o_auth.dart';
import 'package:nopin_creative/features/home/presentation/views/offers.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomInput(
                  controller: _emailController,
                  iconUri: AppIcons.email,
                  label: "Email",
                  placeholder: "Enter your name",
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomInput(
                  controller: _emailController,
                  iconUri: AppIcons.lock,
                  label: "Password",
                  placeholder: "Enter your name",
                ),
              ),
              const SizedBox(height: 40,),
              Row(children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const OffersView()));
                        },
                        backgroundColor: const Color(0XFF333333),
                        text: 'Sign Up',
                      )),
                )
              ]),
              const OAuth(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16 * 2),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? " ,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.general
                        ),
                      ),
                      Text(
                        "Sign up" ,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black, decoration: TextDecoration.underline),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
