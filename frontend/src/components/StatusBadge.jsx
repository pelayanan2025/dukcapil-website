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
