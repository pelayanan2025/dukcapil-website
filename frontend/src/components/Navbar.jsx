import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function Navbar() {
  const { isAuthenticated, user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => { logout("Anda telah logout."); navigate("/"); };

  return (
    <header className="sticky top-0 z-50 border-b bg-white/90 backdrop-blur">
      <div className="container-app flex h-16 items-center justify-between">
        <Link to="/" className="font-extrabold text-primary-700 text-xl">DUKCAPIL</Link>
        <div className="flex gap-4 items-center">
          <Link to="/" className="text-sm font-semibold">Beranda</Link>
          {!isAuthenticated ? (
            <Link to="/login" className="bg-primary-600 text-white px-4 py-2 rounded-xl text-sm font-bold">Login</Link>
          ) : (
            <>
              <Link to={user.role === "admin" ? "/admin" : "/user"} className="text-sm font-bold border px-4 py-2 rounded-xl">Dashboard</Link>
              <button onClick={handleLogout} className="bg-red-500 text-white px-4 py-2 rounded-xl text-sm font-bold">Logout</button>
            </>
          )}
        </div>
      </div>
    </header>
  );
}
