const connection = require("../config/database");
const jobPostModel = require("../models/jobPostModel");

class jobPostController {
  static async getAllJobPosts(req, res) {
    const { limit = 10, offset = 0 } = req.query; // Ambil limit dan offset dari query string

    try {
      const results = await jobPostModel.getAllJobPosts(
        parseInt(limit),
        parseInt(offset)
      );
      res.status(200).json(results);
    } catch (error) {
      console.error("Error fetching job posts:", error);
      res
        .status(500)
        .json({ message: "Terjadi kesalahan saat mengambil data pekerjaan." });
    }
  }

  // jobPostController.js
  static async applyForJob(req, res) {
    const {
      idPekerjaan,
      akunPekerja,
      jawabanOpsi,
      jawabanTeks,
      tanggalLamaran,
      statusLamaran,
    } = req.body;

    if (!idPekerjaan || !akunPekerja) {
      return res
        .status(400)
        .json({ message: "ID Pekerjaan atau ID Pekerja tidak ditemukan." });
    }

    try {
      // Mengonversi jawabanOpsi menjadi format JSON string
      const jawabanOpsiJson = JSON.stringify(jawabanOpsi);

      const query = `
      INSERT INTO lamaran (idPekerjaan, akunPekerja, jawabanOpsi, jawabanTeks, tanggalLamaran, statusLamaran)
      VALUES (?, ?, ?, ?, ?, ?)
    `;

      // Menyimpan data ke dalam database
      const [result] = await connection.promise().query(query, [
        idPekerjaan,
        akunPekerja,
        jawabanOpsiJson, // Menyimpan jawabanOpsi dalam format JSON string
        jawabanTeks,
        tanggalLamaran,
        statusLamaran,
      ]);

      res.status(201).json({
        message: "Lamaran berhasil dikirim",
        lamaranId: result.insertId,
      });
    } catch (error) {
      console.error("Error submitting job application:", error);
      res.status(500).json({ message: "Gagal mengirim lamaran." });
    }
  }

  static async getRecommendedQuestions(req, res) {
    const { idPekerjaan } = req.params;

    try {
      const query = `
            SELECT pertanyaan
            FROM pekerjaan
            WHERE idPekerjaan = ?
        `;
      const [rows] = await connection.promise().query(query, [idPekerjaan]);

      if (rows.length === 0) {
        return res.status(404).json({ message: "Pekerjaan tidak ditemukan" });
      }

      res.status(200).json({
        questions: JSON.parse(rows[0].pertanyaan),
      });
    } catch (error) {
      console.error("Error fetching recommended questions:", error);
      res.status(500).json({ message: "Terjadi kesalahan server" });
    }
  }

  static async uploadFile(req, res) {
    const { idPekerja, columnName, fileType } = req.body;

    if (!req.files || !req.files.file) {
      console.error("No file uploaded");
      return res.status(400).json({ message: "Tidak ada file yang diunggah." });
    }

    if (!idPekerja || !columnName || !fileType) {
      console.error("Missing required parameters:", {
        idPekerja,
        columnName,
        fileType,
      });
      return res.status(400).json({ message: "Parameter tidak valid." });
    }

    // Validasi hanya untuk resume
    if (columnName !== "resume") {
      console.error("Invalid column name:", columnName);
      return res
        .status(400)
        .json({ message: "Kolom tidak valid. Hanya resume yang didukung." });
    }

    const file = req.files.file;
    const fileName = `${Date.now()}-${file.name}`;
    const uploadPath = `./uploads/${fileName}`;

    try {
      // Pindahkan file ke folder uploads
      file.mv(uploadPath, async (err) => {
        if (err) {
          console.error("Error saat memindahkan file:", err);
          return res.status(500).json({ message: "Gagal menyimpan file." });
        }

        // Simpan nama file ke database
        const query = `
      UPDATE lamaran
      SET ${columnName} = ?
      WHERE akunPekerja = ?
    `;
        const values = [fileName, idPekerja];

        try {
          const [result] = await connection.promise().query(query, values);
          if (result.affectedRows === 0) {
            return res
              .status(400)
              .json({ message: "Gagal menyimpan file ke database." });
          }

          console.log(`${fileType} berhasil diunggah: ${fileName}`);
          res
            .status(200)
            .json({ message: `${fileType} berhasil diunggah.`, fileName });
        } catch (dbError) {
          console.error("Database error saat menyimpan file:", dbError);
          res
            .status(500)
            .json({ message: "Gagal menyimpan data ke database." });
        }
      });
    } catch (error) {
      console.error("Error handling file upload:", error);
      res
        .status(500)
        .json({ message: "Terjadi kesalahan saat memproses file." });
    }
  }
}

module.exports = jobPostController;
