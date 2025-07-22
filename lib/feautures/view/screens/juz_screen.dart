import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quron_app/feautures/view/screens/surah_screen.dart';

class JuzScreen extends StatelessWidget {
  const JuzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pora ro'yxati")),
      body: ParaBuilder(),
    );
  }
}

class ParaBuilder extends StatelessWidget {
  const ParaBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ParaBuild();
  }
}

class ParaBuild extends StatelessWidget {
  const ParaBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(thickness: 0.3.h, height: 5.h),
          ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final juzNumber = index + 1;
        final start = juzSurahRanges[index]['start']!;
        final end = juzSurahRanges[index]['end']!;

        return ListTile(
          leading: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF65D6FC), width: 2.w),
            ),
            child: Center(
              child: Text(
                juzNumber.toString(),
                style: TextStyle(
                  color: Color(0xFF65D6FC),
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                ),
              ),
            ),
          ),
          title: Text(
            "- pora",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF65D6FC),
            ),
          ),
          subtitle: Text(
            "Sura: $start → $end",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 20.sp),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurahScreen(from: start, to: end),
              ),
            );
          },
        );
      },
    );
  }
}

final List<Map<String, int>> juzSurahRanges = [
  {"start": 1, "end": 2},
  {"start": 2, "end": 2},
  {"start": 2, "end": 3},
  {"start": 3, "end": 4},
  {"start": 4, "end": 4},
  {"start": 4, "end": 5},
  {"start": 5, "end": 6},
  {"start": 6, "end": 7},
  {"start": 7, "end": 8},
  {"start": 8, "end": 9},
  {"start": 9, "end": 10},
  {"start": 10, "end": 11},
  {"start": 11, "end": 12},
  {"start": 12, "end": 15},
  {"start": 15, "end": 17},
  {"start": 17, "end": 18},
  {"start": 18, "end": 20},
  {"start": 20, "end": 22},
  {"start": 22, "end": 23},
  {"start": 23, "end": 25},
  {"start": 25, "end": 27},
  {"start": 27, "end": 29},
  {"start": 29, "end": 33},
  {"start": 33, "end": 36},
  {"start": 36, "end": 39},
  {"start": 39, "end": 41},
  {"start": 41, "end": 45},
  {"start": 45, "end": 51},
  {"start": 51, "end": 58},
  {"start": 58, "end": 114},
];
