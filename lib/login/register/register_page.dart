import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedGender;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> register() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")));
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("สมัครสมาชิกสำเร็จ")));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "เกิดข้อผิดพลาด")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("สมัครสมาชิก"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
            colors: [AppColors.primary, AppColors.bg],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 120),
              const Text(
                "MC MindCare",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),

              // ใส่โลโก้
              Image.asset("assets/image/design.png", height: 160),

              const SizedBox(height: 60),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "ชื่อ",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              // const SizedBox(height: 10),
              // TextField(
              //   controller: _ageController,
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly,
              //     LengthLimitingTextInputFormatter(3),
              //   ],
              //   decoration: const InputDecoration(
              //     labelText: "อายุ",
              //     border: OutlineInputBorder(),
              //     filled: true,
              //     fillColor: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 15),
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //     labelText: "เพศ",
              //     border: OutlineInputBorder(),
              //     filled: true,
              //     fillColor: Colors.white,
              //   ),
              //   initialValue: selectedGender,
              //   items: const [
              //     DropdownMenuItem(value: "ชาย", child: Text("ชาย")),
              //     DropdownMenuItem(value: "หญิง", child: Text("หญิง")),
              //     DropdownMenuItem(value: "อื่น ๆ", child: Text("อื่น ๆ")),
              //   ],
              //   onChanged: (value) {
              //     setState(() {
              //       selectedGender = value;
              //     });
              //   },
              // ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "อีเมล",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "รหัสผ่าน",
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "ยืนยันรหัสผ่าน",
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
