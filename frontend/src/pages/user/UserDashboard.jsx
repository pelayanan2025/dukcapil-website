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
