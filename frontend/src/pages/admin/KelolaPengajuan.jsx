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
