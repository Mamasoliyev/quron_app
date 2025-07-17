import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/feautures/view_model/auth_provider.dart';
import 'package:quron_app/gen/assets.gen.dart';
import 'package:quron_app/gen/fonts.gen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String path = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _saveInfo = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _signUp() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _confirmController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ro'yxatdan o'tish muvaffaqiyatli!")),
      );
      context.push('/log_in');
    } else {
      final message = authProvider.errorMessage ?? "Xatolik yuz berdi";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _googleSignUp() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.googleSignIn();

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final message =
          authProvider.errorMessage ??
          "Google bilan kirishda xatolik yuz berdi";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF010E36), Color(0xFF081243)],
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 40.w,
                    height: 2.h,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  _buildInput(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  _buildInput(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: _obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    obscure: _obscurePassword,
                    toggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  _buildInput(
                    controller: _confirmController,
                    hint: 'Confirm Password',
                    icon: _obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off,
                    obscure: _obscureConfirm,
                    toggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: _saveInfo,
                        onChanged: (v) => setState(() => _saveInfo = v),
                        activeColor: Colors.cyanAccent,
                      ),
                      Text(
                        "Save my info?",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  buildSignUp(isLoading),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white54)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white54)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _socialButton(
                    label: "Continue With Phone",
                    svg: Assets.images.signUpPhone.svg(),
                  ),
                  SizedBox(height: 10.h),
                  _socialButton(
                    label: "Continue With Google",
                    svg: Assets.images.googleLogo.svg(),
                    onTap: isLoading ? null : _googleSignUp,
                  ),
                  SizedBox(height: 10.h),
                  _socialButton(
                    label: "Continue With Facebook",
                    svg: Assets.images.facebookLogo.svg(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/log_in'),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildSignUp(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        minimumSize: Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.comfortaa,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          suffixIcon: toggle != null
              ? IconButton(
                  onPressed: toggle,
                  icon: Icon(icon, color: Colors.white70),
                )
              : Icon(icon, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required SvgPicture svg,
    VoidCallback? onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: svg,
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        minimumSize: Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:quron_app/feautures/view/screens/star_painter.dart';
// import 'package:quron_app/gen/assets.gen.dart';
// import 'package:quron_app/gen/fonts.gen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//   static String path = '/sign_up';

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   bool _saveInfo = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirm = true;

//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();

//   void _signUp() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final confirmPassword = _confirmController.text.trim();

//     if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Iltimos, barcha maydonlarni to‘ldiring")),
//       );
//       return;
//     }

//     if (password != confirmPassword) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Parollar mos emas")));
//       return;
//     }

//     try {
//       final userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       final userId = userCredential.user?.uid;
//       if (userId != null) {
//         final userDoc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(userId)
//             .get();
//         if (!userDoc.exists) {
//           await FirebaseFirestore.instance.collection("users").doc(userId).set({
//             "email": email,
//             "createdAt": FieldValue.serverTimestamp(),
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Ro'yxatdan o'tish muvaffaqiyatli!")),
//           );
//         }
//       }
//       context.push('/log_in');
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Bu email ro'yxatdan o'tgan, log in qiling"),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? "Xatolik yuz berdi")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }

//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return; // foydalanuvchi bekor qildi

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Firebase Authentication orqali tizimga kirish
//       final userCredential = await FirebaseAuth.instance.signInWithCredential(
//         credential,
//       );
//       final user = userCredential.user;

//       if (user != null) {
//         final userDoc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .get();

//         if (!userDoc.exists) {
//           // Foydalanuvchi ilk marta kirdi, ma’lumotlarini yozamiz
//           await FirebaseFirestore.instance
//               .collection("users")
//               .doc(user.uid)
//               .set({
//                 "uid": user.uid,
//                 "email": user.email,
//                 "displayName": user.displayName,
//                 "photoURL": user.photoURL,
//                 "createdAt": FieldValue.serverTimestamp(),
//               });
//         }
//       }

//       if (!context.mounted) return;
//       context.go('/home'); // Kirgandan keyin asosiy sahifaga
//     } catch (e) {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google bilan kirishda xatolik: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF010E36), Color(0xFF081243)],
//           ),
//         ),
//         child: Stack(
//           children: [
//             const AnimatedStarsLayer(),

//             Positioned(
//               bottom: 0.h,
//               left: 0.w,
//               right: 0.w,
//               child: Assets.images.splashBottom.svg(
//                 fit: BoxFit.cover,
//                 colorFilter: const ColorFilter.mode(
//                   Colors.black,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 100.h),
//                     Text(
//                       "Sign Up",
//                       style: TextStyle(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       width: 40.w,
//                       height: 2.h,
//                       color: Colors.white,
//                       margin: EdgeInsets.symmetric(vertical: 12.h),
//                     ),
//                     _buildInput(
//                       controller: _emailController,
//                       hint: 'Email',
//                       icon: Icons.email_outlined,
//                     ),
//                     _buildInput(
//                       controller: _passwordController,
//                       hint: 'Password',
//                       icon: _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       obscure: _obscurePassword,
//                       toggle: () =>
//                           setState(() => _obscurePassword = !_obscurePassword),
//                     ),
//                     _buildInput(
//                       controller: _confirmController,
//                       hint: 'Confirm Password',
//                       icon: _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,

//                       obscure: _obscureConfirm,
//                       toggle: () =>
//                           setState(() => _obscureConfirm = !_obscureConfirm),
//                     ),

//                     Row(
//                       children: [
//                         Switch(
//                           value: _saveInfo,
//                           onChanged: (v) => setState(() => _saveInfo = v),
//                           activeColor: Colors.cyanAccent,
//                         ),
//                         Text(
//                           "Save my info?",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),
//                     buildSignUp(),
//                     SizedBox(height: 12.h),
//                     Row(
//                       children: [
//                         Expanded(child: Divider(color: Colors.white54)),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.w),
//                           child: Text(
//                             "OR",
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                         ),
//                         Expanded(child: Divider(color: Colors.white54)),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     _socialButton(
//                       label: "Continue With Phone",
//                       svg: Assets.images.signUpPhone.svg(),
//                     ),
//                     SizedBox(height: 10.h),
//                     _socialButton(
//                       label: "Continue With Google",
//                       svg: Assets.images.googleLogo.svg(),
//                       onTap: () => signInWithGoogle(context),
//                     ),
//                     SizedBox(height: 10.h),
//                     _socialButton(
//                       label: "Continue With Facebook",
//                       svg: Assets.images.facebookLogo.svg(),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account? ",
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             context.push('/log_in');
//                           },
//                           child: Text(
//                             'Log In',
//                             style: TextStyle(
//                               color: Colors.blueAccent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ElevatedButton buildSignUp() {
//     return ElevatedButton(
//       onPressed: _signUp,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.lightBlueAccent,
//         minimumSize: Size(double.infinity, 48.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//       child: Text(
//         "Sign Up",
//         style: TextStyle(
//           fontSize: 26.sp,
//           fontWeight: FontWeight.bold,
//           fontFamily: FontFamily.comfortaa,
//         ),
//       ),
//     );
//   }

//   Widget _buildInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//     VoidCallback? toggle,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(top: 16.h),
//       decoration: BoxDecoration(
//         color: Colors.white10,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         style: TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.white70),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
//           suffixIcon: toggle != null
//               ? IconButton(
//                   onPressed: toggle,
//                   icon: Icon(icon, color: Colors.white70),
//                 )
//               : Icon(icon, color: Colors.white70),
//         ),
//       ),
//     );
//   }

//   Widget _socialButton({
//     required String label,
//     required SvgPicture svg,
//     VoidCallback? onTap,
//   }) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: svg,
//       label: Text(label, style: TextStyle(color: Colors.white)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white10,
//         minimumSize: Size(double.infinity, 48.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//       ),
//     );
//   }
// }
