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

    return Scaffold(
      body: PageView(
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
    return Placeholder(color: cs.primary.withOpacity(0.3), strokeWidth: 2);
  }
}

class _LikesPage extends StatelessWidget {
  const _LikesPage();

  @override
  Widget build(BuildContext context) {
    return Placeholder(color: Colors.pink.withOpacity(0.3), strokeWidth: 2);
  }
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();

  @override
  Widget build(BuildContext context) {
    return Placeholder(color: Colors.orange.withOpacity(0.3), strokeWidth: 2);
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Placeholder(color: Colors.teal.withOpacity(0.3), strokeWidth: 2);
  }
}
