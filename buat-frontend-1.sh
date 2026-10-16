#!/usr/bin/env bash

echo "Membangun Frontend Tahap 1 (Core & Public Pages)..."

mkdir -p frontend/src/{components,context,pages/public,pages/user,pages/admin,utils}
mkdir -p frontend/public/images
cd frontend

# 1. Konfigurasi Vite & Tailwind
cat > package.json <<'EOF'
{
  "name": "dukcapil-frontend",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": {
    "axios": "^1.7.7", "chart.js": "^4.4.4", "react": "^18.3.1", "react-chartjs-2": "^5.2.0",
    "react-dom": "^18.3.1", "react-icons": "^5.3.0", "react-router-dom": "^6.26.2", "sweetalert2": "^11.12.4"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1", "autoprefixer": "^10.4.20", "postcss": "^8.4.45", "tailwindcss": "^3.4.10", "vite": "^5.4.8"
  }
}
EOF

cat > vite.config.js <<'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
export default defineConfig({ plugins: [react()], server: { port: 5173 } });
EOF

cat > tailwind.config.js <<'EOF'
export default {
  darkMode: "class",
  content: ["./index.html", "./src/**/*.{js,jsx}"],
  theme: { extend: { colors: { primary: { 600: "#2563EB", 700: "#1E40AF" }, secondary: { 600: "#D97706" }, accent: { 600: "#059669" } } } },
  plugins: []
};
EOF

cat > postcss.config.js <<'EOF'
export default { plugins: { tailwindcss: {}, autoprefixer: {} } };
EOF

cat > index.html <<'EOF'
<!doctype html>
<html lang="id">
  <head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>Dukcapil Website</title></head>
  <body class="bg-gray-100 text-gray-800 dark:bg-slate-950 dark:text-slate-100">
    <div id="root"></div><script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

cat > .env.example <<'EOF'
VITE_API_URL=http://localhost:5000/api
EOF

# 2. Main & CSS
cat > src/index.css <<'EOF'
@tailwind base; @tailwind components; @tailwind utilities;
:root { color-scheme: light; }
html.dark { color-scheme: dark; }
.container-app { @apply mx-auto w-full max-w-7xl px-4; }
.badge { @apply inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold; }
EOF

cat > src/main.jsx <<'EOF'
import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import App from "./App.jsx";
import "./index.css";
import { AuthProvider } from "./context/AuthContext.jsx";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode><BrowserRouter><AuthProvider><App /></AuthProvider></BrowserRouter></React.StrictMode>
);
EOF

# 3. Utilities & Context
cat > src/utils/api.js <<'EOF'
import axios from "axios";
export const API_URL = import.meta.env.VITE_API_URL || "http://localhost:5000/api";
export const BASE_URL = API_URL.replace(/\/api\/?$/, "");
export const api = axios.create({ baseURL: API_URL, timeout: 30000 });
const getToken = () => localStorage.getItem("dukcapil_token");
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
}, (error) => Promise.reject(error));
api.interceptors.response.use((res) => res, (error) => {
  if (error?.response?.status === 401) window.dispatchEvent(new CustomEvent("dukcapil:unauthorized"));
  return Promise.reject(error);
});
export const getErrorMessage = (err) => err?.response?.data?.message || err?.message || "Terjadi kesalahan.";
export const fileUrl = (path) => path ? `${BASE_URL}/${String(path).replace(/^\/+/, "")}` : null;
EOF

cat > src/context/AuthContext.jsx <<'EOF'
import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import Swal from "sweetalert2";
import { api, getErrorMessage } from "../utils/api";

const AuthContext = createContext(null);
const TOKEN_KEY = "dukcapil_token";

