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
