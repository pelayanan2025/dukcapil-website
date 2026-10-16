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
