const pool = require("../config/database");
const bcrypt = require("bcrypt");

class pekerjaModel {
  static async createPekerja(username, email, password, callback) {
    try {
      const salt = await bcrypt.genSalt(9);
      const hashedPassword = await bcrypt.hash(password, salt);

      const query =
        "INSERT INTO pekerja (username, email, password) VALUES (?, ?, ?)";
      const values = [username, email, hashedPassword];

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

  static ambilSemuaPekerja(callback) {
    const query = "SELECT * FROM pekerja";

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

  static ambilPekerjaByEmail(email, callback) {
    const query = "SELECT * FROM pekerja WHERE email=?";
    const values = [email];

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
    const query = "SELECT * FROM pekerja WHERE email=?";
    const values = [email];

    console.log("Login query started for email:", email);

    return new Promise((resolve, reject) => {
      pool.query(query, values, async (error, results) => {
        if (error) {
          console.error("Error executing query:", error);
          return reject(error);
        }

        if (results.length === 0) {
          console.log("No user found for email:", email);
          return resolve(false);
        }

        const user = results[0];
        console.log("User found:", user);

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
          console.log("Invalid password for user:", email);
          return resolve(false);
        }

        console.log("Password valid for user:", email);
        resolve(user);
      });
    });
  }

  static ambilPekerjaById(idPekerja, callback) {
    const query = "SELECT * FROM pekerja WHERE idPekerja = ?";
    pool.query(query, [idPekerja], (error, results) => {
      if (error) {
        return callback(error, null);
      }
      callback(null, results);
    });
  }

  static updateProfil(idPekerja, username, email, gambarProfil, callback) {
    const query =
      "UPDATE pekerja SET username = ?, email = ?, gambarProfil = ? WHERE idPekerja = ?";
    const values = [username, email, gambarProfil, idPekerja];

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

  static updateProfilData(idPekerja, columnName, value, callback) {
    const query = `UPDATE pekerja SET ${columnName} = ? WHERE idPekerja = ?`;
    const values = [value, idPekerja];

    console.log("Executing Query:", query);
    console.log("With Values:", values);

    pool.query(query, values, (error, results) => {
      if (error) {
        console.error("SQL Error:", error);
        return callback(error, null);
      }
      callback(null, results);
    });
  }

  static uploadFile(
    idPekerja,
    columnName,
    fileName,
    fileType,
    fileData,
    callback
  ) {
    const query = `
    UPDATE pekerja 
    SET ${columnName} = ?, lisensiNama = ?, lisensiTipe = ? 
    WHERE idPekerja = ?`;
    const values = [fileData, fileName, fileType, idPekerja];

    pool.query(query, values, (error, results) => {
      if (error) {
        console.error("Database Error:", error);
        return callback(error, null);
      }
      callback(null, results);
    });
  }
}

module.exports = pekerjaModel;
