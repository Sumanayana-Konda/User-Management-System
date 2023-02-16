const Sequelize = require("sequelize");
const {DataTypes} = Sequelize;

module.exports = (sequelize, DataTypes) => {

    const Product = sequelize.define("product", {
        id: {
            primaryKey: true,
            type: DataTypes.INTEGER,
            autoIncrement: true
          },
          name: {
            type: DataTypes.STRING, 
          },
          description: {
            type: DataTypes.STRING, 
          },
          sku: {
            type: DataTypes.STRING, 
          },
          manufacturer: {
            type: DataTypes.STRING, 
          },
          quantity:{
            type: DataTypes.INTEGER,
            allowNull: false,
          },
          date_added: {
            allowNull: false,
            type: DataTypes.STRING,
          },
          date_last_updated: {
            type: DataTypes.STRING,
          }, 
          owner_user_id:{
            type: DataTypes.INTEGER,
            allowNull: false,
            references:{
              model: 'stud',
              key: 'id'
            }},
    }, {
      freezeTableName: true,
      timestamps: false
    })


    return Product
}