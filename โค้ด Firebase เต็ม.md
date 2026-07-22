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

**การทำงาน:** ฟังก์ชัน `main()` คือจุดเริ่มต้นของแอปทั้งหมด ทำงาน 3 ขั้นตอนก่อนแสดงหน้าจอแรก คือ (1) `WidgetsFlutterBinding.ensureInitialized()` เป็นการสั่งให้ Flutter เตรียมระบบภายในให้พร้อมทำงาน จำเป็นต้องเรียกก่อนเสมอเมื่อมีงานที่ต้องรอผล (async) ก่อนเปิดแอป (2) `Firebase.initializeApp()` เชื่อมต่อแอปเข้ากับโปรเจกต์ Firebase บนคลาวด์ โดยดึงค่าตั้งค่า (API key, project ID ฯลฯ) จาก `DefaultFirebaseOptions.currentPlatform` ซึ่งจะเลือกค่าตามแพลตฟอร์มที่กำลังรันอยู่โดยอัตโนมัติ (Android / iOS / Web) และใช้ `await` เพื่อรอให้เชื่อมต่อเสร็จก่อน (3) `runApp()` เริ่มแสดงหน้าจอของแอป — การเชื่อมต่อ Firebase ต้องเสร็จก่อนขั้นตอนนี้ ไม่เช่นนั้นระบบสมาชิกและฐานข้อมูลจะใช้งานไม่ได้

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

**การทำงาน:** เมื่อผู้ใช้กดปุ่มสมัครสมาชิก ระบบจะทำงานตามลำดับดังนี้ (1) ตรวจสอบก่อนว่ารหัสผ่านและช่องยืนยันรหัสผ่านตรงกันหรือไม่ ถ้าไม่ตรงจะแจ้งเตือน "รหัสผ่านไม่ตรงกัน" แล้วหยุดทันที (ใช้ `.trim()` ตัดช่องว่างหน้า-หลังกันพิมพ์เว้นวรรคเกิน) (2) เรียก `createUserWithEmailAndPassword()` เพื่อสร้างบัญชีใหม่บนระบบ Firebase Authentication โดยส่งอีเมลและรหัสผ่านไป Firebase จะสร้าง `uid` (รหัสประจำตัวผู้ใช้ที่ไม่ซ้ำกัน) กลับมาผ่านตัวแปร `cred` (3) นำชื่อที่ผู้ใช้กรอกไปบันทึกลงฐานข้อมูล Firestore ที่เอกสาร `users/{uid}` โดยใช้ `SetOptions(merge: true)` ซึ่งหมายถึงเขียนทับเฉพาะฟิลด์ `name` โดยไม่ลบข้อมูลอื่นที่อาจถูกกรอกทีหลังในหน้าประวัติส่วนตัว (เช่น อายุ เพศ เบอร์โทร) (4) ถ้าสำเร็จจะแจ้งเตือนและกลับไปหน้าเข้าสู่ระบบ แต่ถ้าเกิดข้อผิดพลาด เช่น อีเมลถูกใช้ไปแล้วหรือรหัสผ่านสั้นเกินไป จะถูกดักจับด้วย `on FirebaseAuthException` แล้วนำข้อความจาก Firebase มาแสดงให้ผู้ใช้ทราบ

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

**การทำงาน:** เมื่อผู้ใช้กดปุ่มเข้าสู่ระบบ ระบบจะเรียก `signInWithEmailAndPassword()` เพื่อส่งอีเมลและรหัสผ่านไปตรวจสอบกับ Firebase Authentication ถ้าข้อมูลถูกต้อง Firebase จะยืนยันตัวตนและจดจำสถานะการล็อกอินไว้ จากนั้นระบบจะใช้ `Navigator.pushReplacement()` พาไปหน้าหลัก (HomePage) แบบแทนที่หน้าเดิม เพื่อไม่ให้ผู้ใช้กดปุ่มย้อนกลับมาหน้าล็อกอินได้อีก แต่ถ้าอีเมลหรือรหัสผ่านไม่ถูกต้อง จะถูกดักจับด้วย `on FirebaseAuthException` แล้วนำข้อความแจ้งเหตุผล (เช่น รหัสผ่านผิด หรือไม่พบบัญชีนี้) มาแสดงเตือน — การใช้ `if (!mounted) return;` เป็นการป้องกันข้อผิดพลาดกรณีหน้าจอถูกปิดไปแล้วระหว่างรอผลจากเซิร์ฟเวอร์

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

**การทำงาน:** หน้าประวัติส่วนตัวมีฟังก์ชันจัดการข้อมูล 3 ตัว คือ

