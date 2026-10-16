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
