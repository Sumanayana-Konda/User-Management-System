const db = require('../models');
const bcrypt = require("bcrypt");     
const { and } = require('sequelize');
//create main model

const User = db.stud;
const Product = db.product;

//functions

//Add Product

const addProduct = async (req, res) => {
const date = new Date();
Objbg = {                                      // Creating a JSON Object with required variables of Payload.
    "name": req.body.name,
    "description": req.body.description,
    "sku": req.body.sku,
    "manufacturer": req.body.manufacturer,
    "quantity": req.body.quantity     
};
if(req.get('Authorization')){      //Checking if Basic Authorization is enabled or not
    const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':')
    const username = credentials[0]
    const password = credentials[1]
   
    User.findOne({where:{username:username}}).then((r)=>{     //Checking if the username entered exits or not
    if(r){
    bcrypt.compare(password, r.password, (err, result) => {   //Checking if the Password entered is matching or not

        if(result){
    
        sku = req.body.sku;
        
//The validations include entering all the values to add a product, making sure entered fields are not empty or white spaces.
        if(req.body.quantity>=0 && req.body.quantity<=100 && validateOne(req) && validateTwo(req) && (JSON.stringify(req.body) == JSON.stringify(Objbg))){
            Product.findOne({where:{sku:sku}}).then((results) => {   //Checking if the sku value is unique or not
         if(!results){      
            let info = {
        name: req.body.name,
        description: req.body.description,
        sku: req.body.sku,
        manufacturer: req.body.manufacturer,
        quantity: req.body.quantity, 
        date_added: date.toISOString(),
        date_last_updated: date.toISOString(),
        owner_user_id: r.id
    }
    
    Product.create(info).then((product)=>{  //Creating the product
    res.status(200).send(product);})}else {res.status(400).send("Bad Request");}   //Sending a Bad Request if the Sku already exists
}  

)}else {res.status(400).send("Bad Request");}  // Sending a Bad request if the validations are not approved


}
    else {res.status(401).send("Unauthorized");} // Sending a Unauthorized request if the Password is wrong

})

}  else {res.status(401).send("Unauthorized");}  }) // Sending a Unauthorized request if the Username does not exist

   
    
}
else {res.status(403).send("Forbidden");} //Forbidden if the authorization does not exist
}


const updateProduct = async (req, res) => {

    const id = req.params.id;
    if(id>0){
    Product.findOne({where:{id:id}}).then((results) => {  //Check if the Product ID exists or not
    if(results){
    const date = new Date();
    Objbg = {                                      // Creating a JSON Object with required variables of Payload.
        "name": req.body.name,
        "description": req.body.description,
        "sku": req.body.sku,
        "manufacturer": req.body.manufacturer,
        "quantity": req.body.quantity     
    };
    if(req.get('Authorization')){   //Check if the Basic Authentication is Enabled or not
        const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':') //Authentication
        const username = credentials[0]
        const password = credentials[1]
        User.findOne({where:{username:username}}).then((r)=>{  //Check if the username exists or not
            if(r){
            bcrypt.compare(password, r.password, (err, result) => { //Check if the password matches
                if(result){
//Check for Validations
                    if(req.body.quantity>=0 && req.body.quantity<=100 && validateOne(req) && validateTwo(req) && (JSON.stringify(req.body) == JSON.stringify(Objbg))){
                        Product.findOne({where:{sku:req.body.sku}}).then((results) => {  //Check if Sku exists or not
                     if(!results || results.id==id){  
                        
                        Product.findOne({where:{id:id}}).then((hello)=>{

                            if(hello.name == req.body.name && hello.description == req.body.description && hello.sku==req.body.sku
                                && hello.manufacturer==req.body.manufacturer&&hello.quantity==req.body.quantity){

                                    res.status(203).send("No Update Necessary");
                                }
                                else{

                    const info ={
                    
                        "name": req.body.name,
                        "description": req.body.description,
                        "sku": req.body.sku,
                        "manufacturer": req.body.manufacturer,
                        "quantity": req.body.quantity,
                        "date_last_updated":date.toISOString()
                      }

                    Product.update(info, {where: {owner_user_id:r.id, id:id}} ).then((error)=>{  //Update the product if the user id is matching
                        if(error[0]){res.status(204).send("No Content");}  //Updated successfully
                        else{res.status(403).send("Forbidden");}   //Send a Forbidden if the User ID is not matching

                    })  } })
                } else {res.status(403).send("Forbidden");} // Send Forbidden if the sku exists 
              })  }else {res.status(400).send("Bad Request");}  //Send Bad Request if the validations do not pass
      
                }else {res.status(401).send("Unauthorized");}  //Send Unauthorized if the password does not match
            
            })}else {res.status(401).send("Unauthorized");}   // Send Unauthorized if the Username Does not Exist
        })
    
    }else {res.status(400).send("Bad Request");}  //Send a Bad request if the Basic Authentication is not Enabled
}
else {res.status(400).send("Bad Request");}   // Send a Bad Request if the Product ID does not exist
})
}else {res.status(403).send("Forbidden");} 
}

const getAllProducts = async (req, res) => {
    const products = await Product.findAll({})
    res.status(200).send(products);
}

const getProduct = async (req, res) => {
    let id = req.params.id;
    Product.findOne({where:{id:id}}).then((users)=>{   
        if(users){     

         const p = users;
    res.status(200).send({
        id: p.id,
        name: p.name,
        description: p.description,
        sku: p.sku,
        manufacturer: p.manufacturer,
        quantity: p.quantity,
        date_added: p.date_added,
        date_last_updated: p.date_last_updated,
        owner_user_id: p.owner_user_id
    })}else{res.status(403).send("Forbidden");}
})
}
  
