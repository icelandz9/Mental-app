import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color _primary = Color(0xFF5C6BC0);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController underlyingDiseaseController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedGender;

  Map<String, dynamic>? latestResult;
  List<dynamic> testResults = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadLatestResult();
  }

  Future<void> pickBirthday() async {
    final now = DateTime.now();
    DateTime initial = DateTime(now.year - 20);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      // คำนวณอายุจากวันเกิด
      int age = now.year - picked.year;
      if (now.month < picked.month ||
          (now.month == picked.month && now.day < picked.day)) {
        age--;
      }
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
        ageController.text = age.toString();
      });
    }
  }

  Future<void> saveProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text,
        'gender': selectedGender,
        'age': ageController.text,
        'underlyingDisease': underlyingDiseaseController.text,
        'birthday': dateController.text,
        'phone': phoneController.text,
      }, SetOptions(merge: true));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
      );
    } catch (e) {
      debugPrint("Save Profile Error: $e");
    }
  }

  Future<void> loadProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? '';
          ageController.text = data['age'] ?? '';
          phoneController.text = data['phone'] ?? '';
          underlyingDiseaseController.text = data['underlyingDisease'] ?? '';
          dateController.text = data['birthday'] ?? '';
          selectedGender = data['gender'];
        });
      }
    } catch (e) {
      debugPrint("Load Profile Error: $e");
    }
  }

  Future<void> loadLatestResult() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('results')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          latestResult = data;
          testResults = (data['results'] as List?) ?? [];
        });
      }
    } catch (e) {
      debugPrint("Load Result Error: $e");
    }
  }

  // InputDecoration กลาง (ไม่มี label ลอย ใช้ label แยกด้านบนแทน)
  InputDecoration _dec({Widget? suffix, String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ช่องกรอก 1 รายการ = ป้ายชื่อด้านบน + กล่อง (กันป้ายซ้อนขอบกล่อง)
  Widget _field(String label, Widget input) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF37474F),
              ),
            ),
          ),
          input,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "ประวัติส่วนตัว",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primary, Color(0xFFF6F7FB)],
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              children: [
                // ----- รูปโปรไฟล์ -----
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, size: 50, color: _primary),
                ),
                const SizedBox(height: 18),

                _field(
                  "ชื่อ",
                  TextField(controller: nameController, decoration: _dec()),
                ),

                _field(
                  "เพศ",
                  DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    decoration: _dec(),
                    items: const [
                      DropdownMenuItem(value: "ชาย", child: Text("ชาย")),
                      DropdownMenuItem(value: "หญิง", child: Text("หญิง")),
                      DropdownMenuItem(value: "อื่น ๆ", child: Text("อื่น ๆ")),
                    ],
                    onChanged: (value) =>
                        setState(() => selectedGender = value),
                  ),
                ),

                _field(
                  "อายุ (คำนวณจากวันเกิด)",
                  TextField(
                    controller: ageController,
                    readOnly: true,
                    decoration: _dec(),
                  ),
                ),

                _field(
                  "โรคประจำตัว",
                  TextField(
                    controller: underlyingDiseaseController,
                    decoration: _dec(),
                  ),
                ),

                _field(
                  "วันเกิด",
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: pickBirthday,
                    decoration: _dec(
                      suffix: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),

                _field(
                  "เบอร์โทรศัพท์",
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: _dec(),
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A6144),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "บันทึก",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ===== ผลแบบทดสอบล่าสุด =====
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ผลแบบทดสอบล่าสุด",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _latestResultSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== ส่วนแสดงผลแบบทดสอบล่าสุด =====
  Widget _latestResultSection() {
    if (latestResult == null) {
      return _whiteCard(
        child: const Text(
          "ยังไม่มีผลแบบทดสอบ",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final int flagged = (latestResult!['flaggedCount'] as num?)?.toInt() ?? 0;

    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                flagged == 0
                    ? Icons.check_circle
                    : Icons.warning_amber_rounded,
                color: flagged == 0
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFE65100),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  flagged == 0
                      ? "สุขภาพจิตโดยรวมอยู่ในเกณฑ์ดี"
                      : "มี $flagged แบบที่ควรใส่ใจ",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 22),
          ...testResults.map((r) {
            final bool isFlagged = r['flagged'] == true;
            final Color c = isFlagged
                ? const Color(0xFFB71C1C)
                : const Color(0xFF2E7D32);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Text(
                      "${r['condition']} (${r['instrument']})",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    "${r['score']}/${r['max']}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: c,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    underlyingDiseaseController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
