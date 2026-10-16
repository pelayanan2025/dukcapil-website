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
