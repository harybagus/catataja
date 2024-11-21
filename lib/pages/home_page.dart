import 'dart:convert';
import 'package:catataja/components/catataja_drawer_navigation.dart';
import 'package:catataja/components/catataja_logo.dart';
import 'package:catataja/components/catataja_note_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _notesFuture;

  final String getNotesUrl = "http://10.0.2.2:8000/api/notes";

  Future<Map<String, dynamic>> fetchNotes() async {
    final response = await http.get(
      Uri.parse(getNotesUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": widget.token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load notes");
    }
  }

  @override
  void initState() {
    super.initState();
    _notesFuture = fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const CatatAjaLogo(fontSize: 35),
      ),
      drawer: CatatAjaDrawerNavigation(token: widget.token),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Anda belum memiliki catatan.\nAyo buat catatan pertama Anda!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final notes = snapshot.data!;
            final pinnedNotes = notes["pinned"] as List;
            final unpinnedNotes = notes["unpinned"] as List;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  if (pinnedNotes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.push_pin),
                          const SizedBox(width: 8),
                          Text(
                            "Dipasangi pin",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (pinnedNotes.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: pinnedNotes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: CatatAjaNoteCard(
                            note: pinnedNotes[index],
                            onPin: () {},
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        );
                      },
                    ),
                  if (unpinnedNotes.isNotEmpty && pinnedNotes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Lainnya",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (unpinnedNotes.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: unpinnedNotes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: CatatAjaNoteCard(
                            note: unpinnedNotes[index],
                            onPin: () {},
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "Tidak ada data yang tersedia",
                style: GoogleFonts.poppins(),
              ),
            );
          }
        },
      ),
    );
  }
}
