import 'dart:convert';
import 'package:catataja/components/catataja_button.dart';
import 'package:catataja/components/catataja_textformfield.dart';
import 'package:catataja/pages/home_page.dart';
import 'package:catataja/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // text editing controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  // is visible
  bool currentPasswordIsVisisble = true;
  bool newPasswordIsVisisble = true;
  bool confirmNewPasswordIsVisisble = true;

  // is pressed
  bool changePasswordIsPressed = false;

  // account
  String accountName = "";
  String accountEmail = "";

  // API endpoint url
  final String currentUserUrl = "http://10.0.2.2:8000/api/users/current";
  final String logoutUrl = "http://10.0.2.2:8000/api/users/logout";

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(currentUserUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": widget.token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          accountName = data["data"]["name"];
          accountEmail = data["data"]["email"];
          nameController.text = data["data"]["name"];
        });
      } else {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Gagal Memuat Data",
            text: "Terjadi kesalahan saat mengambil data pengguna.",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: "Tidak dapat terhubung ke server.",
          confirmBtnColor: Theme.of(context).colorScheme.primary,
        );
      }
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text == accountName) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: "Tidak Ada Perubahan",
        text: "Nama Anda tidak berubah, tidak perlu menyimpan.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );

      return;
    }

    if (nameController.text.length < 3) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Gagal Mengubah Profil",
        text: "Nama minimal harus terdiri dari 3 karakter.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse(currentUserUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": widget.token,
        },
        body: jsonEncode({
          "name": nameController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Berhasil Mengubah Profil",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      } else {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Gagal Mengubah Profil",
            text: "Gagal memperbarui profil. Coba lagi.",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: "Tidak dapat terhubung ke server.",
          confirmBtnColor: Theme.of(context).colorScheme.primary,
        );
      }
    }
  }

  Future<void> updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Gagal Mengubah Password",
        text:
            "Password saat ini, password baru dan konfirmasi password baru harus diisi.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    if (newPasswordController.text.length < 6) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Gagal Mengubah Password",
        text: "Password baru minimal harus terdiri dari 6 karakter.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Gagal Mengubah Password",
        text: "Password baru dan konfirmasi password baru tidak sama.",
        confirmBtnColor: Theme.of(context).colorScheme.primary,
      );

      newPasswordController.clear();
      confirmNewPasswordController.clear();

      return;
    }

    try {
      final response = await http.patch(
        Uri.parse(currentUserUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": widget.token,
        },
        body: jsonEncode({
          "current_password": currentPasswordController.text,
          "new_password": newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final logoutResponse = await http.delete(
          Uri.parse(logoutUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": widget.token,
          },
        );

        if (logoutResponse.statusCode == 200) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: "Berhasil Mengubah Password",
              text: "Password berhasil diubah, silakan masuk kembali.",
              confirmBtnColor: Theme.of(context).colorScheme.primary,
            );
          }
        } else {
          if (mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "Gagal Logout",
              text: "Tidak dapat logout secara otomatis, silakan coba lagi.",
              confirmBtnColor: Theme.of(context).colorScheme.primary,
            );
          }
        }
      } else {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Gagal Mengubah Password",
            text: "Password saat ini salah.",
            confirmBtnColor: Theme.of(context).colorScheme.primary,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: "Tidak dapat terhubung ke server.",
          confirmBtnColor: Theme.of(context).colorScheme.primary,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token)),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Profil', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // photo, name & email
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: changePasswordIsPressed
                      ? const EdgeInsets.only(bottom: 150)
                      : const EdgeInsets.only(bottom: 135),
                  child: Container(
                    height: changePasswordIsPressed
                        ? MediaQuery.sizeOf(context).height / 6
                        : MediaQuery.sizeOf(context).height / 3.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),

                // photo
                Positioned(
                  top: changePasswordIsPressed
                      ? MediaQuery.sizeOf(context).height / 11
                      : MediaQuery.sizeOf(context).height / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      border: Border.all(
                        width: 6,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: Icon(
                        Icons.person, // Menampilkan ikon orang
                        size: 65,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                // name & email
                Positioned(
                  top: changePasswordIsPressed
                      ? MediaQuery.sizeOf(context).height / 3.9
                      : MediaQuery.sizeOf(context).height / 2.75,
                  child: Column(
                    children: [
                      // name
                      Text(
                        accountName.isNotEmpty ? accountName : "Loading...",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),

                      // email
                      Text(
                        accountEmail.isNotEmpty ? accountEmail : "Loading...",
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // change profile and change password
            Container(
              height: changePasswordIsPressed
                  ? MediaQuery.sizeOf(context).height / 1.82
                  : MediaQuery.sizeOf(context).height / 2.23,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Center(
                      child: Text(
                        changePasswordIsPressed
                            ? 'Ubah Password'
                            : 'Ubah Profil',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // name or current password
                    CatatAjaTextFormField(
                      controller: changePasswordIsPressed
                          ? currentPasswordController
                          : nameController,
                      inputFormatters: changePasswordIsPressed
                          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                          : null,
                      hintText: changePasswordIsPressed
                          ? "Password saat ini"
                          : "Nama",
                      prefixIcon: changePasswordIsPressed
                          ? const Icon(Icons.password_outlined)
                          : const Icon(Icons.person_outline),
                      suffixIcon: changePasswordIsPressed
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  currentPasswordIsVisisble =
                                      !currentPasswordIsVisisble;
                                });
                              },
                              icon: Icon(currentPasswordIsVisisble
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )
                          : null,
                      obsecureText: changePasswordIsPressed
                          ? currentPasswordIsVisisble
                          : false,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20),

                    // email or new password
                    CatatAjaTextFormField(
                      controller: changePasswordIsPressed
                          ? newPasswordController
                          : TextEditingController(text: accountEmail),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      hintText:
                          changePasswordIsPressed ? "Password baru" : "Email",
                      prefixIcon: changePasswordIsPressed
                          ? const Icon(Icons.password_outlined)
                          : const Icon(Icons.email_outlined),
                      suffixIcon: changePasswordIsPressed
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  newPasswordIsVisisble =
                                      !newPasswordIsVisisble;
                                });
                              },
                              icon: Icon(newPasswordIsVisisble
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )
                          : null,
                      obsecureText: changePasswordIsPressed
                          ? newPasswordIsVisisble
                          : false,
                      readOnly: changePasswordIsPressed ? false : true,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20),

                    // confirm password
                    if (changePasswordIsPressed)
                      CatatAjaTextFormField(
                        controller: confirmNewPasswordController,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s'))
                        ],
                        hintText: 'Konfirmasi password baru',
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              confirmNewPasswordIsVisisble =
                                  !confirmNewPasswordIsVisisble;
                            });
                          },
                          icon: Icon(confirmNewPasswordIsVisisble
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        obsecureText: confirmNewPasswordIsVisisble,
                        maxLines: 1,
                      )
                    else
                      const SizedBox(),

                    changePasswordIsPressed
                        ? const SizedBox(height: 20)
                        : const SizedBox(),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          nameController.text = accountName;
                        });

                        // delete text in controller
                        currentPasswordController.clear();
                        newPasswordController.clear();
                        confirmNewPasswordController.clear();

                        setState(() {
                          changePasswordIsPressed = !changePasswordIsPressed;
                        });
                      },
                      child: Text(
                        changePasswordIsPressed
                            ? 'Ubah Profil'
                            : 'Ubah Password',
                        style: GoogleFonts.poppins(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // button
                    Row(
                      children: [
                        // cancle button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.35,
                          child: CatatAjaButton(
                            onPressed: () {
                              setState(() {
                                nameController.text = accountName;
                              });

                              // delete text in controller
                              currentPasswordController.clear();
                              newPasswordController.clear();
                              confirmNewPasswordController.clear();
                            },
                            color: Theme.of(context).colorScheme.primary,
                            text: 'Batal',
                          ),
                        ),

                        const Spacer(),

                        // save button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.35,
                          child: CatatAjaButton(
                            onPressed: () {
                              changePasswordIsPressed
                                  ? updatePassword()
                                  : updateProfile();
                              changePasswordIsPressed ? null : fetchUserData();
                            },
                            color: Theme.of(context).colorScheme.primary,
                            text: 'Simpan',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
