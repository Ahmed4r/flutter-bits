import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ⚠️ ضروري لاستدعاء Clipboard
import 'package:google_fonts/google_fonts.dart';

class GlassCodeUI extends StatelessWidget {
  const GlassCodeUI({super.key});

  // النص البرمجي الكامل المخزن لعملية النسخ الفورية
  static const String codeSnippet = '''
class GlassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: 24,
        color: Colors.white10,
      ),
      child: Center(
        child: Text(
          'Glass UI'
        ),
      ),
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.32,
          height: MediaQuery.sizeOf(context).height * 0.48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            color: Colors.white.withOpacity(0.03),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // تفريق الدوائر عن زر النسخ
                  children: [
                    Row(
                      children: [
                        buildDot(),
                        const SizedBox(width: 8),
                        buildDot(),
                        const SizedBox(width: 8),
                        buildDot(),
                      ],
                    ),
                    // 📑 زر نسخ الكود المضاف
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        color: Colors.white.withOpacity(0.4),
                        size: 18,
                      ),
                      hoverColor: Colors.white.withOpacity(0.05),
                      splashRadius: 20,
                      tooltip: 'Copy Code',
                      onPressed: () async {
                        // أمر النسخ إلى حافظة النظام المباشر
                        await Clipboard.setData(
                          const ClipboardData(text: codeSnippet),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Code copied to clipboard!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                248,
                                248,
                                248,
                              ),
                              behavior: SnackBarBehavior.floating,
                              width: 250,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.white.withOpacity(0.08), height: 1),

              // Code
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.googleSansCode(
                          fontSize: 11.9,
                          height: 1.9,
                          color: Colors.white,
                        ),
                        children: [
                          span("class ", Colors.pinkAccent),
                          span("GlassCard", Colors.orangeAccent),
                          span(" extends ", Colors.pinkAccent),
                          span("StatelessWidget", Colors.cyanAccent),
                          span(" {\n", Colors.white),
                          span("  @override\n", Colors.orangeAccent),
                          span("  Widget ", Colors.cyanAccent),
                          span("build", Colors.orangeAccent),
                          span("(BuildContext context) {\n", Colors.white),
                          span("    return ", Colors.pinkAccent),
                          span("Container(\n", Colors.white),
                          codeLine("      width: ", "320"),
                          codeLine("      height: ", "200"),
                          span("      decoration: ", Colors.orangeAccent),
                          span("BoxDecoration(\n", Colors.white),
                          codeLine("        borderRadius: ", "24"),
                          codeLine("        color: ", "Colors.white10"),
                          span("      ),\n", Colors.white),
                          span("      child: ", Colors.orangeAccent),
                          span("Center(\n", Colors.white),
                          span("        child: ", Colors.orangeAccent),
                          span("Text(\n", Colors.white),
                          codeLine("          ", "'Glass UI'"),
                          span("        ),\n", Colors.white),
                          span("      ),\n", Colors.white),
                          span("    );\n", Colors.white),
                          span("  }\n", Colors.white),
                          span("}", Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static TextSpan span(String text, Color color) {
    return TextSpan(
      text: text,
      style: TextStyle(color: color),
    );
  }

  static TextSpan codeLine(String left, String value) {
    return TextSpan(
      children: [
        span(left, Colors.white),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.08),
            ),
            child: Text(
              value,
              style: GoogleFonts.googleSansCode(
                color: Colors.cyanAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const TextSpan(text: "\n"),
      ],
    );
  }

  Widget buildDot() {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.12),
      ),
    );
  }
}
