import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import {
  getAuth,
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
} from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import {
  getFirestore,
  collection,
  getDocs,
  collectionGroup,
} from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";

// ===== Firebase config (web) ของโปรเจกต์ hahaha-13315 =====
// ค่าเหล่านี้เป็น public config ปกติ (ความปลอดภัยอยู่ที่ Firestore Rules)
const firebaseConfig = {
  apiKey: "AIzaSyAb9gzEwQLwWhyiuoJbbPr2j-ZD6_00L3g",
  authDomain: "hahaha-13315.firebaseapp.com",
  projectId: "hahaha-13315",
  storageBucket: "hahaha-13315.firebasestorage.app",
  messagingSenderId: "1097152257298",
  appId: "1:1097152257298:web:b0ae700de71a7d7b5367cb",
  measurementId: "G-EK1547J1CB",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

const $ = (id) => document.getElementById(id);
let allUsers = []; // เก็บข้อมูลที่ดึงมาไว้สำหรับค้นหา/ส่งออก

// ---------- สลับหน้า ----------
function show(view) {
  $("loading").style.display = "none";
  $("loginView").style.display = view === "login" ? "flex" : "none";
  $("dashView").style.display = view === "dash" ? "block" : "none";
}

// ---------- ตรวจสถานะล็อกอิน ----------
onAuthStateChanged(auth, async (user) => {
  if (!user) {
    show("login");
    return;
  }
  $("whoami").textContent = user.email;
  show("dash");
  await loadData();
});

// ---------- Login ----------
$("loginForm").addEventListener("submit", async (e) => {
  e.preventDefault();
  const btn = $("loginBtn");
  const err = $("loginError");
  err.style.display = "none";
  btn.disabled = true;
  btn.textContent = "กำลังเข้าสู่ระบบ...";
  try {
    await signInWithEmailAndPassword(
      auth,
      $("email").value.trim(),
      $("password").value.trim(),
    );
  } catch (ex) {
    err.textContent = "เข้าสู่ระบบไม่สำเร็จ: อีเมลหรือรหัสผ่านไม่ถูกต้อง";
    err.style.display = "block";
  } finally {
    btn.disabled = false;
    btn.textContent = "เข้าสู่ระบบ";
  }
});

// ---------- ปุ่มตา เปิด/ปิดรหัสผ่าน ----------
const SVG_ATTR =
  'viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"';
// ไอคอนตาเปิด (รหัสกำลังโชว์)
const EYE = `<svg ${SVG_ATTR}><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>`;
// ไอคอนตาขีด (รหัสถูกซ่อน)
const EYE_OFF = `<svg ${SVG_ATTR}><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>`;

$("pwToggle").addEventListener("click", () => {
  const pw = $("password");
  const showing = pw.type === "password";
  pw.type = showing ? "text" : "password";
  $("pwToggle").innerHTML = showing ? EYE : EYE_OFF;
});

$("logoutBtn").addEventListener("click", () => signOut(auth));

// ---------- ดึงข้อมูลทั้งหมด ----------
async function loadData() {
  $("list").innerHTML =
    `<div class="empty"><div class="spinner" style="margin:0 auto 12px"></div>กำลังดึงข้อมูล...</div>`;
  try {
    // 1) โปรไฟล์ผู้ใช้ทุกคน
    const usersSnap = await getDocs(collection(db, "users"));
    const profiles = {};
    usersSnap.forEach((d) => (profiles[d.id] = d.data()));

    // 2) ผลทดสอบทุกคน (collectionGroup)
    const resSnap = await getDocs(collectionGroup(db, "results"));
    const resultsByUid = {};
    resSnap.forEach((d) => {
      const uid = d.ref.parent.parent.id; // users/{uid}/results/{id}
      (resultsByUid[uid] ||= []).push({ id: d.id, ...d.data() });
    });

    // 3) รวมข้อมูลรายคน
    const uids = new Set([
      ...Object.keys(profiles),
      ...Object.keys(resultsByUid),
    ]);
    allUsers = [...uids].map((uid) => {
      const results = (resultsByUid[uid] || []).sort(
        (a, b) => (b.createdAt?.seconds || 0) - (a.createdAt?.seconds || 0),
      );
      return {
        uid,
        profile: profiles[uid] || {},
        results,
        latest: results[0] || null,
      };
    });
    // เรียงคนที่มีความเสี่ยงขึ้นก่อน แล้วตามด้วยประเมินล่าสุด
    allUsers.sort((a, b) => {
      const fa = a.latest?.flaggedCount || 0,
        fb = b.latest?.flaggedCount || 0;
      if (fb !== fa) return fb - fa;
      return (
        (b.latest?.createdAt?.seconds || 0) -
        (a.latest?.createdAt?.seconds || 0)
      );
    });

    renderStats();
    renderList(allUsers);
  } catch (ex) {
    console.error(ex);
    const denied =
      String(ex).includes("permission") || ex.code === "permission-denied";
    $("list").innerHTML =
      `<div class="empty"><div class="ico">${denied ? "🔒" : "⚠️"}</div>
      <b>${denied ? "บัญชีนี้ไม่มีสิทธิ์แอดมิน" : "ดึงข้อมูลไม่สำเร็จ"}</b>
      <p style="margin-top:6px">${
        denied
          ? "ตรวจสอบว่าได้ตั้ง Firestore Rules และใส่อีเมลนี้เป็นแอดมินแล้ว"
          : "เกิดข้อผิดพลาด ลองรีเฟรชอีกครั้ง"
      }</p></div>`;
  }
}

// ---------- สถิติ ----------
function renderStats() {
  $("stUsers").textContent = allUsers.length;
  $("stAssess").textContent = allUsers.reduce(
    (s, u) => s + u.results.length,
    0,
  );
  $("stFlagged").textContent = allUsers.filter(
    (u) => (u.latest?.flaggedCount || 0) > 0,
  ).length;
}

// ---------- รายการผู้ใช้ ----------
function renderList(users) {
  if (!users.length) {
    $("list").innerHTML =
      `<div class="empty"><div class="ico">📭</div>ยังไม่มีข้อมูลผู้ใช้</div>`;
    return;
  }
  $("list").innerHTML = users.map((u, i) => cardHtml(u, i)).join("");
  // ผูก event เปิด/ปิดการ์ด
  document.querySelectorAll(".card-head").forEach((h) => {
    h.addEventListener("click", () => h.parentElement.classList.toggle("open"));
  });
}

function cardHtml(u, idx) {
  const p = u.profile;
  const name = esc(p.name) || "ไม่ระบุชื่อ";
  const initial = (name[0] || "?").toUpperCase();
  const fc = u.latest?.flaggedCount || 0;
  const hasResult = !!u.latest;
  const color = !hasResult
    ? "var(--muted)"
    : fc === 0
      ? "var(--green)"
      : fc <= 2
        ? "var(--orange)"
        : "var(--red)";
  const badgeBg = !hasResult
    ? "#EEF1FB"
    : fc === 0
      ? "#E6F4EC"
      : fc <= 2
        ? "#FDF0DC"
        : "#FBE3E3";
  const badgeTxt = !hasResult
    ? "ยังไม่ประเมิน"
    : fc === 0
      ? "ปกติ"
      : `${fc} ด้านควรใส่ใจ`;

  const metaParts = [];
  if (p.gender) metaParts.push(esc(p.gender));
  if (p.age) metaParts.push("อายุ " + esc(p.age));
  if (p.phone) metaParts.push("📞 " + esc(p.phone));
  const meta = metaParts.join("  ·  ") || "—";

  return `
  <div class="card" id="card${idx}">
    <div class="card-head">
      <div class="avatar">${initial}</div>
      <div style="flex:1;min-width:0">
        <div class="name">${name}</div>
        <div class="meta">${meta}</div>
      </div>
      <span class="badge" style="background:${badgeBg};color:${color}">${badgeTxt}</span>
      <span class="chev">›</span>
    </div>
    <div class="details">
      <div class="info-grid">
        <div><span class="k">เพศ:</span> ${esc(p.gender) || "—"}</div>
        <div><span class="k">อายุ:</span> ${esc(p.age) || "—"}</div>
        <div><span class="k">วันเกิด:</span> ${esc(p.birthday) || "—"}</div>
        <div><span class="k">เบอร์โทร:</span> ${esc(p.phone) || "—"}</div>
        <div style="grid-column:1/-1"><span class="k">โรคประจำตัว:</span> ${esc(p.underlyingDisease) || "—"}</div>
        <div style="grid-column:1/-1"><span class="k">รหัสผู้ใช้:</span> <span style="font-size:11px;color:var(--muted)">${u.uid}</span></div>
      </div>
      <div style="font-weight:700;font-size:14px;margin-bottom:8px">ประวัติการประเมิน (${u.results.length} ครั้ง)</div>
      ${u.results.length ? u.results.map(assessmentHtml).join("") : '<div style="color:var(--muted);font-size:13px">ยังไม่มีผลการประเมิน</div>'}
    </div>
  </div>`;
}

function assessmentHtml(r) {
  const items = Array.isArray(r.results) ? r.results : [];
  const warn = r.selfHarmRisk
    ? `<div class="warn">⚠️ มีสัญญาณเสี่ยงทำร้ายตัวเอง</div>`
    : "";
  const conds = items
    .map((it) => {
      const c = it.flagged ? "var(--red)" : "var(--green)";
      return `<div class="cond"><span class="dot" style="background:${c}"></span>
      ${esc(it.condition)} (${esc(it.instrument)})
      <span class="score" style="color:${c}">${it.score}/${it.max} · ${esc(it.level)}</span></div>`;
    })
    .join("");
  return `<div class="assessment"><div class="date">📅 ${fmtDate(r.createdAt)}</div>${warn}${conds}</div>`;
}

// ---------- ค้นหา ----------
$("search").addEventListener("input", (e) => {
  const q = e.target.value.trim().toLowerCase();
  const filtered = !q
    ? allUsers
    : allUsers.filter((u) => {
        const p = u.profile;
        return (
          (p.name || "").toLowerCase().includes(q) ||
          (p.phone || "").includes(q)
        );
      });
  renderList(filtered);
});

// ---------- ส่งออก CSV ----------
$("exportBtn").addEventListener("click", () => {
  const rows = [
    [
      "ชื่อ",
      "เพศ",
      "อายุ",
      "เบอร์โทร",
      "โรคประจำตัว",
      "วันที่ประเมิน",
      "ด้านที่ควรใส่ใจ",
      "เสี่ยงทำร้ายตัวเอง",
      "รายละเอียด",
    ],
  ];
  allUsers.forEach((u) => {
    const p = u.profile;
    if (!u.results.length) {
      rows.push([
        p.name || "",
        p.gender || "",
        p.age || "",
        p.phone || "",
        p.underlyingDisease || "",
        "ยังไม่ประเมิน",
        "",
        "",
        "",
      ]);
      return;
    }
    u.results.forEach((r) => {
      const detail = (r.results || [])
        .map((it) => `${it.instrument}:${it.score}/${it.max}(${it.level})`)
        .join("; ");
      rows.push([
        p.name || "",
        p.gender || "",
        p.age || "",
        p.phone || "",
        p.underlyingDisease || "",
        fmtDate(r.createdAt),
        r.flaggedCount || 0,
        r.selfHarmRisk ? "ใช่" : "ไม่",
        detail,
      ]);
    });
  });
  const csv =
    "﻿" +
    rows
      .map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(","))
      .join("\n");
  const blob = new Blob([csv], { type: "text/csv;charset=utf-8" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = `mindcare-results-${new Date().toISOString().slice(0, 10)}.csv`;
  a.click();
});

// ---------- ตัวช่วย ----------
function esc(s) {
  if (s == null) return "";
  return String(s).replace(
    /[&<>"']/g,
    (m) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        m
      ],
  );
}
function fmtDate(ts) {
  if (!ts) return "กำลังบันทึก...";
  const d = ts.toDate ? ts.toDate() : new Date(ts);
  const months = [
    "ม.ค.",
    "ก.พ.",
    "มี.ค.",
    "เม.ย.",
    "พ.ค.",
    "มิ.ย.",
    "ก.ค.",
    "ส.ค.",
    "ก.ย.",
    "ต.ค.",
    "พ.ย.",
    "ธ.ค.",
  ];
  const hh = String(d.getHours()).padStart(2, "0");
  const mm = String(d.getMinutes()).padStart(2, "0");
  return `${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear() + 543} · ${hh}:${mm} น.`;
}
