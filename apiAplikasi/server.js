const express = require("express");
const fileUpload = require("express-fileupload");
const cors = require("cors");
const pekerjaRoutes = require("./src/routes/pekerjaRoutes");
const jobPostRoutes = require("./src/routes/jobPostRoutes");
const path = require("path");
require("dotenv").config();

const bodyParser = require("body-parser");
const perusahaanRoutes = require("./src/routes/perusahaanRoutes");

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static("uploads"));

app.use(
  fileUpload({
    limits: { fileSize: 16 * 1024 * 1024 },
    abortOnLimit: true,
    tempFileDir: "/tmp/",
    parseNested: true,
  })
);

app.use((req, res, next) => {
  console.log(`Incoming request: ${req.method} ${req.url}`);
  next();
});

app.use("/api", pekerjaRoutes);
app.use("/api", jobPostRoutes);
app.use("/api", perusahaanRoutes);

app.use((req, res) => {
  res.status(404).send({ message: "Rute tidak ditemukan." });
});

app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ limit: "10mb", extended: true }));

const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});

server.setTimeout(2 * 60 * 1000);

module.exports = app;
