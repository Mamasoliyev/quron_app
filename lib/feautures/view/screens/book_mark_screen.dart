import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/models/audio_model.dart';
import 'package:quron_app/feautures/view/screens/audio_screen.dart';
import 'package:quron_app/feautures/view/screens/shared_preferences.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/gen/assets.gen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SurahBookmarkProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Saved Surahs',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.cyanAccent,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 26, 43, 171).withOpacity(0.95),
                  const Color(0xff0B205E).withOpacity(0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
              width: 1.sw,
              height: 120.h,
            ),
          ),
          Positioned(
            left: 0.w,
            right: 0.w,
            height: 300.h,
            child: Image.asset(
              Assets.images.homeBook.path,
              width: 1.sw,
              height: 300.h,
              fit: BoxFit.cover,
            ),
          ),
          Consumer<SurahBookmarkProvider>(
            builder: (context, provider, _) {
              return FutureBuilder<Map<int, Map<String, dynamic>>>(
                future: provider.getBookmarkedSurahs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final bookmarked = snapshot.data!;
                  if (bookmarked.isEmpty) {
                    return Center(
                      child: Text(
                        'No saved surahs',
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      top: 180.h,
                      left: 15.w,
                      right: 15.w,
                    ),
                    itemCount: bookmarked.length,
                    itemBuilder: (context, index) {
                      final surahNumber = bookmarked.keys.elementAt(index);
                      final surahDetails = bookmarked[surahNumber]!;
                      final surahName = surahDetails['surahName'] ?? '';
                      final surahEnglishName =
                          surahDetails['surahEnglishName'] ?? '';
                      final ayahs = surahDetails['ayahs'] as List<AudioModel>;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(170, 1, 28, 76),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SurahAudioScreen(
                                    surahNumber: surahNumber,
                                    surahEnglishName: surahEnglishName,
                                    surahName: surahName,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              "$surahName ($surahEnglishName) - $surahNumber",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                            subtitle: Text(
                              "${ayahs.length} saved ayahs",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () async {
                                await provider.removeSurahAyahs(surahNumber);
                              },
                              child: Icon(
                                Icons.bookmark,
                                color: Colors.cyanAccent,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
