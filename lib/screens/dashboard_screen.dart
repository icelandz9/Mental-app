import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ===== หน้าแดชบอร์ด: ดึงผลการประเมินของผู้ใช้จาก Firebase มาแสดงแยกตามด้าน =====
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // สตรีมผลการประเมินของผู้ใช้ปัจจุบัน (ใหม่สุดอยู่บน)
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

  @override
  Widget build(BuildContext context) {
    final stream = _resultsStream();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.28],
            colors: [AppColors.primary, AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== หัว: ปุ่มกลับ + ชื่อหน้า =====
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    _circleBtn(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'แดชบอร์ดผลประเมิน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // ถ่วงให้ชื่อกึ่งกลาง
                  ],
                ),
              ),

              Expanded(
                child: stream == null
                    ? _centered(
                        Icons.lock_outline_rounded,
                        'กรุณาเข้าสู่ระบบ',
                        'ต้องเข้าสู่ระบบก่อนจึงจะดูผลประเมินได้',
                      )
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: stream,
                        builder: (context, snap) {
                          if (snap.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snap.hasError) {
                            return _centered(
                              Icons.error_outline_rounded,
                              'โหลดข้อมูลไม่สำเร็จ',
                              'เกิดข้อผิดพลาด โปรดลองใหม่อีกครั้ง',
                            );
                          }
                          final docs = snap.data?.docs ?? [];
                          if (docs.isEmpty) {
                            return _emptyState(context);
                          }
                          return _content(context, docs);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== เนื้อหาหลักเมื่อมีข้อมูล =====
  Widget _content(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final latest = docs.first.data();
    final latestItems = _items(latest);
    final flagged = latestItems.where((e) => e.flagged).toList()
      ..sort((a, b) => b.ratio.compareTo(a.ratio));
    final normal = latestItems.where((e) => !e.flagged).toList();

    final flaggedCount = (latest['flaggedCount'] as num?)?.toInt() ??
        flagged.length;
    final selfHarm = latest['selfHarmRisk'] == true;
    final createdAt = latest['createdAt'] as Timestamp?;

    // เทียบกับครั้งก่อน (ถ้ามี)
    int? prevCount;
    if (docs.length >= 2) {
      prevCount = (docs[1].data()['flaggedCount'] as num?)?.toInt();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _summaryCard(flaggedCount, prevCount, createdAt, docs.length),
        if (selfHarm) ...[
          const SizedBox(height: 12),
          _urgentCard(),
        ],
        const SizedBox(height: 20),

        // ----- ผลล่าสุดแยกตามด้าน -----
        _sectionTitle('ผลล่าสุด · แยกตามด้าน'),
        const SizedBox(height: 10),
        if (flagged.isNotEmpty) ...[
          _miniLabel('ด้านที่ควรใส่ใจ', AppColors.red),
          const SizedBox(height: 8),
          ...flagged.map(_breakdownCard),
          const SizedBox(height: 10),
        ],
        if (normal.isNotEmpty) ...[
          _miniLabel('ด้านที่อยู่ในเกณฑ์ปกติ', AppColors.green),
          const SizedBox(height: 8),
          ...normal.map(_breakdownCard),
        ],
        const SizedBox(height: 22),

        // ----- ประวัติการประเมิน -----
        _sectionTitle('ประวัติการประเมิน (${docs.length} ครั้ง)'),
        const SizedBox(height: 10),
        ...docs.map((d) => _historyTile(d.data())),
      ],
    );
  }

  // ===== การ์ดสรุปภาพรวม =====
  Widget _summaryCard(
    int flaggedCount,
    int? prevCount,
    Timestamp? createdAt,
    int total,
  ) {
    final Color c;
    final IconData icon;
    final String title;
    if (flaggedCount == 0) {
      c = AppColors.green;
      icon = Icons.verified_user_rounded;
      title = 'สุขภาพจิตอยู่ในเกณฑ์ดี';
    } else if (flaggedCount <= 2) {
      c = AppColors.orange;
      icon = Icons.health_and_safety_rounded;
      title = 'พบความเสี่ยงบางด้าน';
    } else {
      c = AppColors.red;
      icon = Icons.medical_services_rounded;
      title = 'ควรพบจิตแพทย์';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDeco(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: c, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: c,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ประเมินล่าสุด ${_fmtDate(createdAt)}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  '$flaggedCount',
                  'ด้านที่ควรใส่ใจ',
                  c,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statBox('$total', 'ครั้งที่ประเมิน', AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(child: _trendBox(flaggedCount, prevCount)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // กล่องแนวโน้มเทียบครั้งก่อน
  Widget _trendBox(int now, int? prev) {
    String label;
    Color color;
    IconData icon;
    if (prev == null) {
      label = 'ครั้งแรก';
      color = AppColors.textSecondary;
      icon = Icons.remove_rounded;
    } else if (now < prev) {
      label = 'ดีขึ้น';
      color = AppColors.green;
      icon = Icons.trending_down_rounded;
    } else if (now > prev) {
      label = 'เพิ่มขึ้น';
      color = AppColors.red;
      icon = Icons.trending_up_rounded;
    } else {
      label = 'เท่าเดิม';
      color = AppColors.orange;
      icon = Icons.trending_flat_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===== การ์ดเตือนเร่งด่วน =====
  Widget _urgentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red, width: 1.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.warning_amber_rounded, color: AppColors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'ผลล่าสุดมีสัญญาณเสี่ยงทำร้ายตัวเอง\n'
              'หากต้องการความช่วยเหลือ โทรสายด่วนสุขภาพจิต 1323 (ฟรี 24 ชม.)',
              style: TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ===== การ์ดผลแต่ละด้าน (มี bar คะแนน) =====
  Widget _breakdownCard(_Item it) {
    final color = it.color;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(borderColor: color.withValues(alpha: 0.35)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  it.condition,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  it.level,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // แถบคะแนน
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: it.ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${it.instrument} · คะแนน ${it.score}/${it.max}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===== รายการประวัติ 1 ครั้ง (กดเพื่อดูรายละเอียด) =====
  Widget _historyTile(Map<String, dynamic> data) {
    final items = _items(data);
    final flaggedCount = (data['flaggedCount'] as num?)?.toInt() ??
        items.where((e) => e.flagged).length;
    final createdAt = data['createdAt'] as Timestamp?;
    final selfHarm = data['selfHarmRisk'] == true;
    final Color badgeColor = flaggedCount == 0
        ? AppColors.green
        : (flaggedCount <= 2 ? AppColors.orange : AppColors.red);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDeco(),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // ลบเส้นขอบ default ของ ExpansionTile
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              selfHarm ? Icons.warning_amber_rounded : Icons.event_note_rounded,
              color: badgeColor,
              size: 22,
            ),
          ),
          title: Text(
            _fmtDate(createdAt),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            flaggedCount == 0
                ? 'ไม่พบด้านที่ต้องใส่ใจ'
                : 'มี $flaggedCount ด้านที่ควรใส่ใจ',
            style: TextStyle(fontSize: 12.5, color: badgeColor),
          ),
          children: items
              .map(
                (it) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        it.flagged
                            ? Icons.error_rounded
                            : Icons.check_circle_rounded,
                        size: 16,
                        color: it.color,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${it.condition} (${it.instrument})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        '${it.level} · ${it.score}/${it.max}',
                        style: TextStyle(
                          fontSize: 12,
                          color: it.flagged
                              ? it.color
                              : AppColors.textSecondary,
                          fontWeight: it.flagged
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ===== สถานะว่าง: ยังไม่เคยทำแบบประเมิน =====
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.insights_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'ยังไม่มีผลการประเมิน',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'เมื่อทำแบบประเมินเสร็จ ผลจะถูกบันทึก\nและแสดงสรุปที่นี่',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('กลับไปทำแบบประเมิน'),
            ),
          ],
        ),
      ),
    );
  }

  // ===== ตัวช่วย UI ทั่วไป =====
  Widget _centered(IconData icon, String title, String sub) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _miniLabel(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, size: 9, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.22),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  BoxDecoration _cardDeco({Color? borderColor}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: borderColor != null ? Border.all(color: borderColor) : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ===== แปลงข้อมูล results[] ใน 1 เอกสารเป็นลิสต์ _Item =====
  List<_Item> _items(Map<String, dynamic> data) {
    final raw = data['results'];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((m) {
      final score = (m['score'] as num?)?.toInt() ?? 0;
      final max = (m['max'] as num?)?.toInt() ?? 1;
      final flagged = m['flagged'] == true;
      final ratio = max > 0 ? score / max : 0.0;
      return _Item(
        instrument: (m['instrument'] ?? '') as String,
        condition: (m['condition'] ?? '') as String,
        level: (m['level'] ?? '') as String,
        score: score,
        max: max,
        flagged: flagged,
        ratio: ratio,
      );
    }).toList();
  }

  // ===== จัดรูปแบบวันที่เป็นไทย (พ.ศ.) =====
  String _fmtDate(Timestamp? ts) {
    if (ts == null) return 'กำลังบันทึก...';
    final d = ts.toDate();
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year + 543} · $hh:$mm น.';
  }
}

// ===== โมเดลย่อยของผลแต่ละด้าน (ใช้ภายในหน้านี้) =====
class _Item {
  final String instrument;
  final String condition;
  final String level;
  final int score;
  final int max;
  final bool flagged;
  final double ratio;

  const _Item({
    required this.instrument,
    required this.condition,
    required this.level,
    required this.score,
    required this.max,
    required this.flagged,
    required this.ratio,
  });

  // สี: ปกติ=เขียว, เสี่ยง=ส้ม/แดงตามสัดส่วนคะแนน
  Color get color {
    if (!flagged) return AppColors.green;
    return ratio >= 0.66 ? AppColors.red : AppColors.orange;
  }
}
