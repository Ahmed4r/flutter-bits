import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterbits/line_waves.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff040D21),
      drawer: isMobile ? _buildDrawer() : null,
      body: LineWaves(
        color1: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
        color2: const Color.fromARGB(255, 7, 5, 129).withOpacity(0.2),
        color3: const Color.fromARGB(255, 197, 189, 189).withOpacity(0.1),
        child: SelectionArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildNavBar(isMobile),
                _buildHeroSection(isMobile),
                _buildStatsSection(isMobile),
                _buildFeaturesGrid(isMobile),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xff040D21),
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                "FlutterBits",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          _drawerItem("Components"),
          _drawerItem("Docs"),
          _drawerItem("Showcase"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildPrimaryButton("GitHub", small: false, fullWidth: true),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildNavBar(bool isMobile) {
    return ClipRect(
      // FIX: Prevents the blur from spilling over into the rest of the body canvas
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          width: MediaQuery.sizeOf(context).width / 1.5,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical:
                20, // Slightly compressed padding for professional balance
          ),
          decoration: BoxDecoration(
            // Subtle tint container layer allowing background shader elements to bleed through
            color: const Color(0xff040D21).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
          ),
          child: Row(
            children: [
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              const Text(
                "FlutterBits",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (!isMobile) ...[
                _navItem("Components"),
                const SizedBox(width: 32),
                _navItem("Docs"),
                const SizedBox(width: 32),
                _navItem("Showcase"),
                const SizedBox(width: 32),
              ],
              _buildPrimaryButton("GitHub", small: true),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _navItem(String title) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 60 : 120,
      ),
      child: Column(
        children: [
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    241,
                    241,
                    241,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "New",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Shaders Added",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 48),
          ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xff999999)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  "Beautifully crafted\nFlutter components",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 42 : 88,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: isMobile ? -1 : -4,
                    color: Colors.white,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 800.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 32),
          SizedBox(
                width: isMobile ? double.infinity : 700,
                child: Text(
                  "An open-source collection of animated, interactive, and highly customizable components built with Flutter. Ready to copy and paste.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    color: Colors.white.withOpacity(0.5),
                    height: 1.5,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 800.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 56),
          Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPrimaryButton("Browse Components"),
                  if (isMobile)
                    const SizedBox(height: 16)
                  else
                    const SizedBox(width: 16),
                  _buildSecondaryButton("Documentation"),
                ],
              )
              .animate()
              .fadeIn(delay: 600.ms, duration: 800.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),

      child: isMobile
          ? Column(
              children: [
                _statItem("2", "Components"),
                const SizedBox(height: 32),
                _statItem("1", "GitHub Stars"),
                const SizedBox(height: 32),
                _statItem("Free", "Forever"),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statItem("2", "Components"),
                _divider(),
                _statItem("1", "GitHub Stars"),
                _divider(),
                _statItem("Free", "Forever"),
              ],
            ),
    ).animate().fadeIn(delay: 1.seconds);
  }

  Widget _divider() => Container(
    height: 40,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 40),
    color: Colors.white.withOpacity(0.1),
  );

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(bool isMobile) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1);

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular bits",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: isMobile ? 1.5 : 1.3,
            children: [
              _componentCard(
                "Aurora Background",
                "Fluid, interactive shader-based background.",
                Icons.waves,
              ),
              _componentCard(
                "Text Reveal",
                "Staggered text animations for landing pages.",
                Icons.text_fields,
              ),
              _componentCard(
                "Glass Cards",
                "Frosted glass effects with dynamic blurs.",
                Icons.style,
              ),
              _componentCard(
                "Dock Menu",
                "MacOS-inspired interactive dock component.",
                Icons.menu,
              ),
              _componentCard(
                "Spotlight Effect",
                "Hover-driven light effects for your UI.",
                Icons.light_mode,
              ),
              _componentCard(
                "Marquee",
                "Smooth infinite scrolling text or images.",
                Icons.loop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _componentCard(String title, String desc, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              size: 28,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(
    String text, {
    bool small = false,
    bool fullWidth = false,
  }) {
    Widget button = Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(
        horizontal: small ? 20 : 32,
        vertical: small ? 10 : 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!small)
            BoxShadow(
              color: const Color(0xff027DFD).withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: small ? 13 : 16,
        ),
      ),
    );

    return MouseRegion(cursor: SystemMouseCursors.click, child: button);
  }

  Widget _buildSecondaryButton(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Divider(color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 40),
          Text(
            "FlutterBits © 2024. Inspired by ReactBits.",
            style: TextStyle(
              color: const Color.fromARGB(255, 252, 252, 252),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
