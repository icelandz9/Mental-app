# โค้ดที่เชื่อมต่อ Firebase (ฉบับเต็ม) — แอป MindCare

แอปใช้ Firebase 2 บริการ: **Authentication** (ระบบสมาชิก) และ **Cloud Firestore** (ฐานข้อมูล)
ด้านล่างเป็นโค้ดเต็มของแต่ละระบบ (ไม่ตัด) พร้อมตำแหน่งบรรทัดในไฟล์จริง

---

## 1. เชื่อมต่อ Firebase ตอนเปิดแอป
📄 `lib/main.dart` (บรรทัด 8–16)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // เชื่อมต่อ Firebase ก่อนเปิดแอป
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

**อธิบาย:** จุดเริ่มต้นของแอป เตรียมระบบ Flutter แล้วเชื่อมต่อ Firebase ให้พร้อมก่อนเปิดหน้าจอแรก

---

## 2. ระบบสมัครสมาชิก (สร้างบัญชี + บันทึกชื่อ)
📄 `lib/login/register/register_page.dart` (บรรทัด 23–55)

```dart
Future<void> register() async {
  if (_passwordController.text.trim() !=
      _confirmPasswordController.text.trim()) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("รหัสผ่านไม่ตรงกัน")));
    return;
  }
  try {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // บันทึกชื่อที่กรอกตอนสมัคร ลงโปรไฟล์ users/{uid}
    // ใช้ merge เพื่อไม่ทับข้อมูลอื่นที่แก้ทีหลังในหน้าประวัติส่วนตัว
    await FirebaseFirestore.instance
        .collection('users')
        .doc(cred.user!.uid)
        .set({'name': _nameController.text.trim()}, SetOptions(merge: true));

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
```

**อธิบาย:** ตรวจรหัสผ่านให้ตรงกัน → สร้างบัญชีด้วย Firebase Auth → บันทึกชื่อลง Firestore → ดักจับข้อผิดพลาด (อีเมลซ้ำ/รหัสอ่อน) มาแจ้งเตือน

---

## 3. ระบบเข้าสู่ระบบ
📄 `lib/login/register/login_page.dart` (บรรทัด 19–37)

```dart
Future<void> login() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.message ?? "เกิดข้อผิดพลาด")));
  }
}
```

**อธิบาย:** ล็อกอินด้วยอีเมล/รหัสผ่านผ่าน Firebase Auth → สำเร็จไปหน้า Home → ผิดพลาดแจ้งเตือน

---

## 4. ระบบโปรไฟล์ (บันทึก + โหลดข้อมูลส่วนตัว)
📄 `lib/profile/profile_page.dart` (บรรทัด 59–122)

```dart
// ----- บันทึกข้อมูลโปรไฟล์ -----
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')));
  } catch (e) {
    debugPrint("Save Profile Error: $e");
  }
}

// ----- โหลดข้อมูลโปรไฟล์ -----
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

// ----- โหลดผลแบบทดสอบล่าสุด -----
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
```

**อธิบาย:** `saveProfile` บันทึกข้อมูลส่วนตัวลง Firestore, `loadProfile` อ่านมาเติมในฟอร์ม, `loadLatestResult` ดึงผลประเมินล่าสุด 1 รายการมาแสดง

---

## 5. บันทึกผลการประเมิน
📄 `lib/screens/result_screen.dart` (บรรทัด 224–252)

```dart
Future<void> _saveToFirebase() async {
  if (_saved) return;
  _saved = true;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('results')
      .add({
        'createdAt': FieldValue.serverTimestamp(),
        'flaggedCount': _flaggedCount,
        'selfHarmRisk': _selfHarmRisk,
        'results': _results
            .map(
              (r) => {
                'instrument': r.instrument,
                'condition': r.condition,
                'score': r.score,
                'max': r.max,
                'level': r.level,
                'flagged': r.flagged,
              },
            )
            .toList(),
      });
}
```

**อธิบาย:** หลังทำแบบทดสอบเสร็จ บันทึกผลลง `users/{uid}/results` โดยเก็บเวลา จำนวนด้านที่ควรใส่ใจ สัญญาณเสี่ยง และผลรายแบบทดสอบ (`_saved` กันบันทึกซ้ำ)

---

## 6. ดึงผลการประเมินแบบเรียลไทม์ (Dashboard)
📄 `lib/screens/dashboard_screen.dart` (บรรทัด 11–20)

```dart
Stream<QuerySnapshot<Map<String, dynamic>>>? _resultsStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('results')
      .orderBy('createdAt', descending: true)
      .snapshots();
}
```

**อธิบาย:** คืนค่า Stream ของผลประเมินผู้ใช้ (ใหม่สุดก่อน) — `.snapshots()` ทำให้หน้าจออัปเดตอัตโนมัติเมื่อมีผลใหม่

---

## สรุปการใช้ Firebase
| บริการ | เมธอดที่ใช้ | ใช้ในระบบ |
|---|---|---|
| **Authentication** | `createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `currentUser` | สมัคร, ล็อกอิน, ระบุตัวผู้ใช้ |
| **Cloud Firestore** | `.set()`, `.get()`, `.add()`, `.snapshots()` | โปรไฟล์, ผลประเมิน |

โครงสร้างข้อมูล: `users/{uid}` (โปรไฟล์) และ `users/{uid}/results/{id}` (ผลประเมินแต่ละครั้ง)
