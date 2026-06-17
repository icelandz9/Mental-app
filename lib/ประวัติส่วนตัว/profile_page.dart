import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController underlyingDiseaseController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedGender;
  String result = "";

  Map<String, dynamic>? latestResult;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadLatestResult();
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
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
      );
    } catch (e) {
      print(e);
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
      print("Load Profile Error: $e");
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
          categories = data['categories'] ?? [];
        });
      }
    } catch (e) {
      print("Load Result Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ประวัติส่วนตัว"),
        backgroundColor: const Color.fromARGB(255, 111, 156, 196),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 123, 255, 160),
              Color.fromARGB(255, 253, 253, 253),
            ],
          ),
        ),
      
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 15),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "ชื่อ",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: "เพศ",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: "ชาย", child: Text("ชาย")),
                  DropdownMenuItem(value: "หญิง", child: Text("หญิง")),
                  DropdownMenuItem(value: "อื่น ๆ", child: Text("อื่น ๆ")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: "อายุ",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 15),

              TextField(
                controller: underlyingDiseaseController,
                decoration: const InputDecoration(
                  labelText: "โรคประจำตัว",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "วันเกิด",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "เบอร์โทรศัพท์",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await saveProfile();
                  setState(() {
                    result =
                        "ชื่อ: ${nameController.text}\n"
                        "เพศ: $selectedGender\n"
                        "อายุ: ${ageController.text}\n"
                        "โรคประจำตัว: ${underlyingDiseaseController.text}\n"
                        "วันเกิด: ${dateController.text}\n"
                        "เบอร์โทรศัพท์: ${phoneController.text}";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 97, 68),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("บันทึก"),
              ),

              const SizedBox(height: 20),

              if (result.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(result),
                ),

              const SizedBox(height: 30),

              // ===== RESULT SECTION =====
              const Text(
                "ผลแบบทดสอบล่าสุด",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              if (latestResult != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "คะแนนรวม: ${latestResult!['totalScore']} / ${latestResult!['maxScore']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "เปอร์เซ็นต์: ${(latestResult!['percent'] as num).toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ...categories.map((c) {
                        return ListTile(
                          title: Text(c['name']),
                          trailing: Text("${c['score']}/${c['max']}"),
                        );
                      }),
                    ],
                  ),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("ยังไม่มีผลแบบทดสอบ"),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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