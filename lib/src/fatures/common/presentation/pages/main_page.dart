import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageCtrl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final languageCode = Localizations.localeOf(context).languageCode;

    final bgGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        cs.surfaceContainerHighest.withOpacity(0.0),
        cs.primaryContainer.withOpacity(0.08),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        backgroundColor: Colors.transparent,
        title: Text(
          t.home,
          style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: PageView(
          controller: _pageCtrl,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (i) => setState(() => _index = i),
          children: const [
            _HomePage(),
            _LikesPage(),
            _SearchPage(),
            _ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _index,
        onTap: (i) {
          final difference = (i - _index).abs();
          if (difference > 1) {
            _pageCtrl.jumpToPage(i);
            return setState(() => _index = i);
          }
          setState(() => _index = i);
          _pageCtrl.animateToPage(
            i,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        },
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: Text(
              t.home,
              style: TextStyle(
                fontFamily: AppTheme.getFontFamily(languageCode),
              ),
            ),
            selectedColor: cs.primary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_rounded),
            title: Text(
              t.likes,
              style: TextStyle(
                fontFamily: AppTheme.getFontFamily(languageCode),
              ),
            ),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search_rounded),
            title: Text(
              t.search,
              style: TextStyle(
                fontFamily: AppTheme.getFontFamily(languageCode),
              ),
            ),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_rounded),
            title: Text(
              t.profile,
              style: TextStyle(
                fontFamily: AppTheme.getFontFamily(languageCode),
              ),
            ),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _WelcomeCard(
          title: 'Welcome 👋',
          subtitle: 'Browse curated lessons and continue where you left off.',
          icon: Icons.play_circle_fill_rounded,
          tint: cs.primary,
        ),
      ),
    );
  }
}

class _LikesPage extends StatelessWidget {
  const _LikesPage();

  @override
  Widget build(BuildContext context) {
    return const _CenteredText('Your liked lessons will appear here.');
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return const _CenteredText(
      'Search across courses, instructors, and topics.',
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const _CenteredText('Manage your profile, downloads, and settings.');
  }
}

class _CenteredText extends StatelessWidget {
  final String text;
  const _CenteredText(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;

  const _WelcomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 28, color: tint),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
