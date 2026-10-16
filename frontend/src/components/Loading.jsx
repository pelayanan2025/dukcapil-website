import React from "react";
export default function Loading({ label = "Memuat..." }) {
  return (
    <div className="flex w-full items-center justify-center py-10">
      <div className="flex items-center gap-3 rounded-xl bg-white px-5 py-3 shadow-sm dark:bg-slate-900">
        <div className="h-5 w-5 animate-spin rounded-full border-2 border-primary-600 border-t-transparent" />
        <p className="text-sm text-gray-700 dark:text-slate-200">{label}</p>
      </div>
    </div>
  );
}
