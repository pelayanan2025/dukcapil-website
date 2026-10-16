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