const deleteProduct = async (req, res) => {

    const id = req.params.id;
    if(id>0){
    Product.findOne({where:{id:id}}).then((results) => {  //Check if the Product ID exists or not
    if(results){

        if(req.get('Authorization')){   //Check if the Basic Authentication is Enabled or not
            const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':') //Authentication
            const username = credentials[0]
            const password = credentials[1]
            User.findOne({where:{username:username}}).then((r)=>{  //Check if the username exists or not
                if(r){  console.log("Inside the r")
                bcrypt.compare(password, r.password, (err, result) => { //Check if the password matches
                    if(result){ console.log("Inside the result")

                        Product.destroy({where:{id:id, owner_user_id:r.id}}).then((del)=>{  // Delete the product if the id and the user id matches
                            if(del){
                               
                                res.status(204).send();}
                            else{
                                res.status(403).send("Forbidden");}
                        })


                    }else {res.status(401).send("Unauthorized");}
                })
            } else {res.status(401).send("Unauthorized");}
        
        })
            }  else {res.status(400).send("Bad Request");} 


    }else {res.status(404).send("Not Found");}

})
    }else {res.status(403).send("Forbidden");} 
} 


const patchProduct = async (req, res) => {
    Objbg = {                                      // Creating a JSON Object with required variables of Payload.
        "name": req.body.name,
        "description": req.body.description,
        "sku": req.body.sku,
        "manufacturer": req.body.manufacturer,
        "quantity": req.body.quantity     
    };


    const id = req.params.id;
    if(id>0){
    Product.findOne({where:{id:id}}).then((results) => {  //Check if the Product ID exists or not
    if(results){

        if(req.get('Authorization')){   //Check if the Basic Authentication is Enabled or not
            const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':') //Authentication
            const username = credentials[0]
            const password = credentials[1]
            User.findOne({where:{username:username}}).then((r)=>{  //Check if the username exists or not
                if(r){  
                bcrypt.compare(password, r.password, (err, result) => { //Check if the password matches
                    if(result){ 

                        if(JSON.stringify(req.body)==JSON.stringify(Objbg)){  //Check if the required fields are there or not
                            const date = new Date();
                            const info ={
                    
                                "name": req.body.name,
                                "description": req.body.description,
                                "sku": req.body.sku,
                                "manufacturer": req.body.manufacturer,
                                "quantity": req.body.quantity,
                                "date_last_updated":date.toISOString()
                              }

                              if(req.body.sku === undefined){

                                

                                if(validateThree(req)&&validateOne(req)){
                                Product.update(info, {where: {id: id, owner_user_id:r.id}} ).then((sanju)=>{  //Update the product if the user id is matching
    
                                    if(sanju[0]){res.status(204).send("No Content");}  //Updated successfully
                                    else{res.status(400).send("Bad Request");}   //Send a Bad Request if the User ID is not matching
            
                                })
                                                                
                            } else{res.status(400).send("Bad Request");}  // Send a Bad Request if quantity validation does not pass
                              }
                              else{
                                Product.findOne({where:{sku:req.body.sku}}).then((r1) =>{
                                    if(r1){
                                        if(r1.id != id){
                                            res.status(400).send("Bad Request");
                                            console.log("Inside if r1");
        
                                        }
                                        else{

                                            if(validateThree(req)&&validateOne(req)){
                                            console.log("inside if r1 --2")
                                            Product.update(info, {where: {id: id, owner_user_id:r.id}} ).then((sanju)=>{  //Update the product if the user id is matching
    
                                                if(sanju[0]){res.status(204).send("No Content");}  //Updated successfully
                                                else{res.status(403).send("Forbidden");}   //Send a Bad Request if the User ID is not matching
                        
                                            })
                                        } else{res.status(400).send("Bad Request");}  //Send a Bad Request if the quantity validation does not pass

                                        }

                                    }
                                    else{
                                        Product.update(info, {where: {id: id, owner_user_id:r.id}} ).then((sanju)=>{  //Update the product if the user id is matching
    
                                            if(sanju[0]){res.status(204).send("No Content");}  //Updated successfully
                                            else{res.status(403).send("Forbidden");}   //Send Forbidden if the User ID is not matching
                    
                                        })

                                    }
                                })

                              }
                          

                        } else{res.status(400).send("Bad Request");} //Send a Bad Request of the Required fields are not there

                    }else {res.status(401).send("Unauthorized");} // Send Unauthorized if the Password Does not Match
                })
            } else {res.status(401).send("Unauthorized");} //If the Username does not match or exist
        
        })
            }  else {res.status(400).send("Bad Request");} //If Authorization is not enabled


    }else {res.status(403).send("Forbidden");} //Forbidden if the ID does not exist

})
    }else {res.status(403).send("Forbidden");} 

}


const validateTwo = (req) => {
    if(!(req.body.sku===undefined) && !(req.body.manufacturer===undefined )&&!(req.body.name===undefined) &&!(req.body.description===undefined)&&!(req.body.quantity==undefined)) {

        return true
    }
    return false
}

const validateThree = (req) => {
    const id = req.params.id;
    if(!(req.body.quantity===undefined)){  
        if(req.body.quantity>=0 && req.body.quantity<=100 ){ 
               return true;

        }else{return false;}}

        else{return true;}

}

const validateOne = (req) => {
    const regex =  "^\\s*$";
    const re =  '^[A-Za-z ]+';
    if(!(req.body.quantity===undefined)){  
    if(!req.body.description.match(regex) && req.body.description == null) {
        
        return true
    }
    return false}
    else{return true;}

}

module.exports = {
    addProduct,
    getAllProducts, 
    updateProduct,
    getProduct,
    deleteProduct,
    patchProduct
}