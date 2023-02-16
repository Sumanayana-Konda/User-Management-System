const Sequelize = require("sequelize");
const {DataTypes} = Sequelize;
//const {sequelize} = require(".");

module.exports = (sequelize, DataTypes) => {

    const User = sequelize.define("stud", {
        id: {
            primaryKey: true,
            type: DataTypes.INTEGER,
            autoIncrement:true
          },
          first_name: {
            type: DataTypes.STRING, 
            allowNull: false,
          },
          last_name: {
            type: DataTypes.STRING, 
            allowNull: false,
          },
          username: {
            type: DataTypes.STRING, 
            allowNull: false,
            unique: true,
          },
          password: {
            type: DataTypes.STRING, 
            allowNull: false,
          },
          account_created: {
            allowNull: false,
            type: DataTypes.STRING
          },
          account_updated: {
            type: DataTypes.STRING
          }
    },{
      freezeTableName: true,
      timestamps: false
    });
return User
}