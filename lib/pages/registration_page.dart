import 'package:catataja/components/catataja_button.dart';
import 'package:catataja/components/catataja_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  final void Function()? onPressed;

  const RegistrationPage({super.key, required this.onPressed});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // is visible
  bool passwordIsVisisble = true;
  bool confirmPasswordIsVisisble = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // title
                Text(
                  "Daftar Akun",
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 20),

                // name textfield
                CatatAjaTextFormField(
                  controller: nameController,
                  hintText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline),
                  obsecureText: false,
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // email textfield
                CatatAjaTextFormField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  obsecureText: false,
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // password textfield
                CatatAjaTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordIsVisisble = !passwordIsVisisble;
                      });
                    },
                    icon: Icon(passwordIsVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: passwordIsVisisble,
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // password textfield
                CatatAjaTextFormField(
                  controller: confirmPasswordController,
                  hintText: 'Konfirmasi password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmPasswordIsVisisble = !confirmPasswordIsVisisble;
                      });
                    },
                    icon: Icon(confirmPasswordIsVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: confirmPasswordIsVisisble,
                  maxLines: 1,
                ),

                const SizedBox(height: 20),

                // sign in button
                CatatAjaButton(
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.primary,
                  text: "Daftar",
                ),

                const SizedBox(height: 5),

                // Already have an account? sign in now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: Text(
                        "Masuk sekarang!",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
