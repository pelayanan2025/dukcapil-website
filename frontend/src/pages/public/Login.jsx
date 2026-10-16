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
