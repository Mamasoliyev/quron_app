import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quron_app/feautures/view/screens/home_screen.dart';
import 'package:quron_app/feautures/view_model/auth_provider.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/gen/assets.gen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  static String path = '/log_in';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isObsecure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    Future<void> handleLogin() async {
      final success = await authProvider.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        context.go(HomeScreen.path);
      } else if (authProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
      }
    }

    Future<void> handleGoogleLogin() async {
      final success = await authProvider.googleSignIn();
      if (success && mounted) {
        context.go(HomeScreen.path);
      } else if (authProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF010E36), Color(0xFF081243)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 30.w,
              top: 30.h,
              child: Container(
                width: 5.r,
                height: 5.r,
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
              top: 300.h,
              child: Container(
                width: 5.r,
                height: 5.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 100.r,
                      color: Color.fromARGB(255, 105, 135, 254),
                      spreadRadius: 100.r,
                    ),
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
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 130.w,
                      height: 2.h,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _isObsecure,
                      suffix: IconButton(
                        icon: Icon(
                          _isObsecure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            setState(() => _isObsecure = !_isObsecure),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00D4FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onPressed: authProvider.isLoading ? null : handleLogin,
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text('OR', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ListTile(
                        onTap: authProvider.isLoading
                            ? null
                            : () => handleGoogleLogin(),
                        leading: Assets.images.googleLogo.svg(height: 24.h),
                        title: Text(
                          'Continue With Google',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have any account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/sign_up'),
                          child: Text(
                            'Register',
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: suffix,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
