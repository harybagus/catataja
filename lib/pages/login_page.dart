import 'dart:convert';
import 'package:catataja/pages/home_page.dart';
import 'package:http/http.dart' as http;

import 'package:catataja/components/catataja_button.dart';
import 'package:catataja/components/catataja_logo.dart';
import 'package:catataja/components/catataja_textformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onPressed;

  const LoginPage({super.key, this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // is visible
  bool isVisisble = true;

  // login API endpoint url
  final String loginUrl = "http://10.0.2.2:8000/api/users/login";

  Future<void> loginUser() async {
    // input validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Login Gagal",
        text: "Email dan password harus diisi.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    // email validation
    if (!EmailValidator.validate(emailController.text)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Login Gagal",
        text: "Email tidak valid.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    // password validaiton
    if (passwordController.text.length < 6) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Login Gagal",
        text: "Password minimal harus terdiri dari 6 karakter.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // login successful
        final data = jsonDecode(response.body);

        if (mounted) {
          // move to home page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: data["data"]["token"])),
          );

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Login Berhasil",
            text: "Selamat datang, ${data["data"]["name"]}!",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      } else if (response.statusCode == 401) {
        // incorrect password or email
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Login Gagal",
            text: "Email atau password salah.",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      } else {
        // other errors
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Login Gagal",
            text: "Login gagal: ${response.reasonPhrase}",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      }
    } catch (e) {
      // connection error or other
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: "Terjadi kesalahan: $e",
          confirmBtnColor: Theme.of(context).colorScheme.primary,
        );
      }
    }
  }

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
                // logo
                const CatatAjaLogo(fontSize: 60),

                const SizedBox(height: 20),

                // email textfield
                CatatAjaTextFormField(
                  controller: emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // password textfield
                CatatAjaTextFormField(
                  controller: passwordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisisble = !isVisisble;
                      });
                    },
                    icon: Icon(isVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: isVisisble,
                  maxLines: 1,
                ),

                const SizedBox(height: 20),

                // sign in button
                CatatAjaButton(
                  onPressed: loginUser,
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Masuk',
                ),

                const SizedBox(height: 5),

                // Don't have an account yet? sign up now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: Text(
                        "Daftar sekarang!",
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