const decodeJwt = (token) => {
  try { return JSON.parse(atob(token.split(".")[1].replace(/-/g, "+").replace(/_/g, "/"))); } 
  catch { return null; }
};

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(() => localStorage.getItem(TOKEN_KEY));
  const [user, setUser] = useState(null);
  const [loadingAuth, setLoadingAuth] = useState(true);

  const logout = (msg) => { setToken(null); setUser(null); localStorage.removeItem(TOKEN_KEY); if (msg) Swal.fire({ toast: true, position: "top-end", icon: "info", title: msg, showConfirmButton: false, timer: 2000 }); };

  const fetchMe = async () => {
    try { const res = await api.get("/auth/me"); if (res.data?.success) setUser(res.data.data); else setUser(null); } 
    catch { setUser(null); }
  };

  useEffect(() => {
    const init = async () => {
      const stored = localStorage.getItem(TOKEN_KEY);
      if (!stored) return setLoadingAuth(false);
      const payload = decodeJwt(stored);
      if (!payload?.exp || payload.exp * 1000 <= Date.now()) { logout("Sesi berakhir."); return setLoadingAuth(false); }
      await fetchMe();
      setLoadingAuth(false);
    };
    init();
  }, []);

  const login = async (form) => {
    try {
      const res = await api.post("/auth/login", form);
      setToken(res.data.data.token); localStorage.setItem(TOKEN_KEY, res.data.data.token);
      setUser(res.data.data.user);
      Swal.fire({ toast: true, position: "top-end", icon: "success", title: "Login berhasil", showConfirmButton: false, timer: 2000 });
      return { success: true, role: res.data.data.user.role };
    } catch (err) { Swal.fire({ icon: "error", title: getErrorMessage(err) }); return { success: false }; }
  };

  const val = useMemo(() => ({ token, user, loadingAuth, login, logout, isAuthenticated: !!token && !!user }), [token, user, loadingAuth]);
  return <AuthContext.Provider value={val}>{children}</AuthContext.Provider>;
};
export const useAuth = () => useContext(AuthContext);
EOF

# 4. Komponen Dasar
cat > src/components/Loading.jsx <<'EOF'
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
EOF

cat > src/components/ProtectedRoute.jsx <<'EOF'
import React from "react";
import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import Loading from "./Loading";

export default function ProtectedRoute({ requiredRole }) {
  const { loadingAuth, isAuthenticated, user } = useAuth();
  if (loadingAuth) return <Loading label="Memeriksa sesi..." />;
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (requiredRole && user?.role !== requiredRole) return <Navigate to="/" replace />;
  return <Outlet />;
}
EOF

cat > src/components/Navbar.jsx <<'EOF'
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
EOF

# 5. Routing Dasar (App.jsx)
cat > src/App.jsx <<'EOF'
import React from "react";
import { Routes, Route } from "react-router-dom";
import Navbar from "./components/Navbar";
import ProtectedRoute from "./components/ProtectedRoute";

import Home from "./pages/public/Home";
import Login from "./pages/public/Login";

export default function App() {
  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="container-app py-6">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          
          <Route element={<ProtectedRoute requiredRole="user" />}>
            <Route path="/user" element={<div className="p-5 font-bold">User Dashboard (Tahap 2)</div>} />
          </Route>
          
          <Route element={<ProtectedRoute requiredRole="admin" />}>
            <Route path="/admin" element={<div className="p-5 font-bold">Admin Dashboard (Tahap 2)</div>} />
          </Route>
        </Routes>
      </main>
    </div>
  );
}
EOF

# 6. Halaman Publik
cat > src/pages/public/Home.jsx <<'EOF'
import React from "react";
import { Link } from "react-router-dom";
export default function Home() {
  return (
    <div className="text-center py-20">
      <h1 className="text-4xl font-extrabold text-primary-700">Selamat Datang di DUKCAPIL Online</h1>
      <p className="mt-4 text-gray-600">Layanan administrasi kependudukan yang cepat dan transparan.</p>
      <Link to="/login" className="inline-block mt-8 bg-primary-600 text-white px-6 py-3 rounded-xl font-bold">Mulai Layanan</Link>
    </div>
  );
}
EOF

cat > src/pages/public/Login.jsx <<'EOF'
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: "", password: "" });

  const onSubmit = async (e) => {
    e.preventDefault();
    const res = await login(form);
    if (res.success) navigate(res.role === "admin" ? "/admin" : "/user");
  };

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white border rounded-2xl shadow-sm">
      <h2 className="text-xl font-extrabold mb-4">Login</h2>
      <form onSubmit={onSubmit} className="grid gap-4">
        <input type="email" placeholder="Email (admin@dukcapil.go.id)" value={form.email} onChange={e => setForm({...form, email: e.target.value})} className="border p-3 rounded-xl" />
        <input type="password" placeholder="Password (admin123)" value={form.password} onChange={e => setForm({...form, password: e.target.value})} className="border p-3 rounded-xl" />
        <button className="bg-primary-600 text-white p-3 rounded-xl font-bold">Masuk</button>
      </form>
    </div>
  );
}
EOF

echo "✅ Frontend Tahap 1 Selesai!"