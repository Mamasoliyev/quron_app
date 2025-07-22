import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/view/screens/audio_screen.dart';
import 'package:quron_app/feautures/view/screens/juz_screen.dart';
import 'package:quron_app/feautures/view/screens/search_screen.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/feautures/view_model/Quran_provider.dart';
import 'package:quron_app/feautures/view_model/auth_provider.dart';
import 'package:quron_app/gen/assets.gen.dart';

class SurahScreen extends StatefulWidget {
  final int? from;
  final int? to;
  final int page;

  const SurahScreen({super.key, this.from, this.to, this.page = 0});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List<String> bolim = ["Surah", "Para"];
  int selectedIndex = 0;
  late PageController pageController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuranProvider>(context, listen: false);
    provider.getSurahs();

    if (widget.page == 1) {
      selectedIndex = widget.page;
    }
    pageController = PageController(initialPage: selectedIndex);
    final user = context.read<AuthProvider>().user;
    textController = TextEditingController(text: user?.photoUrl);
    Future.microtask(() => context.read<AuthProvider>().loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 134, 215, 255),
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
      ),
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
                  Color.fromARGB(255, 20, 38, 158).withAlpha(230),
                  Color.fromARGB(255, 14, 40, 117).withAlpha(230),
                ],
              ),
            ),
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
          ..._buildBackgroundEffects(),
          Positioned(
            left: 0,
            right: 0,
            height: 330.h,
            child: Image.asset(Assets.images.homeBook.path),
          ),
          Column(
            children: [
              _buildSearchAndTabs(),
              Expanded(
                child: Consumer<QuranProvider>(
                  builder: (context, quranprovider, child) {
                    if (quranprovider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (quranprovider.error.isNotEmpty) {
                      return Center(child: Text(quranprovider.error));
                    }

                    final visibleSurahs =
                        (widget.from != null && widget.to != null)
                        ? quranprovider.surahList
                              .where(
                                (surah) =>
                                    (surah.number ?? 0) >= widget.from! &&
                                    (surah.number ?? 0) <= widget.to!,
                              )
                              .toList()
                        : quranprovider.surahList;

                    return PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      children: [_buildSurahList(visibleSurahs), ParaBuild()],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundEffects() {
    return [
      Positioned(left: 30.w, top: 30.h, child: _buildCircleShadow(100.r)),
      Positioned(right: 40.w, bottom: 100.h, child: _buildCircleShadow(120.r)),
      Positioned(left: 0.w, bottom: 400.h, child: _buildCircleShadow(150.r)),
    ];
  }

  Widget _buildCircleShadow(double blur) {
    return Container(
      width: 5.w,
      height: 5.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: blur,
            color: Color.fromARGB(255, 105, 135, 254),
            spreadRadius: 100.r,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(height: 220.h),
          InkWell(
            onTap: () =>
                showSearch(context: context, delegate: SurahSearchDelegate()),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Color.fromARGB(130, 117, 149, 235),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.cyan),
              ),
              child: Row(
                children: [
                  Text(
                    'Search Here',
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 16.sp),
                  ),
                  Spacer(),
                  Icon(Icons.search, color: Colors.grey.shade300, size: 22.sp),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(2, (index) {
              return Text(
                bolim[index],
                style: TextStyle(
                  color: selectedIndex == index
                      ? Color(0xFF65D6FC)
                      : Colors.grey.shade400,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
          ),
          Row(
            children: List.generate(2, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Divider(
                    thickness: 3.h,
                    color: selectedIndex == index
                        ? Colors.cyan
                        : const Color.fromARGB(57, 189, 189, 189),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList(List surahList) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        return Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahAudioScreen(
                      surahNumber: surah.number ?? 1,
                      surahName: surah.name ?? "not name",
                      surahEnglishName: surah.englishName ?? "not name",
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 18.r,
                child: Text(
                  surah.number.toString(),
                  style: TextStyle(color: Color(0xFF65D6FC), fontSize: 16.sp),
                ),
              ),
              title: Text(
                surah.englishName ?? "not surah",
                style: TextStyle(
                  color: Color(0xFF65D6FC),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "MECCAN = ${surah.numberOfAyahs} VERSES",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11.sp),
              ),
              trailing: Text(
                '${surah.name?.split(" ")[1]}',
                style: TextStyle(
                  color: Color(0xFF65D6FC),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Divider(thickness: 0.3.h, height: 0),
            ),
          ],
        );
      },
    );
  }
}
