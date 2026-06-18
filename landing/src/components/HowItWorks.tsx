import {
  Sun,
  TrendingUp,
  Bell,
  ClipboardList,
  Wind,
  BookOpen,
  ArrowRight,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'

type Step = {
  icon: LucideIcon
  title: string
  desc: string
}

const steps: Step[] = [
  {
    icon: Sun,
    title: 'เช็คอินรายวัน',
    desc: 'ใช้เวลาเพียงไม่กี่นาทีในแต่ละวัน เพื่อทักทายและรับฟังหัวใจของคุณ',
  },
  {
    icon: TrendingUp,
    title: 'ข้อมูลเชิงลึกและแนวโน้มอารมณ์',
    desc: 'เห็นภาพรวมความรู้สึกของคุณเมื่อเวลาผ่านไป เข้าใจตัวเองได้ชัดเจนขึ้น',
  },
  {
    icon: Bell,
    title: 'การเตือนอย่างอ่อนโยน',
    desc: 'คำเตือนนุ่ม ๆ ที่ชวนคุณกลับมาดูแลใจ โดยไม่กดดันหรือเร่งเร้า',
  },
  {
    icon: ClipboardList,
    title: 'คลังแบบประเมินตนเอง',
    desc: 'แบบคัดกรองที่ผ่านการตรวจสอบ ช่วยให้คุณทำความเข้าใจสภาวะใจของตัวเอง',
  },
  {
    icon: Wind,
    title: 'แบบฝึกผ่อนคลาย',
    desc: 'การหายใจและการฝึกสติแบบสั้น ๆ ที่พาคุณกลับสู่ความสงบ',
  },
  {
    icon: BookOpen,
    title: 'สมุดบันทึกการทบทวน',
    desc: 'พื้นที่ปลอดภัยสำหรับเขียนระบายและสะท้อนความคิดอย่างเป็นส่วนตัว',
  },
]

export default function HowItWorks() {
  return (
    <section id="how-it-works" className="bg-beige">
      <div className="mx-auto max-w-7xl px-6 py-24">
        <div className="mx-auto max-w-2xl text-center">
          <p className="text-sm font-semibold uppercase tracking-[0.15em] text-sage">
            วิธีใช้งาน
          </p>
          <h2 className="mt-4 text-4xl font-bold text-ink lg:text-5xl">
            เครื่องมือเล็ก ๆ ที่อยู่ข้างใจคุณ
          </h2>
          <p className="mt-5 text-lg leading-relaxed text-muted">
            ทุกฟีเจอร์ออกแบบมาให้เรียบง่าย อบอุ่น และใช้ได้ในจังหวะที่คุณสบายใจ
          </p>
        </div>

        <div className="mt-14 grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-3">
          {steps.map(({ icon: Icon, title, desc }) => (
            <div
              key={title}
              className="group relative overflow-hidden rounded-3xl border border-earth/50 bg-cream-card p-8 transition-all duration-300 hover:border-sage/50 hover:shadow-lg hover:shadow-sage/10"
            >
              {/* แสงเรืองนุ่มมุมขวาบน */}
              <div
                aria-hidden="true"
                className="pointer-events-none absolute -right-10 -top-10 h-32 w-32 rounded-full bg-sage/5 opacity-0 blur-3xl transition-opacity duration-500 group-hover:opacity-100"
              />

              <div className="relative">
                <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-beige transition-transform duration-300 group-hover:-translate-y-1 group-hover:scale-110">
                  <Icon size={26} className="text-sage" strokeWidth={1.75} />
                </div>
                <h4 className="mt-5 text-xl font-bold text-ink">{title}</h4>
                <p className="mt-3 text-sm leading-relaxed text-muted">{desc}</p>

                <div className="mt-6 inline-flex items-center gap-1.5 text-sm font-semibold text-sage">
                  ดูเพิ่มเติม
                  <ArrowRight
                    size={16}
                    className="transition-transform duration-300 group-hover:translate-x-2"
                  />
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}