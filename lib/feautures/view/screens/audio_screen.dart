import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/models/audio_model.dart';
import 'package:quron_app/feautures/services/audio_service.dart';
import 'package:quron_app/feautures/view/screens/shared_preferences.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/feautures/view_model/audio_provider%20copy.dart';
import 'package:quron_app/feautures/view_model/auth_provider.dart';
import 'package:quron_app/gen/assets.gen.dart';

class SurahAudioScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;

  final int? startAyah;
  final int? endAyah;
  final List<AudioModel>? customAyahs;

  const SurahAudioScreen({
    super.key,
    required this.surahName,
    required this.surahNumber,
    required this.surahEnglishName,
    this.startAyah,
    this.endAyah,
    this.customAyahs,
  });

  @override
  State<SurahAudioScreen> createState() => _SurahAudioScreenState();
}

class _SurahAudioScreenState extends State<SurahAudioScreen> {
  final advancedRawerController = AdvancedDrawerController();
  late Future<List<AudioModel>> _futureAyahs;
  final player = AudioPlayer();
  late TextEditingController textController;

  bool isSaved = false;

  Future<void> checkIfSaved() async {
    final saved = await context.read<SurahBookmarkProvider>().isSurahBookmarked(
      widget.surahNumber,
    );
    setState(() {
      isSaved = saved;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureAyahs = AudioService().fetchSurah(widget.surahNumber);
    checkIfSaved();
    final user = context.read<AuthProvider>().user;
    textController = TextEditingController(text: user?.photoUrl);
    Future.microtask(() => context.read<AuthProvider>().loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final audioProvider = Provider.of<AudioProvider>(context);

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
            Color.fromARGB(255, 20, 38, 158).withOpacity(0.9),
            Color.fromARGB(255, 14, 40, 117).withOpacity(0.9),
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
        Positioned(
        left: 30.w,
        top: 30.h,
        child: Container(
          width: 5.w,
          height: 5.h,
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
        ),
        Positioned(
        right: 40.w,
        bottom: 100.h,
        child: Container(
          width: 5.w,
          height: 5.h,
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
            blurRadius: 120.r,
            color: Color.fromARGB(255, 105, 135, 254),
            spreadRadius: 100.r,
            ),
          ],
          ),
        ),
        ),
        Positioned(
        left: 0.w,
        bottom: 400.h,
        child: Container(
          width: 5.w,
          height: 5.h,
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
            blurRadius: 150.r,
            color: Color.fromARGB(255, 105, 135, 254),
            spreadRadius: 100.r,
            ),
          ],
          ),
        ),
        ),
        SafeArea(
        child: FutureBuilder<List<AudioModel>>(
          future: _futureAyahs,
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Xatolik: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Ma'lumot topilmadi"));
          }

          final ayahs = snapshot.data!;

          return Column(
            children: [
            Padding(
              padding: EdgeInsets.all(25.w),
              child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                boxShadow: [
                BoxShadow(
                  blurRadius: 10.r,
                  spreadRadius: 1.r,
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
              child: Stack(
                children: [
                Positioned(
                  left: 0.w,
                  top: -10.h,
                  bottom: -10.h,
                  child: Image.asset(
                  Assets.images.homeBook.path,
                  fit: BoxFit.cover,
                  width: 150.w,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  SizedBox(height: 15.h),
                  Text(
                    widget.surahName,
                    style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.surahEnglishName ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Surah ${widget.surahNumber}",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Text(
                      "Meccan ${ayahs.length.toString()} Verses",
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      ),
                    ),
                    ],
                  ),
                  ],
                ),
                ],
              ),
              ),
            ),
            Expanded(
              child: Builder(
              builder: (context) {
                final filteredAyahs =
                  (widget.startAyah != null &&
                    widget.endAyah != null)
                    ? ayahs
                      .where(
                        (a) =>
                          a.number >= widget.startAyah! &&
                          a.number <= widget.endAyah!,
                      )
                      .toList()
                    : ayahs;

                return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: filteredAyahs.length,
                separatorBuilder: (_, __) => Padding(
                  padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  ),
                  child: Divider(
                  color: Colors.grey,
                  indent: 0.1.w,
                  ),
                ),
                itemBuilder: (context, index) {
                  final ayah = filteredAyahs[index];
                  final isPlaying =
                    audioProvider.currentAyah?.number ==
                      ayah.number &&
                    audioProvider.isPlaying;

                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Color.fromARGB(179, 10, 31, 96),
                    ),
                    child: Row(
                      children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                          183,
                          24,
                          255,
                          255,
                        ),
                        ),
                        child: Center(
                        child: Text(
                          ayah.number.toString(),
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          ),
                        ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        iconSize: 25.sp,
                        ),
                        icon: Icon(
                        Icons.share_outlined,
                        color: Colors.cyanAccent.shade400,
                        size: 25.sp,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        iconSize: 30.sp,
                        ),
                        icon: Icon(
                        isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_outlined,
                        color: Colors.cyanAccent.shade400,
                        size: 30.sp,
                        ),
                        onPressed: () {
                        audioProvider.playAyah(ayah);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                        isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                        color: Colors.cyanAccent.shade400,
                        size: 28.sp,
                        ),
                        onPressed: () async {
                        if (isSaved) {
                          await context
                            .read<
                            SurahBookmarkProvider
                            >()
                            .removeSurahAyahs(
                            widget.surahNumber,
                            );
                        } else {
                          final allAyahs =
                            await _futureAyahs;
                          await context
                            .read<
                            SurahBookmarkProvider
                            >()
                            .saveSurahAyahs(
                            widget.surahNumber,
                            widget.surahName,
                            widget.surahEnglishName,
                            allAyahs,
                            );
                        }

                        setState(() {
                          isSaved = !isSaved;
                        });
                        },
                      ),
                      ],
                    ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                    ayah.arabicText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                    ayah.englishText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                    ),
                    Divider(
                    color: Colors.grey.shade600,
                    thickness: 0.5.h,
                    ),
                    Text(
                    ayah.uzbekText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                    ),
                  ],
                  );
                },
                );
              },
              ),
            ),
            ],
          );
          },
        ),
        ),
      ],
      ),
    );
  }
}
