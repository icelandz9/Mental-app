import type { ReactNode } from 'react'
import { Mail, Phone, MapPin, LifeBuoy, Send } from 'lucide-react'

const infoItems = [
  { icon: Mail, label: 'อีเมล', value: 'hello@mindly.app' },
  { icon: Phone, label: 'โทรศัพท์', value: '+66 2 123 4567' },
  { icon: MapPin, label: 'ที่ตั้ง', value: 'กรุงเทพมหานคร ประเทศไทย' },
]

export default function Contact() {
  return (
    <section id="contact" className="mx-auto max-w-7xl px-6 py-24">
      <div className="mx-auto mb-14 max-w-2xl text-center">
        <p className="text-sm font-semibold uppercase tracking-[0.15em] text-sage">
          ติดต่อเรา
        </p>
        <h2 className="mt-4 text-4xl font-bold text-ink lg:text-5xl">
          เราพร้อมรับฟังคุณเสมอ
        </h2>
        <p className="mt-5 text-lg leading-relaxed text-muted">
          มีคำถามหรืออยากบอกอะไรกับเรา ทักมาได้ทุกเมื่อ ด้วยใจที่เปิดกว้าง
        </p>
      </div>

      <div className="grid gap-8 lg:grid-cols-2">
        {/* ซ้าย: ข้อมูลติดต่อ + ข้อความวิกฤต */}
        <div className="flex flex-col gap-6">
          <div className="rounded-3xl border border-earth/50 bg-cream-card p-8 shadow-lg shadow-sage/5">
            <h4 className="text-xl font-bold text-ink">ช่องทางติดต่อ</h4>
            <p className="mt-2 text-sm leading-relaxed text-muted">
              เราจะตอบกลับอย่างอบอุ่นและรวดเร็วที่สุดเท่าที่จะทำได้
            </p>

            <div className="mt-7 space-y-5">
              {infoItems.map(({ icon: Icon, label, value }) => (
                <div key={label} className="flex items-center gap-4">
                  <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-beige">
                    <Icon size={20} className="text-sage" strokeWidth={1.75} />
                  </span>
                  <div>
                    <p className="text-xs font-medium uppercase tracking-wide text-muted">
                      {label}
                    </p>
                    <p className="text-base font-semibold text-ink">{value}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* ข้อความสนับสนุนกรณีวิกฤต */}
          <div className="rounded-3xl border border-peach/60 bg-peach/10 p-6">
            <div className="flex items-start gap-4">
              <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-beige">
                <LifeBuoy size={20} className="text-sage" strokeWidth={1.75} />
              </span>
              <div>
                <h4 className="text-base font-bold text-ink">
                  หากคุณกำลังต้องการความช่วยเหลือเร่งด่วน
                </h4>
                <p className="mt-2 text-sm leading-relaxed text-muted">
                  หากคุณกำลังอยู่ในภาวะวิกฤตหรือมีความคิดทำร้ายตัวเอง
                  กรุณาติดต่อสายด่วนฉุกเฉินหรือสายด่วนช่วยเหลือในพื้นที่ของคุณทันที
                  (ในไทยโทร <span className="font-semibold text-ink">1323</span>{' '}
                  สายด่วนสุขภาพจิต ฟรี 24 ชม.) —
                  แอปนี้ไม่ใช่สิ่งทดแทนการดูแลในกรณีฉุกเฉิน คุณไม่ได้อยู่คนเดียว
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* ขวา: ฟอร์ม */}
        <div className="rounded-3xl border border-earth/50 bg-cream-card p-8 shadow-lg shadow-sage/5">
          <form
            className="space-y-5"
            onSubmit={(e) => e.preventDefault()}
            noValidate
          >
            <div className="grid gap-5 sm:grid-cols-2">
              <Field label="ชื่อของคุณ" htmlFor="name">
                <input
                  id="name"
                  type="text"
                  placeholder="ชื่อ"
                  className="w-full rounded-xl border border-earth bg-cream-card px-4 py-3 text-ink outline-none transition-colors placeholder:text-muted/60 focus:border-sage focus:ring-1 focus:ring-sage"
                />
              </Field>
              <Field label="อีเมล" htmlFor="email">
                <input
                  id="email"
                  type="email"
                  placeholder="you@email.com"
                  className="w-full rounded-xl border border-earth bg-cream-card px-4 py-3 text-ink outline-none transition-colors placeholder:text-muted/60 focus:border-sage focus:ring-1 focus:ring-sage"
                />
              </Field>
            </div>

            <Field label="หัวข้อ" htmlFor="subject">
              <input
                id="subject"
                type="text"
                placeholder="เราจะช่วยอะไรคุณได้บ้าง"
                className="w-full rounded-xl border border-earth bg-cream-card px-4 py-3 text-ink outline-none transition-colors placeholder:text-muted/60 focus:border-sage focus:ring-1 focus:ring-sage"
              />
            </Field>

            <Field label="ข้อความ" htmlFor="message">
              <textarea
                id="message"
                rows={5}
                placeholder="เขียนสิ่งที่อยู่ในใจคุณได้เลย…"
                className="w-full resize-none rounded-xl border border-earth bg-cream-card px-4 py-3 text-ink outline-none transition-colors placeholder:text-muted/60 focus:border-sage focus:ring-1 focus:ring-sage"
              />
            </Field>

            <button
              type="submit"
              className="group inline-flex w-full items-center justify-center gap-2 rounded-full bg-sage px-7 py-3.5 font-semibold text-white shadow-lg shadow-sage/20 transition-all duration-300 hover:scale-[1.02] hover:bg-sage-dark"
            >
              ส่งข้อความ
              <Send
                size={17}
                className="transition-transform duration-300 group-hover:translate-x-1"
              />
            </button>
          </form>
        </div>
      </div>
    </section>
  )
}

function Field({
  label,
  htmlFor,
  children,
}: {
  label: string
  htmlFor: string
  children: ReactNode
}) {
  return (
    <label htmlFor={htmlFor} className="block">
      <span className="mb-2 block text-sm font-medium text-ink">{label}</span>
      {children}
    </label>
  )
}