import { ShieldCheck, HeartHandshake, Lock, ArrowRight } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'

type Point = {
  icon: LucideIcon
  title: string
  desc: string
}

const points: Point[] = [
  {
    icon: ShieldCheck,
    title: 'เครื่องมือคัดกรองที่ผ่านการตรวจสอบ',
    desc: 'อ้างอิงแบบประเมินมาตรฐานอย่าง PHQ-9 ที่ได้รับการยอมรับ',
  },
  {
    icon: HeartHandshake,
    title: 'ติดตามความก้าวหน้าอย่างอ่อนโยน',
    desc: 'ค่อย ๆ เห็นการเปลี่ยนแปลงของหัวใจ โดยไม่กดดันตัวเอง',
  },
  {
    icon: Lock,
    title: 'ข้อมูลของคุณเป็นส่วนตัว',
    desc: 'ทุกบันทึกเป็นความลับ ปลอดภัย และอยู่ในมือคุณเสมอ',
  },
]

export default function About() {
  return (
    <section id="about" className="mx-auto max-w-7xl px-6 py-24">
      <div className="grid items-center gap-16 lg:grid-cols-2">
        {/* คอลัมน์ซ้าย: การ์ดพร้อมรายการย่อย */}
        <div className="relative">
          {/* เกรเดียนต์เรืองนุ่มหมุนด้านหลัง */}
          <div
            aria-hidden="true"
            className="absolute -inset-6 -z-10 rotate-6 rounded-[2.5rem] bg-gradient-to-tr from-sage/20 to-peach/10 blur-lg"
          />
          <div className="rounded-3xl border border-earth/50 bg-cream-card p-8 shadow-lg shadow-sage/10 sm:p-10">
            <div className="space-y-7">
              {points.map(({ icon: Icon, title, desc }) => (
                <div key={title} className="flex items-start gap-5">
                  <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-beige">
                    <Icon size={22} className="text-sage" strokeWidth={1.75} />
                  </div>
                  <div>
                    <h4 className="text-lg font-bold text-ink">{title}</h4>
                    <p className="mt-1 text-sm leading-relaxed text-muted">
                      {desc}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* คอลัมน์ขวา: เนื้อหา */}
        <div>
          <p className="text-sm font-semibold uppercase tracking-[0.15em] text-sage">
            เกี่ยวกับเรา
          </p>
          <h2 className="mt-4 text-4xl font-bold text-ink lg:text-5xl">
            อยู่เคียงข้างคุณ ทีละวัน
          </h2>
          <p className="mt-6 text-lg leading-relaxed text-muted">
            MINDLY ออกแบบด้วยความเห็นอกเห็นใจและอ้างอิงหลักฐานเชิงประจักษ์
            เราเชื่อว่าการดูแลใจไม่จำเป็นต้องน่ากลัว เราจึงสร้างพื้นที่ที่อ่อนโยน
            ให้คุณได้หยุดพัก รับฟังตัวเอง และเติบโตอย่างค่อยเป็นค่อยไป
          </p>
          <p className="mt-4 text-lg leading-relaxed text-muted">
            MINDLY เป็นเพื่อนคู่ใจเชิงสนับสนุน
            ไม่ใช่สิ่งทดแทนการดูแลจากผู้เชี่ยวชาญ
            หากคุณต้องการความช่วยเหลือ การขอความช่วยเหลือคือความเข้มแข็งเสมอ
          </p>
          <a
            href="#how-it-works"
            className="group mt-8 inline-flex items-center gap-2 rounded-full border border-sage/60 px-7 py-3.5 font-semibold text-sage transition-all duration-300 hover:scale-[1.03] hover:bg-sage/5"
          >
            ทำความรู้จักเรามากขึ้น
            <ArrowRight
              size={18}
              className="transition-transform duration-300 group-hover:translate-x-1"
            />
          </a>
        </div>
      </div>
    </section>
  )
}