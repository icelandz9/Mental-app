import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/questions_data.dart';
import 'question_screen.dart';

// ===== สีระดับความรุนแรง =====
const Color _cGreen = Color(0xFF2E7D32);
const Color _cLime = Color(0xFF7CB342);
const Color _cOrange = Color(0xFFF57F17);
const Color _cDeepOrange = Color(0xFFE65100);
const Color _cRed = Color(0xFFB71C1C);

// ===== ผลคะแนนของแบบทดสอบ 1 ชุด =====
class _ScoreResult {
  final String instrument; // 'PHQ-9'
  final String condition; // 'ซึมเศร้า'
  final int score;
  final int max;
  final String level; // ข้อความแปลผล
  final Color color;
  final bool flagged; // true = อยู่ในเกณฑ์ที่ควรใส่ใจ
  final String advice; // คำแนะนำ

  const _ScoreResult({
    required this.instrument,
    required this.condition,
    required this.score,
    required this.max,
    required this.level,
    required this.color,
    required this.flagged,
    required this.advice,
  });
}

class ResultScreen extends StatefulWidget {
  final List<int> answers; // index ของตัวเลือกที่เลือก เรียงตาม questions

  const ResultScreen({super.key, required this.answers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  // คำนวณผลทุกแบบทดสอบครั้งเดียว
  late final List<_ScoreResult> _results = _computeAll();
  int get _flaggedCount => _results.where((r) => r.flagged).length;

  // รายการที่ควรใส่ใจ (เรียงคะแนนมาก→น้อย) และรายการปกติ
  List<_ScoreResult> get _flaggedList {
    final list = _results.where((r) => r.flagged).toList();
    list.sort((a, b) => (b.score / b.max).compareTo(a.score / a.max));
    return list;
  }

  List<_ScoreResult> get _normalList =>
      _results.where((r) => !r.flagged).toList();

  // เสี่ยงทำร้ายตัวเอง: PHQ-9 ข้อ 9 (index 8) ตอบมากกว่า "ไม่เลย"
  bool get _selfHarmRisk => widget.answers.length > 8 && widget.answers[8] > 0;

  // ===== คิดคะแนนรวมแยกตามแบบทดสอบ =====
  List<_ScoreResult> _computeAll() {
    const order = ['PHQ-9', 'GAD-7', 'PSS-10', 'ASRS', 'OCI-R', 'PCL-5', 'MDQ'];
    final out = <_ScoreResult>[];

    for (final inst in order) {
      int sum = 0; // คะแนนรวม (ใช้กับ PHQ-9/GAD-7/PSS/OCI-R/PCL-5)
      int partA = 0; // จำนวนข้อ Part A ที่ถึงเกณฑ์ (ASRS)
      int yes = 0; // จำนวน "ใช่" (MDQ)

      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        if (q.instrument != inst) continue;
        final a = widget.answers[i];
        final s = (a == -1) ? 0 : q.scores[a];
        sum += s;
        if (q.threshold != null && a != -1 && q.scores[a] >= q.threshold!) {
          partA++;
        }
        if (inst == 'MDQ' && s == 1) yes++;
      }

      out.add(_interpret(inst, sum: sum, partA: partA, yes: yes));
    }
    return out;
  }

  // ===== แปลผลตามเกณฑ์มาตรฐานของแต่ละแบบทดสอบ =====
  _ScoreResult _interpret(
    String inst, {
    required int sum,
    required int partA,
    required int yes,
  }) {
    switch (inst) {
      case 'PHQ-9':
        return _band('PHQ-9', 'ภาวะซึมเศร้า', sum, 27, const [
          [4, 'ปกติ / น้อยมาก', _cGreen, false],
          [9, 'เล็กน้อย', _cLime, false],
          [14, 'ปานกลาง', _cOrange, true],
          [19, 'ค่อนข้างรุนแรง', _cDeepOrange, true],
          [27, 'รุนแรง', _cRed, true],
        ]);
      case 'GAD-7':
        return _band('GAD-7', 'โรควิตกกังวล', sum, 21, const [
          [4, 'ปกติ / น้อยมาก', _cGreen, false],
          [9, 'เล็กน้อย', _cLime, false],
          [14, 'ปานกลาง', _cOrange, true],
          [21, 'รุนแรง', _cRed, true],
        ]);
      case 'PSS-10':
        return _band('PSS-10', 'ความเครียด', sum, 40, const [
          [13, 'เครียดต่ำ', _cGreen, false],
          [26, 'เครียดปานกลาง', _cOrange, false],
          [40, 'เครียดสูง', _cRed, true],
        ]);
      case 'ASRS':
        final flagged = partA >= 4;
        return _ScoreResult(
          instrument: 'ASRS',
          condition: 'สมาธิสั้น (ADHD)',
          score: partA,
          max: 6,
          level: flagged ? 'มีแนวโน้ม' : 'ไม่พบแนวโน้มชัดเจน',
          color: flagged ? _cRed : _cGreen,
          flagged: flagged,
          advice: flagged
              ? 'พบเกณฑ์เข้าได้กับ ADHD ควรปรึกษาจิตแพทย์เพื่อประเมินเพิ่มเติม'
              : 'ไม่พบแนวโน้มชัดเจน',
        );
      case 'OCI-R':
        final flagged = sum >= 21;
        return _ScoreResult(
          instrument: 'OCI-R',
          condition: 'โรคย้ำคิดย้ำทำ (OCD)',
          score: sum,
          max: 72,
          level: flagged ? 'มีแนวโน้ม' : 'ต่ำกว่าเกณฑ์',
          color: flagged ? _cRed : _cGreen,
          flagged: flagged,
          advice: flagged
              ? 'คะแนนถึงจุดตัด OCD ควรปรึกษาจิตแพทย์/นักจิตวิทยา'
              : 'ต่ำกว่าเกณฑ์ ไม่น่ากังวล',
        );
      case 'PCL-5':
        final flagged = sum >= 31;
        return _ScoreResult(
          instrument: 'PCL-5',
          condition: 'ภาวะเครียดหลังเหตุสะเทือนใจ (PTSD)',
          score: sum,
          max: 80,
          level: flagged ? 'มีแนวโน้ม' : 'ต่ำกว่าเกณฑ์',
          color: flagged ? _cRed : _cGreen,
          flagged: flagged,
          advice: flagged
              ? 'คะแนนถึงจุดตัด PTSD ควรพบจิตแพทย์เพื่อประเมินเชิงลึก'
              : 'ต่ำกว่าเกณฑ์ ไม่น่ากังวล',
        );
      case 'MDQ':
      default:
        final flagged = yes >= 7;
        return _ScoreResult(
          instrument: 'MDQ',
          condition: 'โรคไบโพลาร์',
          score: yes,
          max: 13,
          level: flagged ? 'คัดกรองเป็นบวก' : 'คัดกรองเป็นลบ',
          color: flagged ? _cRed : _cGreen,
          flagged: flagged,
          advice: flagged
              ? 'ผลคัดกรองเป็นบวก ควรพบจิตแพทย์เพื่อยืนยันการวินิจฉัย'
              : 'ผลคัดกรองเป็นลบ ไม่น่ากังวล',
        );
    }
  }

  // ตัวช่วยแปลผลแบบช่วงคะแนน (band) — กำหนด advice อัตโนมัติจาก flagged
  _ScoreResult _band(
    String inst,
    String cond,
    int score,
    int max,
    List<List<dynamic>> bands,
  ) {
    for (final b in bands) {
      if (score <= (b[0] as int)) {
        return _make(inst, cond, score, max, b);
      }
    }
    return _make(inst, cond, score, max, bands.last);
  }

  _ScoreResult _make(
    String inst,
    String cond,
    int score,
    int max,
    List<dynamic> b,
  ) {
    final level = b[1] as String;
    final flagged = b[3] as bool;
    return _ScoreResult(
      instrument: inst,
      condition: cond,
      score: score,
      max: max,
      level: level,
      color: b[2] as Color,
      flagged: flagged,
      advice: flagged
          ? 'อยู่ในระดับ"$level" แนะนำปรึกษาจิตแพทย์/นักจิตวิทยา'
          : 'อยู่ในระดับ"$level" ดูแลสุขภาพใจต่อไปได้',
    );
  }

  // ===== บันทึกผลลง Firebase (แยกตามผู้ใช้) =====
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _saveToFirebase());
  }

  // ===== สรุปคำวินิจฉัยภาพรวม =====
  Map<String, dynamic> get _verdict {
    if (_flaggedCount == 0) {
      return {
        'color': _cGreen,
        'icon': Icons.verified_user,
        'title': 'สุขภาพจิตอยู่ในเกณฑ์ดี',
        'message':
            'ยังไม่พบความเสี่ยงที่ต้องพบแพทย์ ดูแลสุขภาพใจแบบนี้ต่อไปได้เลย',
      };
    } else if (_flaggedCount <= 2) {
      return {
        'color': _cOrange,
        'icon': Icons.health_and_safety,
        'title': 'พบความเสี่ยงบางด้าน',
        'message':
            'มี $_flaggedCount ด้านที่ควรใส่ใจ แนะนำปรึกษาผู้เชี่ยวชาญเพื่อประเมินเพิ่มเติม',
      };
    } else {
      return {
        'color': _cRed,
        'icon': Icons.medical_services,
        'title': 'ควรพบจิตแพทย์',
        'message':
            'พบความเสี่ยงถึง $_flaggedCount ด้าน แนะนำพบจิตแพทย์หรือนักจิตวิทยาเร็ว ๆ นี้',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = _verdict;
    final Color headColor = v['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [headColor, const Color(0xFFF6F7FB)],
            stops: const [0.0, 0.32],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                'ผลการคัดกรองเบื้องต้น',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _verdictCard(v),
                    if (_selfHarmRisk) ...[
                      const SizedBox(height: 12),
                      _urgentCard(),
                    ],
                    const SizedBox(height: 18),

                    if (_flaggedList.isNotEmpty) ...[
                      _sectionTitle('ด้านที่ควรใส่ใจ', _cRed),
                      const SizedBox(height: 8),
                      ..._flaggedList.map(_riskCard),
                      const SizedBox(height: 14),
                    ],

                    _sectionTitle('ด้านที่อยู่ในเกณฑ์ปกติ', _cGreen),
                    const SizedBox(height: 8),
                    _normalCard(),

                    const SizedBox(height: 16),
                    _disclaimer(),
                  ],
                ),
              ),

              // ----- ปุ่มล่าง -----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuestionScreen(),
                          ),
                        ),
                        child: const Text('ทำแบบประเมินอีกครั้ง'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text(
                          'กลับหน้าโฮม',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----- การ์ดสรุปคำวินิจฉัย -----
  Widget _verdictCard(Map<String, dynamic> v) {
    final Color c = v['color'] as Color;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(v['icon'] as IconData, color: c, size: 34),
          ),
          const SizedBox(height: 12),
          Text(
            v['title'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            v['message'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ----- การ์ดเตือนเร่งด่วน (เสี่ยงทำร้ายตัวเอง) -----
  Widget _urgentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cRed, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _cRed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'คุณตอบว่ามีความคิดทำร้ายตัวเอง',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _cRed,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'คุณไม่ได้อยู่คนเดียว โปรดบอกคนที่ไว้ใจ หรือโทรปรึกษา\n'
                  'สายด่วนสุขภาพจิต 1323 (ฟรี 24 ชม.)',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ----- การ์ดความเสี่ยงแต่ละด้าน -----
  Widget _riskCard(_ScoreResult r) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: r.color.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.condition,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: r.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r.level,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: r.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'แบบทดสอบ ${r.instrument} · คะแนน ${r.score}/${r.max}',
            style: const TextStyle(fontSize: 12.5, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.medical_services_outlined, size: 16, color: r.color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  r.advice,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----- การ์ดสรุปด้านที่ปกติ -----
  Widget _normalCard() {
    if (_normalList.isEmpty) {
      return _plainCard(
        const Text('—', style: TextStyle(color: Colors.black54)),
      );
    }
    return _plainCard(
      Column(
        children: _normalList.map((r) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: _cGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${r.condition} (${r.instrument})',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  r.level,
                  style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _plainCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _disclaimer() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'หมายเหตุ: ผลนี้เป็นเพียงการคัดกรองเบื้องต้น ไม่ใช่การวินิจฉัยทางการแพทย์ '
        'การวินิจฉัยที่ถูกต้องต้องทำโดยจิตแพทย์หรือผู้เชี่ยวชาญเท่านั้น',
        style: TextStyle(fontSize: 11.5, height: 1.5, color: Colors.black54),
      ),
    );
  }
}
