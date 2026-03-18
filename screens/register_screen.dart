import 'package:flutter/material.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) return;

    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passwords do not match!',
            style: TextStyle(
                color: Colors.white,
                fontSize: Responsive(context).fontMD),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Connect to FastAPI register endpoint
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(r.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: r.spaceMD),

              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(r.spaceSM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                    BorderRadius.circular(r.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: r.iconMD,
                  ),
                ),
              ),

              SizedBox(height: r.spaceXL),

              // Title
              Text(
                'Create\nAccount',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.font4XL,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),

              SizedBox(height: r.spaceXS),

              Text(
                'Sign up to save your favorite places.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: r.fontMD,
                ),
              ),

              SizedBox(height: r.spaceXL),

              // Full Name
              _FieldLabel(label: 'FULL NAME', r: r),
              SizedBox(height: r.spaceSM),
              _InputField(
                controller: _nameController,
                hint: 'Juan dela Cruz',
                icon: Icons.person_outline,
                r: r,
              ),

              SizedBox(height: r.spaceMD),

              // Email
              _FieldLabel(label: 'EMAIL', r: r),
              SizedBox(height: r.spaceSM),
              _InputField(
                controller: _emailController,
                hint: 'your@email.com',
                icon: Icons.email_outlined,
                r: r,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: r.spaceMD),

              // Password
              _FieldLabel(label: 'PASSWORD', r: r),
              SizedBox(height: r.spaceSM),
              _InputField(
                controller: _passwordController,
                hint: '••••••••',
                icon: Icons.lock_outline,
                r: r,
                obscureText: _obscurePassword,
                suffix: GestureDetector(
                  onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textMuted,
                    size: r.iconSM,
                  ),
                ),
              ),

              SizedBox(height: r.spaceMD),

              // Confirm Password
              _FieldLabel(label: 'CONFIRM PASSWORD', r: r),
              SizedBox(height: r.spaceSM),
              _InputField(
                controller: _confirmPasswordController,
                hint: '••••••••',
                icon: Icons.lock_outline,
                r: r,
                obscureText: _obscureConfirm,
                suffix: GestureDetector(
                  onTap: () => setState(
                          () => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textMuted,
                    size: r.iconSM,
                  ),
                ),
              ),

              SizedBox(height: r.spaceXL),

              // Register button
              GestureDetector(
                onTap: _isLoading ? null : _register,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(vertical: r.spaceMD),
                  decoration: BoxDecoration(
                    color: _isLoading
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(r.radiusLG),
                  ),
                  child: _isLoading
                      ? Center(
                    child: SizedBox(
                      width: r.iconMD,
                      height: r.iconMD,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                      : Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: r.spaceLG),

              // Divider
              Row(
                children: [
                  Expanded(
                      child: Container(
                          height: 1, color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.spaceMD),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: r.fontSM,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          height: 1, color: AppColors.border)),
                ],
              ),

              SizedBox(height: r.spaceLG),

              // Login link
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                      const LoginScreen(),
                      transitionsBuilder:
                          (_, animation, __, child) =>
                          FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(vertical: r.spaceMD),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(r.radiusLG),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Already have an account? Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: r.spaceLG),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared Widgets ────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final Responsive r;

  const _FieldLabel({required this.label, required this.r});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.textDisabled,
        fontSize: r.fontXS,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Responsive r;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.r,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spaceMD,
        vertical: r.spaceSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: r.iconSM),
          SizedBox(width: r.spaceSM),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.fontMD,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: r.fontMD,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
