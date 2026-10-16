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
