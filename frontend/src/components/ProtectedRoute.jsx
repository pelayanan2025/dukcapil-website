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
