// 📁 lib/feautures/view/screens/home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/models/user_model.dart';
import 'package:quron_app/feautures/view/screens/audio_screen.dart';
import 'package:quron_app/feautures/view/screens/book_mark_screen.dart';
import 'package:quron_app/feautures/view/screens/login_screen.dart';
import 'package:quron_app/feautures/view/screens/shared_preferences.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/feautures/view/screens/surah_screen.dart';
import 'package:quron_app/feautures/view_model/auth_provider.dart'
    show AuthProvider;
import 'package:quron_app/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String path = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textController;
  final _advancedDrawerController = AdvancedDrawerController();
  List<String> category = ["Surah", "Para", "Surah Yasin", "Ait Al-cursi"];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    textController = TextEditingController(text: user?.photoUrl);
    Future.microtask(() => context.read<AuthProvider>().loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context); // Ensure ScreenUtil is initialized
    final user = context.watch<AuthProvider>().user;
    return AdvancedDrawer(
      backdrop: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF112093).withAlpha(230),
              const Color(0xff0B205E).withAlpha(230),
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      drawer: const MenuWidget(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context, user),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF112093).withAlpha(230),
                    const Color(0xff0B205E).withAlpha(230),
                  ],
                ),
              ),
            ),
            Positioned(left: 30.w, top: 30.h, child: _blurCircle()),
            Positioned(right: 40.w, top: 300.h, child: _blurCircle()),
            Positioned(
              left: 0,
              right: 0,
              height: 300.h,
              child: Assets.images.homeBook.image(),
            ),
            const AnimatedStarsLayer(),
            Positioned(
              bottom: 0.h,
              left: 0.w,
              right: 0.w,
              child: Assets.images.splashBottom.svg(
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.w),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 120.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookmarkScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20.r,
                              spreadRadius: 4.r,
                              color: Color.fromARGB(165, 98, 203, 255),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 134, 215, 255),
                              Color.fromARGB(62, 100, 210, 250),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "بسم الله الرحمن الرحيم",
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "📖 Your Saved",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Consumer<SurahBookmarkProvider>(
                              builder: (context, provider, child) {
                                return FutureBuilder<
                                  Map<int, Map<String, dynamic>>
                                >(
                                  future: provider.getBookmarkedSurahs(),
                                  builder: (context, snapshot) {
                                    final count = snapshot.hasData
                                        ? snapshot.data!.length
                                        : 0;
                                    return Row(
                                      children: [
                                        Text(
                                          "Surahs count: $count",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.bookmark,
                                          color: Colors.white,
                                          size: 40.sp,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: GridView.builder(
                        itemCount: 4,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30.h,
                          crossAxisSpacing: 30.w,
                          mainAxisExtent: 145.h,
                        ),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahScreen(page: 1),
                                ),
                              );
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahAudioScreen(
                                    surahNumber: 36,
                                    surahName: 'Ya-Sin',
                                    surahEnglishName: 'Ya-Sin',
                                  ),
                                ),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahAudioScreen(
                                    surahNumber: 2,
                                    surahName: 'Ayatul Kursi',
                                    surahEnglishName: 'Ayatul Kursi',
                                    startAyah: 255,
                                    endAyah: 255,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SurahScreen(),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  top: 0,
                                  bottom: -80.h,
                                  left: -30.w,
                                  child: Assets.images.homeBook.image(
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(255, 152, 221, 255),
                                        Color.fromARGB(150, 110, 216, 255),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(
                                          255,
                                          125,
                                          230,
                                          248,
                                        ).withOpacity(0.2),
                                        blurRadius: 15.r,
                                        offset: Offset(0, 8.h),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "سورة",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      category[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 1.h,
                                  left: 2.w,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      minimumSize: Size(0, 0),
                                      backgroundColor: Color(0xFF0C2165),
                                      foregroundColor: Color(0xFF8590B2),
                                    ),
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserModel? user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      excludeHeaderSemantics: true,
      leading: IconButton(
        onPressed: _advancedDrawerController.showDrawer,
        icon: ShowMenu(advancedDrawerController: _advancedDrawerController),
      ),
      actions: [
        InkWell(
          onTap: () => showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: const Text('Change Profile Image:'),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Enter Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    final newUrl = textController.text.trim();
                    if (newUrl.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .update({'photoURL': newUrl});
                      context.read<AuthProvider>().loadUserData();
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 3.w, top: 3.h),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.cyanAccent,
              child: CircleAvatar(
                maxRadius: 20.r,
                foregroundImage: NetworkImage(
                  user?.photoUrl ??
                      'https://png.pngtree.com/png-vector/20231019/ourmid/pngtree-user-profile-avatar-png-image_10211467.png',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _blurCircle() {
    return CircleAvatar(
      radius: 2.5.r,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 100.r,
              color: Color.fromARGB(255, 105, 138, 254),
              spreadRadius: 100.r,
            ),
          ],
        ),
      ),
    );
  }
}

class ShowMenu extends StatelessWidget {
  const ShowMenu({super.key, required this.advancedDrawerController});
  final AdvancedDrawerController advancedDrawerController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AdvancedDrawerValue>(
      valueListenable: advancedDrawerController,
      builder: (_, value, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Icon(
            color: Colors.cyanAccent,
            value.visible ? Icons.clear : Icons.menu,
            key: ValueKey<bool>(value.visible),
          ),
        );
      },
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      textColor: Colors.grey.shade400,
      iconColor: Colors.grey.shade400,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 40.h),
          Assets.images.homeBook.image(height: 100.h),
          const Text(
            "Quran Kareem",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            "With Multiple Translation",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w100,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10.h),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Sign In/Profile'),
          ),
          const ListTile(
            leading: Icon(Icons.star_half),
            title: Text('Rate Us'),
          ),
          const ListTile(
            leading: Icon(Icons.menu_book_outlined),
            title: Text('Contact Us'),
          ),
          const ListTile(leading: Icon(Icons.help), title: Text('About Us')),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              context.go(LogInScreen.path);
            },
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
          ),
          const Spacer(),
          const DefaultTextStyle(
            style: TextStyle(fontSize: 12, color: Colors.white54),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Terms of Service | Privacy Policy'),
            ),
          ),
        ],
      ),
    );
  }
}
