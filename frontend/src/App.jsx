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
