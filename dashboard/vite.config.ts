import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import path from "node:path";

export default defineConfig({
  base: "/TAX/",
  define: {
    "import.meta.env.VITE_DEMO_MODE": JSON.stringify("true"),
  },
  resolve: {
    alias: {
      "@tax-dashboard/core": path.resolve(__dirname, "src/core"),
    },
  },
  plugins: [react(), tailwindcss()],
});
