const PekerjaModel = require("../models/pekerjaModel");
const path = require("path");
const fs = require("fs");
const pool = require("../config/database");

class pekerjaController {
  static async createPekerja(req, res) {
    try {
      const { username, email, password } = req.body;

      if (!username || !email || !password) {
        return res.status(400).json({ message: "Semua field harus diisi." });
      }

      PekerjaModel.createPekerja(username, email, password, (error, result) => {
        if (error) {
          console.error("Error creating pekerja:", error);
          return res.status(500).json({ message: "Gagal membuat pekerja." });
        }

        res.status(201).json({ message: "Pekerja berhasil dibuat.", result });
      });
    } catch (error) {
      console.error("Error in createPekerja:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async ambilPekerjaByEmail(req, res) {
    try {
      const { email } = req.body;

      if (!email) {
        return res.status(400).json({ message: "Email harus diisi." });
      }

      PekerjaModel.ambilPekerjaByEmail(email, (error, results) => {
        if (error) {
          console.error("Error fetching pekerja by email:", error);
          return res
            .status(500)
            .json({ message: "Gagal mengambil data pekerja." });
        }

        if (results.length === 0) {
          return res.status(404).json({ message: "Pekerja tidak ditemukan." });
        }

        res.status(200).json(results[0]);
      });
    } catch (error) {
      console.error("Error in ambilPekerjaByEmail:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async logIn(req, res) {
    try {
      console.log("Login request received:", req.body);
      const { email, password } = req.body;

      const user = await PekerjaModel.logIn(email, password);
      console.log("Login result:", user);

      if (!user) {
        return res.status(200).send({
          message: "Invalid email or password",
          passwordCorrect: false,
        });
      }

      return res
        .status(200)
        .send({ message: "Login successful", user, passwordCorrect: true });
    } catch (error) {
      console.error("Error during login:", error);
      return res
        .status(500)
        .send({ message: "Internal server error", passwordCorrect: false });
    }
  }

  static async ambilPekerjaById(req, res) {
    try {
      const { idPekerja } = req.body;

      if (!idPekerja) {
        return res.status(400).json({ message: "ID pekerja harus diisi." });
      }

      PekerjaModel.ambilPekerjaById(idPekerja, (error, results) => {
        if (error) {
          console.error("Error fetching pekerja by ID:", error);
          return res
            .status(500)
            .json({ message: "Gagal mengambil data pekerja." });
        }

        if (results.length === 0) {
          return res.status(404).json({ message: "Pekerja tidak ditemukan." });
        }

        res.status(200).json(results[0]);
      });
    } catch (error) {
      console.error("Error in ambilPekerjaById:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async updateProfil(req, res) {
    try {
      const { idPekerja, username, email } = req.body;

      if (!idPekerja) {
        return res.status(400).json({ message: "ID pekerja harus diisi." });
      }

      let updateQuery = "UPDATE pekerja SET ";
      const values = [];

      if (username) {
        updateQuery += "username = ?, ";
        values.push(username);
      }

      if (email) {
        updateQuery += "email = ?, ";
        values.push(email);
      }

      if (values.length > 0) {
        updateQuery = updateQuery.slice(0, -2) + " WHERE idPekerja = ?";
        values.push(idPekerja);
      } else {
        return res
          .status(400)
          .json({ message: "Tidak ada data yang diupdate." });
      }

      pool.query(updateQuery, values, (error, result) => {
        if (error) {
          console.error("Error updating profile:", error);
          return res.status(500).json({ message: "Gagal memperbarui profil." });
        }

        res.status(200).json({ message: "Profil berhasil diperbarui." });
      });
    } catch (error) {
      console.error("Error in updateProfil:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async updateProfilData(req, res) {
    try {
      const { idPekerja, columnName, value } = req.body;

      if (!idPekerja || !columnName || value === undefined) {
        return res.status(400).json({ message: "Semua field harus diisi." });
      }

      PekerjaModel.updateProfilData(
        idPekerja,
        columnName,
        value,
        (error, result) => {
          if (error) {
            console.error("Error updating data:", error);
            return res.status(500).json({ message: "Gagal memperbarui data." });
          }

          res.status(200).json({ message: "Data berhasil diperbarui." });
        }
      );
    } catch (error) {
      console.error("Error in updateProfilData:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async uploadFile(req, res) {
    try {
      const { idPekerja, columnName, fileType } = req.body;
      const file = req.files?.file;

      console.log("ID Pekerja:", idPekerja);
      console.log("Column Name:", columnName);
      console.log("File Type:", fileType);
      console.log("File Name:", file?.name);
      console.log("File Size:", file?.size);
      console.log("File Data (First 100 bytes):", file.data?.slice(0, 100));

      if (!idPekerja || !columnName || !file) {
        return res
          .status(400)
          .json({ message: "ID pekerja, columnName, dan file harus diisi." });
      }

      if (!["lisensiSertif", "resume"].includes(columnName)) {
        return res.status(400).json({ message: "Invalid columnName." });
      }

      const fileData = file.data;
      const fileName = file.name;

      const typeColumn =
        columnName === "lisensiSertif" ? "lisensiTipe" : "resumeTipe";
      const nameColumn =
        columnName === "lisensiSertif" ? "lisensiNama" : "resumeNama";

      const query = `
        UPDATE pekerja 
        SET ${columnName} = ?, ${typeColumn} = ?, ${nameColumn} = ? 
        WHERE idPekerja = ?
      `;

      pool.query(
        query,
        [fileData, fileType, fileName, idPekerja],
        (error, result) => {
          if (error) {
            console.error("Database Error:", error);
            return res.status(500).json({ message: "Gagal mengunggah file." });
          }

          console.log("File berhasil disimpan ke database:");
          console.log("File Data (Length):", fileData.length);
          console.log("File Type:", fileType);
          console.log("File Name:", fileName);

          res.status(200).json({ message: "File berhasil diunggah." });
        }
      );
    } catch (error) {
      console.error("Error in uploadFile:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }

  static async getProfileData(req, res) {
    const { idPekerja } = req.body;

    if (!idPekerja) {
      return res.status(400).json({ message: "ID pekerja tidak ditemukan." });
    }

    try {
      const query = `
        SELECT 
          username, 
          email, 
          gambarProfil, 
          lisensiNama, 
          lisensiTipe, 
          resumeNama, 
          resumeTipe, 
          ringkasan, 
          riwayatPekerjaan, 
          informasiPendidikan, 
          skill, 
          bahasa 
        FROM pekerja 
        WHERE idPekerja = ?
      `;

      pool.query(query, [idPekerja], (error, results) => {
        if (error) {
          console.error("Error fetching profile data:", error);
          return res
            .status(500)
            .json({ message: "Gagal mengambil data profil." });
        }

        if (results.length === 0) {
          return res
            .status(404)
            .json({ message: "Data pekerja tidak ditemukan." });
        }

        res.status(200).json(results[0]);
      });
    } catch (error) {
      console.error("Error fetching profile data:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }
}

module.exports = pekerjaController;
