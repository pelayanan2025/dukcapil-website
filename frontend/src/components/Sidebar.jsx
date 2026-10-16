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
