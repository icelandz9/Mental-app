import { Check } from 'lucide-react'

type Plan = {
  name: string
  price: string
  period?: string
  blurb: string
  features: string[]
  cta: string
  featured?: boolean
}

const plans: Plan[] = [
  {
    name: 'เริ่มต้น',
    price: 'ฟรี',
    blurb: 'การติดตามอารมณ์และการคัดกรองหลักฟรีตลอดไป',
    features: [
      'บันทึกอารมณ์รายวัน',
      'แบบประเมิน PHQ-9 พื้นฐาน',
      'แนวโน้มอารมณ์ราย 7 วัน',
      'การเตือนอย่างอ่อนโยน',
    ],
    cta: 'เริ่มใช้ฟรี',
  },
  {
    name: 'Plus',
    price: '$6',
    period: '/เดือน',
    blurb: 'เครื่องมือเพิ่มเติมเพื่อดูแลใจอย่างต่อเนื่อง',
    features: [
      'ทุกอย่างในแพ็กเริ่มต้น',
      'คลังแบบประเมินตนเองครบชุด',
      'ข้อมูลเชิงลึกและแนวโน้มไม่จำกัด',
      'แบบฝึกผ่อนคลายและสมุดบันทึก',
      'ส่งออกประวัติของคุณได้',
    ],
    cta: 'เลือก Plus',
    featured: true,
  },
  {
    name: 'Care+',
    price: '$12',
    period: '/เดือน',
    blurb: 'สำหรับผู้ที่ต้องการเนื้อหาแบบมีคำแนะนำเพิ่มเติม',
    features: [
      'ทุกอย่างในแพ็ก Plus',
      'เส้นทางการดูแลแบบมีคำแนะนำ',
      'แหล่งข้อมูลจากผู้เชี่ยวชาญ',
      'การทบทวนเชิงลึกรายสัปดาห์',
      'ความช่วยเหลือแบบให้ความสำคัญ',
    ],
    cta: 'เลือก Care+',
  },
]

export default function Pricing() {
  return (
    <section id="pricing" className="mx-auto max-w-7xl px-6 py-24">
      <div className="mx-auto max-w-2xl text-center">
        <p className="text-sm font-semibold uppercase tracking-[0.15em] text-sage">
          แพ็กเกจ
        </p>
        <h2 className="mt-4 text-4xl font-bold text-ink lg:text-5xl">
          เลือกในแบบที่อ่อนโยนกับคุณ
        </h2>
        <p className="mt-5 text-lg leading-relaxed text-muted">
          ไม่มีแรงกดดัน เริ่มฟรีได้เสมอ และอยู่กับเราในจังหวะที่คุณพร้อม
        </p>
      </div>

      <div className="mt-16 grid grid-cols-1 items-start gap-8 lg:grid-cols-3">
        {plans.map((plan) => (
          <div
            key={plan.name}
            className={`relative rounded-3xl p-8 transition-all duration-300 ${
              plan.featured
                ? 'border-2 border-sage bg-cream-card shadow-2xl shadow-sage/15 lg:-translate-y-4'
                : 'border border-earth/50 bg-cream-card shadow-lg shadow-sage/5 hover:-translate-y-1'
            }`}
          >
            {plan.featured && (
              <span className="absolute -top-4 left-1/2 -translate-x-1/2 rounded-full bg-sage px-5 py-1.5 text-xs font-semibold uppercase tracking-wide text-white shadow-sm shadow-sage/30">
                เป็นที่รักที่สุด
              </span>
            )}

            <h3 className="text-xl font-bold text-ink">{plan.name}</h3>
            <div className="mt-4 flex items-end gap-1">
              <span className="text-5xl font-bold text-ink">{plan.price}</span>
              {plan.period && (
                <span className="mb-1.5 text-base text-muted">
                  {plan.period}
                </span>
              )}
            </div>
            <p className="mt-3 text-sm leading-relaxed text-muted">
              {plan.blurb}
            </p>

            <ul className="mt-7 space-y-3.5">
              {plan.features.map((f) => (
                <li key={f} className="flex items-start gap-3">
                  <span className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-sage/15">
                    <Check size={13} className="text-sage" strokeWidth={3} />
                  </span>
                  <span className="text-sm text-ink/90">{f}</span>
                </li>
              ))}
            </ul>

            <a
              href="#contact"
              className={`mt-8 inline-flex w-full items-center justify-center rounded-full px-6 py-3.5 font-semibold transition-all duration-300 hover:scale-[1.03] ${
                plan.featured
                  ? 'bg-sage text-white shadow-lg shadow-sage/20 hover:bg-sage-dark'
                  : 'border border-sage/60 text-sage hover:bg-sage/5'
              }`}
            >
              {plan.cta}
            </a>
          </div>
        ))}
      </div>
    </section>
  )
}