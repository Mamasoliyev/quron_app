// 📁 lib/feautures/view/screens/home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/view/screens/login_screen.dart';
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
  final List<String> category = [
    "Surah",
    "Para",
    "Surah Yasin",
    "Ait Al-cursi",
  ];
  late TextEditingController textController;

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    textController = TextEditingController(text: user?.photoUrl);
    Future.microtask(() => context.read<AuthProvider>().loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    textController = TextEditingController(text: user?.photoUrl);

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
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: const MenuWidget(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                    controller: textController, // Foydalanuvchi yozadigan joy
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

                          // Local AuthProvider ni yangilash
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
                padding: EdgeInsets.only(right: 12.w),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.cyanAccent,
                  child: CircleAvatar(
                    maxRadius: 15.r,
                    foregroundImage: NetworkImage(
                      user?.photoUrl ??
                          'https://png.pngtree.com/png-vector/20231019/ourmid/pngtree-user-profile-avatar-png-image_10211467.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background Gradient
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
            Padding(
              padding: EdgeInsets.all(15.w),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 120.h),
                    _topContainer(),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: GridView.builder(
                        itemCount: category.length,
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 30.h,
                          crossAxisSpacing: 30.w,
                          mainAxisExtent: 145.h,
                        ),
                        itemBuilder: (context, index) {
                          return _buildCard(category[index]);
                        },
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

  Widget _blurCircle() {
    return CircleAvatar(
      radius: 2.5.r,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 100,
              color: Color.fromARGB(255, 105, 138, 254),
              spreadRadius: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 4,
            color: const Color.fromARGB(165, 98, 203, 255),
          ),
        ],
        borderRadius: BorderRadius.circular(15.r),
        gradient: const LinearGradient(
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
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "📖 Your Saved",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            "Saved Surahs Page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 152, 221, 255),
            Color.fromARGB(150, 110, 216, 255),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 125, 230, 248).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: -80.h,
            left: -30.w,
            child: Assets.images.homeBook.image(fit: BoxFit.cover),
          ),
          Center(
            child: Column(
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
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 1.h,
            left: 2.w,
            child: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
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
