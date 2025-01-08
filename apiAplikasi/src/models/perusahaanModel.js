const pool = require("../config/database");
const bcrypt = require("bcrypt");

class perusahaanModel {
  static async createPerusahaan(
    username,
    email,
    password,
    nomorHP,
    namaBisnis,
    callback
  ) {
    try {
      const salt = await bcrypt.genSalt(9);
      const hashedPassword = await bcrypt.hash(password, salt);

      const query =
        "INSERT INTO perusahaan (username, email, password, nomorHP, namaBisnis) VALUES (?, ?, ?, ?, ?)";
      const values = [username, email, hashedPassword, nomorHP, namaBisnis];

      pool.query(query, values, (error, results) => {
        if (typeof callback === "function") {
          if (error) {
            return callback(error, null);
          }
          callback(null, results);
        } else {
          console.error("Callback is not a function:", callback);
        }
      });
    } catch (error) {
      if (typeof callback === "function") {
        callback(error, null);
      } else {
        console.error("Callback is not a function:", callback);
      }
    }
  }

  static ambilSemuaPerusahaan(callback) {
    const query = "SELECT * FROM perusahaan";

    pool.query(query, (error, results) => {
      if (typeof callback === "function") {
        if (error) {
          return callback(error, null);
        }
        callback(null, results);
      } else {
        console.error("Callback is not a function:", callback);
      }
    });
  }
  static ambilPerusahaanByEmail(email, callback) {
    const query = "SELECT * FROM perusahaan WHERE email=?";
    const values = [email];
    console.log("Searching for email:", email);

    pool.query(query, values, (error, results) => {
      if (typeof callback === "function") {
        if (error) {
          return callback(error, null);
        }
        callback(null, results);
      } else {
        console.error("Callback is not a function:", callback);
      }
    });
  }
  static async logIn(email, password) {
    const query = "SELECT * FROM perusahaan WHERE email=?";
    const values = [email];

    return new Promise((resolve, reject) => {
      pool.query(query, values, async (error, results) => {
        if (error) {
          return reject(error); // Handle database error
        }

        if (results.length === 0) {
          return resolve(false); // No user found
        }

        const user = results[0]; // Get the first result
        const isPasswordValid = await bcrypt.compare(password, user.password); // Compare passwords

        if (!isPasswordValid) {
          return resolve(false); // Password doesn't match
        }

        resolve(user); // User verified
      });
    });
  }
  static ambilPerusahaanById(idPerusahaan, callback) {
    const query = "SELECT * FROM perusahaan WHERE idPerusahaan = ?";
    const values = [idPerusahaan];

    pool.query(query, values, (error, results) => {
      if (typeof callback === "function") {
        if (error) {
          return callback(error, null);
        }
        callback(null, results);
      } else {
        console.error("Callback is not a function:", callback);
      }
    });
  }
  static updatePersonal(idPerusahaan, nama, email) {
    const query =
      "UPDATE perusahaan SET username = ?, email = ? WHERE idPerusahaan = ?";
    const values = [nama, email, idPerusahaan];
    return new Promise((resolve, reject) => {
      pool.query(query, values, (error, results) => {
        if (error) reject(error);
        resolve(results);
      });
    });
  }
  static checkEmailExists(email, idPerusahaan) {
    const query =
      "SELECT COUNT(*) AS count FROM perusahaan WHERE email = ? AND idPerusahaan != ?";
    const values = [email, idPerusahaan];

    return new Promise((resolve, reject) => {
      pool.query(query, values, (error, results) => {
        if (error) {
          reject(error);
        } else {
          resolve(results[0].count > 0); // Kembalikan true jika email sudah ada
        }
      });
    });
  }

  static updatePerusahaan(idPerusahaan, namaBisnis, kontakUtama, nomorHP) {
    const query = `
          UPDATE perusahaan
          SET namaBisnis = ?, kontakUtama = ?, nomorHP = ?
          WHERE idPerusahaan = ?`;
    const values = [namaBisnis, kontakUtama, nomorHP, idPerusahaan];
    return new Promise((resolve, reject) => {
      pool.query(query, values, (error, results) => {
        if (error) reject(error);
        resolve(results);
      });
    });
  }
  static uploadPekerjaan(
    idPerusahaan,
    judulPekerjaan,
    lokasiPekerjaan,
    kategoriJabatan,
    kategoriGaji,
    jenisGaji,
    kisaranGaji,
    deskripsiPekerjaan,
    linkReferensi,
    pertanyaan,
    callback
  ) {
    const query = `INSERT INTO pekerjaan 
      (idPerusahaan, judulPekerjaan, lokasiPekerjaan, kategoriJabatan, kategoriGaji, jenisGaji, kisaranGaji, deskripsiPekerjaan, linkReferensi, pertanyaan) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [
      idPerusahaan,
      judulPekerjaan,
      lokasiPekerjaan,
      kategoriJabatan,
      kategoriGaji,
      jenisGaji,
      kisaranGaji,
      deskripsiPekerjaan,
      linkReferensi,
      JSON.stringify(pertanyaan || []), // Pastikan pertanyaan dalam format string
    ];

    pool.query(query, values, (error, results) => {
      if (typeof callback === "function") {
        if (error) {
          return callback(error, null);
        }
        callback(null, results);
      } else {
        console.error("Callback is not a function:", callback);
      }
    });
  }
}
module.exports = perusahaanModel;
