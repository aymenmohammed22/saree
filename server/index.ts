import express, { type Request, Response, NextFunction } from "express";
import { registerRoutes } from "./routes";
import { setupVite, serveStatic, log } from "./vite";
import { Pool } from "pg";

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// ميدل وير لتسجيل الطلبات
app.use((req, res, next) => {
  const start = Date.now();
  const path = req.path;
  let capturedJsonResponse: Record<string, any> | undefined = undefined;

  const originalResJson = res.json;
  res.json = function (bodyJson, ...args) {
    capturedJsonResponse = bodyJson;
    return originalResJson.apply(res, [bodyJson, ...args]);
  };

  res.on("finish", () => {
    const duration = Date.now() - start;
    if (path.startsWith("/api")) {
      let logLine = `${req.method} ${path} ${res.statusCode} in ${duration}ms`;
      if (capturedJsonResponse) {
        logLine += ` :: ${JSON.stringify(capturedJsonResponse)}`;
      }

      if (logLine.length > 80) {
        logLine = logLine.slice(0, 79) + "…";
      }

      log(logLine);
    }
  });

  next();
});

// دالة للتحقق من الاتصال بقاعدة البيانات
async function checkDatabaseConnection() {
  try {
    const pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: { rejectUnauthorized: false }, // مهم لـ Render أو Heroku
    });

    const client = await pool.connect();
    await client.query("SELECT 1");
    client.release();
    await pool.end();

    console.log("✅ الاتصال بقاعدة البيانات ناجح");
    return true;
  } catch (error: any) {
    console.error("❌ فشل الاتصال بقاعدة البيانات:", error.message);
    return false;
  }
}

(async () => {
  const isConnected = await checkDatabaseConnection();
  if (!isConnected) {
    console.error("❌ لا يمكن بدء الخادم بدون اتصال بقاعدة البيانات");
    process.exit(1);
  }

  const server = await registerRoutes(app);

  app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
    const status = err.status || err.statusCode || 500;
    const message = err.message || "Internal Server Error";

    res.status(status).json({ message });
    throw err;
  });

  // Vite للتطوير أو ملفات ستاتيكية في الإنتاج
  if (app.get("env") === "development") {
    await setupVite(app, server);
  } else {
    serveStatic(app);
  }

  // تشغيل السيرفر على المنفذ من متغير البيئة أو 5000
  const port = parseInt(process.env.PORT || "5000", 10);
  server.listen(
    {
      port,
      host: "0.0.0.0",
      reusePort: true,
    },
    () => {
      log(`🚀 الخادم يعمل على المنفذ ${port}`);
    }
  );
})();
