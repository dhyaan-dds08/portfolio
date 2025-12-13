import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadmeDialog extends StatelessWidget {
  final String mdFilePath;

  const ReadmeDialog({super.key, required this.mdFilePath});

  static void show(BuildContext context, String mdFilePath) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => ReadmeDialog(mdFilePath: mdFilePath),
        transitionsBuilder: (context, animation, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // Close on background tap
      child: Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping panel
            child: Container(
              width: 500, // Panel width
              height: double.infinity,
              color: Color(0xFF1E1E1E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Color(0xFF4EC9B0),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'README.md',

                              style: GoogleFonts.courierPrime(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),

                  // Markdown Content
                  Expanded(
                    child: FutureBuilder<String>(
                      future: rootBundle.loadString(mdFilePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF00FF00),
                                  strokeWidth: 2,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading documentation...',
                                  style: GoogleFonts.courierPrime(
                                    fontSize: 12,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Error loading README',
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    snapshot.error.toString(),
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'File path: $mdFilePath',
                                    style: GoogleFonts.courierPrime(
                                      fontSize: 11,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Markdown(
                          data: snapshot.data!,
                          padding: EdgeInsets.all(24),
                          styleSheet: MarkdownStyleSheet(
                            // Headings
                            h1: GoogleFonts.courierPrime(
                              fontSize: 24,
                              color: Color(0xFF4EC9B0),
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                            h2: GoogleFonts.courierPrime(
                              fontSize: 18,
                              color: Color(0xFF4EC9B0),
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                            h3: GoogleFonts.courierPrime(
                              fontSize: 16,
                              color: Color(0xFF4EC9B0),
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),

                            // Paragraphs
                            p: GoogleFonts.courierPrime(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.6,
                            ),

                            // Lists
                            listBullet: GoogleFonts.courierPrime(
                              fontSize: 13,
                              color: Colors.white,
                            ),

                            // Code
                            code: GoogleFonts.courierPrime(
                              fontSize: 12,
                              color: Colors.cyan,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            codeblockPadding: EdgeInsets.all(12),

                            // Links
                            a: GoogleFonts.courierPrime(
                              fontSize: 13,
                              color: Color(0xFF569CD6),
                              decoration: TextDecoration.underline,
                            ),

                            // Blockquotes
                            blockquote: GoogleFonts.courierPrime(
                              fontSize: 13,
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                            blockquoteDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFF4EC9B0),
                                  width: 4,
                                ),
                              ),
                            ),

                            // Horizontal rule
                            horizontalRuleDecoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                            ),

                            // Tables
                            tableHead: GoogleFonts.courierPrime(
                              fontSize: 13,
                              color: Color(0xFF4EC9B0),
                              fontWeight: FontWeight.bold,
                            ),
                            tableBody: GoogleFonts.courierPrime(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
