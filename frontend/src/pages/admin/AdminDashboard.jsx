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
