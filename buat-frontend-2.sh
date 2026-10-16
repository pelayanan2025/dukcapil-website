#!/usr/bin/env bash

echo "Membangun Frontend Tahap 2 (User & Admin Dashboard)..."

cd frontend

# 1. Komponen Layout & Sidebar
cat > src/components/Sidebar.jsx <<'EOF'
import React from "react";
import { NavLink } from "react-router-dom";

export default function Sidebar({ title, items }) {
  return (
    <aside className="w-64 min-h-[80vh] border-r bg-white p-4">
      <h2 className="font-extrabold text-lg mb-6">{title}</h2>
      <nav className="grid gap-2">
        {items.map((it) => (
          <NavLink key={it.to} to={it.to} className={({ isActive }) => 
            `px-4 py-3 rounded-xl font-bold text-sm ${isActive ? "bg-primary-600 text-white" : "text-gray-600 hover:bg-gray-100"}`
          }>
            {it.label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
EOF

cat > src/components/DashboardLayout.jsx <<'EOF'
import React from "react";
import Sidebar from "./Sidebar";

export default function DashboardLayout({ title, sidebarItems, children }) {
  return (
    <div className="flex gap-6 mt-4">
      <Sidebar title={title} items={sidebarItems} />
      <div className="flex-1 bg-white p-6 border rounded-2xl shadow-sm">
        {children}
      </div>
    </div>
  );
}
EOF

cat > src/components/StatusBadge.jsx <<'EOF'
import React from "react";
export default function StatusBadge({ status }) {
  const colors = {
    Menunggu: "bg-gray-200 text-gray-800",
    Diproses: "bg-blue-100 text-blue-700",
    Verifikasi: "bg-yellow-100 text-yellow-700",
    Disetujui: "bg-green-100 text-green-700",
    Ditolak: "bg-red-100 text-red-700",
    Selesai: "bg-emerald-100 text-emerald-800"
  };
  return <span className={`px-3 py-1 rounded-full text-xs font-bold ${colors[status] || colors.Menunggu}`}>{status}</span>;
}
EOF

# 2. Halaman User
cat > src/pages/user/UserDashboard.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import DashboardLayout from "../../components/DashboardLayout";
import StatusBadge from "../../components/StatusBadge";
import { api } from "../../utils/api";

export default function UserDashboard() {
  const [pengajuan, setPengajuan] = useState([]);
  
  useEffect(() => {
    api.get("/pengajuan").then(res => setPengajuan(res.data.data)).catch(console.error);
  }, []);

  const sidebar = [
    { label: "Dashboard", to: "/user" },
    { label: "Ajukan Layanan", to: "/user/ajukan" }
  ];

  return (
    <DashboardLayout title="Menu User" sidebarItems={sidebar}>
      <h1 className="text-2xl font-extrabold mb-4">Riwayat Pengajuan Saya</h1>
      <table className="w-full text-left border-collapse">
        <thead>
          <tr className="border-b"><th className="py-2">No</th><th className="py-2">Layanan</th><th className="py-2">Status</th></tr>
        </thead>
        <tbody>
          {pengajuan.map((p) => (
            <tr key={p.id} className="border-b">
              <td className="py-3">{p.no_pengajuan}</td>
              <td className="py-3">{p?.layanan?.nama_layanan || "-"}</td>
              <td className="py-3"><StatusBadge status={p.status} /></td>
            </tr>
          ))}
          {pengajuan.length === 0 && <tr><td colSpan="3" className="py-4 text-center">Belum ada pengajuan.</td></tr>}
        </tbody>
      </table>
    </DashboardLayout>
  );
}
EOF

cat > src/pages/user/AjukanLayanan.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import Swal from "sweetalert2";
import DashboardLayout from "../../components/DashboardLayout";
import { api } from "../../utils/api";

export default function AjukanLayanan() {
  const [layanan, setLayanan] = useState([]);
  const [form, setForm] = useState({ layanan_id: "", catatan_pemohon: "" });

  useEffect(() => {
    api.get("/layanan").then(res => setLayanan(res.data.data)).catch(console.error);
  }, []);

  const onSubmit = async (e) => {
    e.preventDefault();
    try {
      const fd = new FormData();
      fd.append("layanan_id", form.layanan_id);
      fd.append("catatan_pemohon", form.catatan_pemohon);
      await api.post("/pengajuan", fd);
      Swal.fire("Sukses", "Pengajuan berhasil dikirim!", "success");
      setForm({ layanan_id: "", catatan_pemohon: "" });
    } catch (err) { Swal.fire("Error", "Gagal mengirim pengajuan", "error"); }
  };

  const sidebar = [{ label: "Dashboard", to: "/user" }, { label: "Ajukan Layanan", to: "/user/ajukan" }];

  return (
    <DashboardLayout title="Menu User" sidebarItems={sidebar}>
      <h1 className="text-2xl font-extrabold mb-4">Form Ajukan Layanan</h1>
      <form onSubmit={onSubmit} className="grid gap-4 max-w-lg">
        <select value={form.layanan_id} onChange={e => setForm({...form, layanan_id: e.target.value})} className="border p-3 rounded-xl" required>
          <option value="">-- Pilih Layanan --</option>
          {layanan.map(l => <option key={l.id} value={l.id}>{l.nama_layanan}</option>)}
        </select>
        <textarea placeholder="Catatan Pemohon (opsional)" value={form.catatan_pemohon} onChange={e => setForm({...form, catatan_pemohon: e.target.value})} className="border p-3 rounded-xl rows-3"></textarea>
        <button className="bg-primary-600 text-white font-bold py-3 rounded-xl">Kirim Pengajuan</button>
      </form>
    </DashboardLayout>
  );
}
EOF

# 3. Halaman Admin
cat > src/pages/admin/AdminDashboard.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import { Bar } from "react-chartjs-2";
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Tooltip } from "chart.js";
import DashboardLayout from "../../components/DashboardLayout";
import { api } from "../../utils/api";

ChartJS.register(CategoryScale, LinearScale, BarElement, Tooltip);

export default function AdminDashboard() {
  const [stats, setStats] = useState({});
  const [chart, setChart] = useState([]);

  useEffect(() => {
    api.get("/dashboard/stats").then(res => setStats(res.data.data)).catch(console.error);
    api.get("/dashboard/chart-data").then(res => setChart(res.data.data.pengajuanPerBulan)).catch(console.error);
  }, []);

  const sidebar = [
    { label: "Dashboard Admin", to: "/admin" },
    { label: "Kelola Layanan", to: "/admin/layanan" },
    { label: "Kelola Pengajuan", to: "/admin/pengajuan" }
  ];

  const chartData = {
    labels: chart.map(c => c.bulan),
    datasets: [{ label: "Pengajuan per Bulan", data: chart.map(c => c.jumlah), backgroundColor: "#2563EB" }]
  };

  return (
    <DashboardLayout title="Menu Admin" sidebarItems={sidebar}>
      <h1 className="text-2xl font-extrabold mb-6">Ringkasan Statistik</h1>
      <div className="grid grid-cols-4 gap-4 mb-8">
        <div className="bg-gray-50 p-4 rounded-xl border text-center"><p className="text-sm font-bold text-gray-500">Penduduk</p><p className="text-2xl font-black">{stats.totalPenduduk || 0}</p></div>
        <div className="bg-gray-50 p-4 rounded-xl border text-center"><p className="text-sm font-bold text-gray-500">User</p><p className="text-2xl font-black">{stats.totalUser || 0}</p></div>
        <div className="bg-gray-50 p-4 rounded-xl border text-center"><p className="text-sm font-bold text-gray-500">Layanan</p><p className="text-2xl font-black">{stats.totalLayanan || 0}</p></div>
        <div className="bg-gray-50 p-4 rounded-xl border text-center"><p className="text-sm font-bold text-gray-500">Pengajuan</p><p className="text-2xl font-black">{stats.totalPengajuan || 0}</p></div>
      </div>
      <div className="max-w-3xl border p-4 rounded-xl"><Bar data={chartData} /></div>
    </DashboardLayout>
  );
}
EOF

cat > src/pages/admin/KelolaLayanan.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import DashboardLayout from "../../components/DashboardLayout";
import { api } from "../../utils/api";

export default function KelolaLayanan() {
  const [layanan, setLayanan] = useState([]);
  useEffect(() => { api.get("/layanan").then(res => setLayanan(res.data.data)); }, []);

  const sidebar = [{ label: "Dashboard Admin", to: "/admin" }, { label: "Kelola Layanan", to: "/admin/layanan" }, { label: "Kelola Pengajuan", to: "/admin/pengajuan" }];

  return (
    <DashboardLayout title="Menu Admin" sidebarItems={sidebar}>
      <h1 className="text-2xl font-extrabold mb-4">Daftar Layanan Tersedia</h1>
      <table className="w-full text-left border-collapse">
        <thead><tr className="border-b"><th className="py-2">Kode</th><th className="py-2">Nama Layanan</th><th className="py-2">Kategori</th></tr></thead>
        <tbody>
          {layanan.map(l => (
            <tr key={l.id} className="border-b">
              <td className="py-3 font-bold">{l.kode_layanan}</td>
              <td className="py-3">{l.nama_layanan}</td>
              <td className="py-3">{l.kategori}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </DashboardLayout>
  );
}
EOF

cat > src/pages/admin/KelolaPengajuan.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import Swal from "sweetalert2";
import DashboardLayout from "../../components/DashboardLayout";
import StatusBadge from "../../components/StatusBadge";
import { api } from "../../utils/api";

export default function KelolaPengajuan() {
  const [pengajuan, setPengajuan] = useState([]);
  
  const load = () => api.get("/pengajuan").then(res => setPengajuan(res.data.data));
  useEffect(() => { load(); }, []);

  const ubahStatus = async (id, statusLama) => {
    const statusBaru = prompt("Ubah status ke (Diproses/Verifikasi/Disetujui/Ditolak/Selesai):", statusLama);
    if (!statusBaru) return;
    try {
      await api.put(`/pengajuan/${id}/status`, { status: statusBaru });
      Swal.fire("Sukses", "Status berhasil diupdate", "success");
      load();
    } catch { Swal.fire("Error", "Gagal update status", "error"); }
  };

  const sidebar = [{ label: "Dashboard Admin", to: "/admin" }, { label: "Kelola Layanan", to: "/admin/layanan" }, { label: "Kelola Pengajuan", to: "/admin/pengajuan" }];

  return (
    <DashboardLayout title="Menu Admin" sidebarItems={sidebar}>
      <h1 className="text-2xl font-extrabold mb-4">Semua Pengajuan Masuk</h1>
      <table className="w-full text-left border-collapse text-sm">
        <thead><tr className="border-b"><th className="py-2">No</th><th className="py-2">Pemohon</th><th className="py-2">Layanan</th><th className="py-2">Status</th><th className="py-2">Aksi</th></tr></thead>
        <tbody>
          {pengajuan.map(p => (
            <tr key={p.id} className="border-b">
              <td className="py-3 font-bold">{p.no_pengajuan}</td>
              <td className="py-3">{p?.user?.nama_lengkap}</td>
              <td className="py-3">{p?.layanan?.nama_layanan}</td>
              <td className="py-3"><StatusBadge status={p.status} /></td>
              <td className="py-3">
                <button onClick={() => ubahStatus(p.id, p.status)} className="bg-yellow-500 text-white px-3 py-1 rounded-lg text-xs font-bold">Update</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </DashboardLayout>
  );
}
EOF

# 4. Update App.jsx untuk memasukkan halaman baru
cat > src/App.jsx <<'EOF'
import React from "react";
import { Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import ProtectedRoute from "./components/ProtectedRoute";

import Home from "./pages/public/Home";
import Login from "./pages/public/Login";

import UserDashboard from "./pages/user/UserDashboard";
import AjukanLayanan from "./pages/user/AjukanLayanan";

import AdminDashboard from "./pages/admin/AdminDashboard";
import KelolaLayanan from "./pages/admin/KelolaLayanan";
import KelolaPengajuan from "./pages/admin/KelolaPengajuan";

export default function App() {
  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="container-app py-6">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          
          <Route element={<ProtectedRoute requiredRole="user" />}>
            <Route path="/user" element={<UserDashboard />} />
            <Route path="/user/ajukan" element={<AjukanLayanan />} />
          </Route>
          
          <Route element={<ProtectedRoute requiredRole="admin" />}>
            <Route path="/admin" element={<AdminDashboard />} />
            <Route path="/admin/layanan" element={<KelolaLayanan />} />
            <Route path="/admin/pengajuan" element={<KelolaPengajuan />} />
          </Route>
        </Routes>
      </main>
    </div>
  );
}
EOF

echo "✅ Frontend Tahap 2 Selesai Dibuat!"