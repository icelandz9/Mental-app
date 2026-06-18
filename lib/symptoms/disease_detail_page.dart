
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

final Map<String, Map<String, String>> diseaseData = {
  "PHQ-9": {
    "อาการ":
        "รู้สึกเศร้าเกือบทุกวัน เบื่อหรือไม่สนใจสิ่งที่เคยชอบ นอนมากหรือน้อยผิดปกติ อ่อนเพลีย สมาธิลดลง รู้สึกไร้ค่า",
    "สาเหตุ":
        "เกิดจากหลายปัจจัยร่วมกัน เช่น พันธุกรรม ความเครียด เหตุการณ์กระทบจิตใจ และความผิดปกติของสารเคมีในสมอง",
    "การรักษา":
        "จิตบำบัด การปรับพฤติกรรม การดูแลสุขภาพ และอาจใช้ยาต้านเศร้าตามคำแนะนำของแพทย์",
  },

  "GAD-7": {
    "อาการ":
        "กังวลมากเกินไป ควบคุมความกังวลได้ยาก กระสับกระส่าย หงุดหงิด เหนื่อยง่าย นอนไม่หลับ",
    "สาเหตุ":
        "พันธุกรรม ความเครียดสะสม การทำงานของสารสื่อประสาทในสมอง และปัจจัยด้านสิ่งแวดล้อม",
    "การรักษา":
        "จิตบำบัด ฝึกผ่อนคลาย ฝึกสติ ออกกำลังกาย และอาจใช้ยาตามคำแนะนำของแพทย์",
  },

  "ASRS": {
    "อาการ":
        "สมาธิสั้น วอกแวกง่าย ลืมบ่อย จัดการเวลาไม่ดี ทำงานไม่เสร็จตามแผน หุนหันพลันแล่น",
    "สาเหตุ":
        "เกี่ยวข้องกับพันธุกรรมและการทำงานของสมองส่วนที่ควบคุมสมาธิและการวางแผน",
    "การรักษา":
        "การฝึกทักษะการจัดการตนเอง การปรับพฤติกรรม และยารักษา ADHD ตามคำแนะนำของแพทย์",
  },

  "OCI-R": {
    "อาการ":
        "มีความคิดย้ำคิดย้ำทำ รู้สึกกังวลจนต้องทำพฤติกรรมบางอย่างซ้ำ ๆ เช่น ล้างมือ ตรวจประตู หรือจัดของ",
    "สาเหตุ":
        "ปัจจัยทางพันธุกรรม ความเครียด และความผิดปกติของวงจรการทำงานในสมอง",
    "การรักษา":
        "จิตบำบัดแบบ CBT โดยเฉพาะ ERP และอาจใช้ยาต้านเศร้ากลุ่ม SSRI",
  },

  "MDQ": {
    "อาการ":
        "อารมณ์ดีผิดปกติหรือหงุดหงิดมาก พลังงานสูง นอนน้อยแต่ไม่ง่วง พูดมาก คิดเร็ว และอาจมีช่วงซึมเศร้าสลับกัน",
    "สาเหตุ":
        "พันธุกรรม ความไม่สมดุลของสารเคมีในสมอง และปัจจัยด้านสิ่งแวดล้อม",
    "การรักษา":
        "ยาควบคุมอารมณ์ ยาต้านโรคจิตบางชนิด จิตบำบัด และการติดตามอาการอย่างต่อเนื่อง",
  },

  "AQ / RAADS-R": {
    "อาการ":
        "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ หรือไวต่อสิ่งเร้าบางอย่าง",
    "สาเหตุ":
        "เกี่ยวข้องกับพัฒนาการของระบบประสาทและปัจจัยทางพันธุกรรม",
    "การรักษา":
        "ไม่มีการรักษาให้หายขาด แต่สามารถพัฒนาทักษะการสื่อสาร การเรียนรู้ และการใช้ชีวิตผ่านการบำบัดและการสนับสนุนที่เหมาะสม",
  },

  "PCL-5": {
    "อาการ":
        "ฝันร้ายหรือย้อนนึกถึงเหตุการณ์รุนแรง หลีกเลี่ยงสิ่งที่เกี่ยวข้องกับเหตุการณ์ ตกใจง่าย นอนไม่หลับ และวิตกกังวล",
    "สาเหตุ":
        "เกิดหลังเผชิญเหตุการณ์กระทบกระเทือนจิตใจอย่างรุนแรง เช่น อุบัติเหตุ ภัยพิบัติ หรือความรุนแรง",
    "การรักษา":
        "จิตบำบัดเฉพาะทาง เช่น Trauma-focused CBT หรือ EMDR และอาจใช้ยาตามคำแนะนำของแพทย์",
  },

  "PSS": {
    "อาการ":
        "รู้สึกเครียด กดดัน เหนื่อยล้า หงุดหงิด สมาธิลดลง นอนหลับยาก",
    "สาเหตุ":
        "ปัญหาการเรียน การทำงาน การเงิน ความสัมพันธ์ หรือเหตุการณ์สำคัญในชีวิต",
    "การรักษา":
        "จัดการความเครียด พักผ่อนให้เพียงพอ ออกกำลังกาย ฝึกผ่อนคลาย และขอคำปรึกษาจากผู้เชี่ยวชาญเมื่อจำเป็น",
  },
};


class DiseaseDetailPage extends StatelessWidget {
  final String diseaseName;
  final String diseaseTitle;

  const DiseaseDetailPage({
    super.key,
    required this.diseaseName,
    required this.diseaseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final data = diseaseData[diseaseName]!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          diseaseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.bg],
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (diseaseTitle.isNotEmpty)
                  _headerCard(),
                const SizedBox(height: 20),
                _infoCard(
                  context,
                  title: "อาการ",
                  content: data["อาการ"]!,
                  icon: Icons.monitor_heart_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                _infoCard(
                  context,
                  title: "สาเหตุ",
                  content: data["สาเหตุ"]!,
                  icon: Icons.search_rounded,
                  color: AppColors.peach,
                ),
                const SizedBox(height: 16),
                _infoCard(
                  context,
                  title: "การรักษา",
                  content: data["การรักษา"]!,
                  icon: Icons.healing_outlined,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Text(
        diseaseTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          height: 1.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showDetail(context, title, content, icon, color),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("ปิด", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}