import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatAjaNoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function onPin;
  final Function onEdit;
  final Function onDelete;

  const CatatAjaNoteCard({
    Key? key,
    required this.note,
    required this.onPin,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note["title"],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Options Menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "pin") {
                      onPin();
                    } else if (value == "edit") {
                      onEdit();
                    } else if (value == "delete") {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "pin",
                      child: Text(
                        note["pinned"] == "true" ? "Lepaskan pin" : "Pin",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    PopupMenuItem(
                      value: "edit",
                      child: Text(
                        "Edit",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Text(
                        "Hapus",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                note["description"],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