- **`saveProfile()` — บันทึกข้อมูล:** ดึง `uid` ของผู้ใช้ที่ล็อกอินอยู่จาก `currentUser` แล้วเขียนข้อมูลทั้งหมด (ชื่อ เพศ อายุ โรคประจำตัว วันเกิด เบอร์โทร) ลงเอกสาร `users/{uid}` โดยใช้ `SetOptions(merge: true)` เพื่อรวมกับข้อมูลเดิมโดยไม่ลบฟิลด์อื่นทิ้ง เมื่อสำเร็จจะแจ้งเตือน "บันทึกข้อมูลสำเร็จ"
- **`loadProfile()` — โหลดข้อมูล:** อ่านเอกสาร `users/{uid}` ด้วย `.get()` (ดึงครั้งเดียว) ถ้าเอกสารมีอยู่จริง (`doc.exists`) จะนำค่าแต่ละฟิลด์มาเติมลงในช่องกรอกของฟอร์มผ่าน `setState()` เพื่อให้หน้าจอแสดงข้อมูลเดิมที่เคยบันทึกไว้ (ใช้ `?? ''` เพื่อกันค่าว่างกรณียังไม่เคยกรอกฟิลด์นั้น)
- **`loadLatestResult()` — โหลดผลประเมินล่าสุด:** ค้นในคอลเลกชันย่อย `users/{uid}/results` โดยเรียง `createdAt` จากใหม่ไปเก่า (`descending: true`) แล้วจำกัดผลแค่ 1 รายการด้วย `.limit(1)` เพื่อดึงผลการประเมินครั้งล่าสุดมาแสดงสรุปในหน้าโปรไฟล์

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

**การทำงาน:** ฟังก์ชันนี้ทำงานอัตโนมัติเมื่อผู้ใช้ทำแบบทดสอบเสร็จและเข้าหน้าแสดงผล มีขั้นตอนดังนี้ (1) ตรวจตัวแปร `_saved` ก่อน ถ้าเคยบันทึกไปแล้วจะหยุดทันที เพื่อกันการบันทึกซ้ำกรณีหน้าจอถูกวาดใหม่ (rebuild) แล้วตั้ง `_saved = true` (2) ดึง `currentUser` มาตรวจว่ามีผู้ใช้ล็อกอินอยู่จริงหรือไม่ ถ้าไม่มีจะไม่บันทึก (3) ใช้ `.add()` เพิ่มเอกสารใหม่ลงในคอลเลกชันย่อย `users/{uid}/results` โดย `.add()` จะสร้างรหัสเอกสาร (ID) แบบสุ่มให้เองทุกครั้ง ทำให้ผลแต่ละครั้งเก็บแยกกันเป็นประวัติ ข้อมูลที่บันทึกประกอบด้วย `createdAt` (เวลาจากเซิร์ฟเวอร์ด้วย `FieldValue.serverTimestamp()` เพื่อความแม่นยำและเรียงลำดับได้ถูกต้อง), `flaggedCount` (จำนวนด้านที่ควรใส่ใจ), `selfHarmRisk` (สัญญาณความเสี่ยงทำร้ายตัวเอง) และ `results` ที่แปลงผลรายแบบทดสอบแต่ละตัว (ชื่อเครื่องมือ ภาวะที่ประเมิน คะแนน คะแนนเต็ม ระดับ และสถานะ flagged) เป็นรายการ (List) ด้วย `.map()`

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

**การทำงาน:** ฟังก์ชันนี้สร้าง "Stream" (สายข้อมูลแบบต่อเนื่อง) ของผลการประเมินเพื่อให้หน้า Dashboard แสดงประวัติแบบเรียลไทม์ ขั้นตอนคือ (1) ดึง `currentUser` มาตรวจก่อน ถ้าไม่มีผู้ใช้ล็อกอินจะคืนค่า `null` (2) ชี้ไปที่คอลเลกชันย่อย `users/{uid}/results` แล้วเรียงลำดับด้วย `orderBy('createdAt', descending: true)` เพื่อให้ผลล่าสุดอยู่บนสุด (3) จุดสำคัญคือใช้ `.snapshots()` แทน `.get()` — ความต่างคือ `.get()` ดึงข้อมูลครั้งเดียวแล้วจบ แต่ `.snapshots()` จะ"เฝ้าฟัง" ฐานข้อมูลตลอดเวลา เมื่อใดที่มีผลประเมินใหม่ถูกบันทึกเข้ามา Firestore จะส่งข้อมูลชุดใหม่กลับมาให้ทันที ทำให้หน้าจอ (ที่ใช้ร่วมกับ `StreamBuilder`) อัปเดตรายการใหม่โดยผู้ใช้ไม่ต้องรีเฟรชหรือกดโหลดเอง

---

## สรุปการใช้ Firebase
| บริการ | เมธอดที่ใช้ | ใช้ในระบบ |
|---|---|---|
| **Authentication** | `createUserWithEmailAndPassword`, `signInWithEmailAndPassword`, `currentUser` | สมัคร, ล็อกอิน, ระบุตัวผู้ใช้ |
| **Cloud Firestore** | `.set()`, `.get()`, `.add()`, `.snapshots()` | โปรไฟล์, ผลประเมิน |

โครงสร้างข้อมูล: `users/{uid}` (โปรไฟล์) และ `users/{uid}/results/{id}` (ผลประเมินแต่ละครั้ง)
