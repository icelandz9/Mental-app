import { useState } from 'react'
import { Menu, X } from 'lucide-react'
import Logo from './Logo'

const links = [
  { label: 'Home', href: '#home', active: true },
  { label: 'About', href: '#about' },
  { label: 'Features', href: '#features' },
  { label: 'Pricing', href: '#pricing' },
  { label: 'Contact', href: '#contact' },
]

export default function Navbar() {
  const [open, setOpen] = useState(false)

  return (
    <nav className="absolute left-0 right-0 top-0 z-50">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-6">
        {/* แบรนด์ */}
        <a href="#home" className="flex items-center gap-3">
          <Logo />
          <span className="text-xl font-bold tracking-tight text-ink">
            MINDLY
          </span>
        </a>

        {/* ลิงก์ตรงกลาง (เดสก์ท็อป) */}
        <div className="hidden items-center gap-9 md:flex">
          {links.map((link) => (
            <a
              key={link.label}
              href={link.href}
              className={`relative text-sm font-medium transition-colors ${
                link.active
                  ? 'text-ink'
                  : 'text-muted hover:text-ink'
              }`}
            >
              {link.label}
              {link.active && (
                <span className="absolute -bottom-2 left-0 h-0.5 w-full rounded-full bg-sage" />
              )}
            </a>
          ))}
        </div>

        {/* CTA + ปุ่มเมนูมือถือ */}
        <div className="flex items-center gap-3">
          <a
            href="#pricing"
            className="hidden rounded-full bg-sage px-6 py-2.5 text-sm font-semibold text-white shadow-sm shadow-sage/30 transition-all duration-300 hover:scale-[1.03] hover:bg-sage-dark sm:inline-flex"
          >
            Start Free
          </a>
          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            aria-label={open ? 'ปิดเมนู' : 'เปิดเมนู'}
            aria-expanded={open}
            className="inline-flex h-10 w-10 items-center justify-center rounded-full border border-earth/60 text-ink transition-colors hover:bg-beige md:hidden"
          >
            {open ? <X size={20} /> : <Menu size={20} />}
          </button>
        </div>
      </div>

      {/* เมนูมือถือ */}
      {open && (
        <div className="mx-6 mb-2 rounded-3xl border border-earth/50 bg-cream-card/95 p-4 shadow-lg shadow-sage/10 backdrop-blur md:hidden">
          <div className="flex flex-col gap-1">
            {links.map((link) => (
              <a
                key={link.label}
                href={link.href}
                onClick={() => setOpen(false)}
                className={`rounded-2xl px-4 py-3 text-sm font-medium transition-colors ${
                  link.active
                    ? 'bg-beige text-ink'
                    : 'text-muted hover:bg-beige hover:text-ink'
                }`}
              >
                {link.label}
              </a>
            ))}
            <a
              href="#pricing"
              onClick={() => setOpen(false)}
              className="mt-2 rounded-full bg-sage px-6 py-3 text-center text-sm font-semibold text-white transition-colors hover:bg-sage-dark"
            >
              Start Free
            </a>
          </div>
        </div>
      )}
    </nav>
  )
}