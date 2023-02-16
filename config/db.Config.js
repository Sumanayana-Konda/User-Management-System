module.exports = {
    HOST: "localhost",
    USER: "postgres",
    PASSWORD: "test",
    DB: "students",
    dialect: "postgres",
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  };