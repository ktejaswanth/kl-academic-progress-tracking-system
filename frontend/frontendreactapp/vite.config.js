import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  //server is a object here
  server:{
    // default port fot vite is 5173
    port:3001
  }
})
