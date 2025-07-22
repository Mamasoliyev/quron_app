import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/models/surah_model.dart';
import 'package:quron_app/feautures/view/screens/audio_screen.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/feautures/view_model/Quran_provider.dart';
import 'package:quron_app/gen/assets.gen.dart';

class SurahSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Surani qidiring...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 38, 56, 168),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<QuranProvider>(context, listen: false);
    final List<SurahData> results = provider.surahList.where((surah) {
      final lower = query.toLowerCase();
      return surah.englishName?.toLowerCase().contains(lower) == true ||
          surah.name?.toLowerCase().contains(lower) == true ||
          surah.englishNameTranslation?.toLowerCase().contains(lower) == true;
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            Container(
              width: 1.sw,
              height: 1.sh,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 38, 56, 168), Color(0xFF0E2875)],
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
              child: SizedBox(
                height: 50.h,
                width: 1.sw,
                child: Assets.images.splashBottom.svg(
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                Assets.images.splashBottom.path,
                fit: BoxFit.cover,
                width: 1.sw,
                height: 1.sh,
              ),
            ),
            if (results.isEmpty)
              Center(
                child: Text(
                  'Hech narsa topilmadi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final surah = results[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: ListTile(
                        onTap: () {
                          close(context, null);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurahAudioScreen(
                                surahNumber: surah.number!,
                                surahName: surah.englishName,
                                surahEnglishName: surah.englishNameTranslation,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: Colors.cyanAccent,
                          child: Text(
                            surah.number.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        title: Text(
                          surah.englishName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Text(
                          surah.englishNameTranslation ?? '',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        trailing: Text(
                          surah.name ?? '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
