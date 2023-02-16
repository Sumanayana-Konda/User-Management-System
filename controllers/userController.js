const db = require('../models');
const bcrypt = require("bcrypt")     
//create main model

const User = db.stud
const Product = db.product


//1. Create Users

const addUsers = async(req, res)=>{


    Objbg = {                                      // Creating a JSON Object with required variables of Payload.
        "first_name": req.body.first_name,
        "last_name": req.body.last_name,
        "password": req.body.password,
        "username": req.body.username        
    };
    const date = new Date(); //Check for validations
    if(validateThree(req)&&validateTwo(req)&&validateOne(req)&&(JSON.stringify(req.body) == JSON.stringify(Objbg))){

    const username = req.body.username; 
    let u = await User.findOne({where:{username:username}})  //Check if the username exists or not
    if(!u){

        bcrypt.hash(req.body.password, 10).then(hash => {  //Bcrypting the password 
        let info ={
            first_name: req.body.first_name,
            last_name: req.body.last_name,
            username: req.body.username,
            password: hash,
            account_created: date.toISOString(),
            account_updated: date.toISOString()
        }

  User.create(info).then((user)=>{ //Creating the user and pushing it to the database
    res.status(200).send({

       "id": user.id,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "username": user.username,
        "account_created": user.account_created,
        "account_updated": user.account_updated

    })})
 }) }
    else{res.status(400).send("Bad Request");} //Send Bad request if the email already exists
}
    else{res.status(400).send("Bad Request");} //Send Bad Request if the validations do not pass

}
// Get all Users
const getAllUsers = async (req, res) => {


    let users = await User.findAll({
        attributes: [
            'id',
            'first_name',
            'last_name',
            'username',
            'account_created',
            'account_updated'
        ]
    })
    res.status(200).send(users)

}

//Get Single User

const getUser = async (req, res) => {
    let id = req.params.id;
    if(id>0){
    
     if(req.get('Authorization')){ //Check for Authorization

        const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':')
        const username = credentials[0]
        const password = credentials[1]

        let users = await User.findOne({where:{id:id, username:username}}) //Check if the user exists or not/Username is matching or not
        if(users){

    bcrypt.compare(password, users.password, (err, result) => { //Check if the Password match or not
        if(result){
         const p = users;
    res.status(200).send({ //Send the User details
        id: p.id,
        first_name: p.first_name, 
        last_name: p.last_name,
        username: p.username,
        account_created: p.account_created,
        account_updated: p.account_updated
    })}
    else{
        res.status(401).send("Unauthorized"); //Send Unauthorized if the Password does not match
    }

})}
else {res.status(401).send("Unauthorized");} //Send Unauthorized if the Username does not match
}
else{res.status(403).send("Forbidden");}  //Send Forbidden if the authorization is not given }
}else{res.status(403).send("Forbidden")}
}

//Update User

const updateUsers = async (req, res) => {
  const date = new Date();
    const id = req.params.id;
    if(id>0){
    Objbg = {                                      // Creating a JSON Object with required variables of Payload.
        "first_name": req.body.first_name,
        "last_name": req.body.last_name,
        "password": req.body.password,
        "username": req.body.username        
    };
    if(validateThree(req)&&validateTwo(req)&&validateOne(req)&&(JSON.stringify(req.body) == JSON.stringify(Objbg))){ //Check the validations
    let u = await User.findOne({where:{id:id}})
    if(!u){res.status(403).send("Forbidden");} //Check if the ID exists or not
    else {

        if(req.get('Authorization')){
            const credentials = Buffer.from(req.get('Authorization').split(' ')[1], 'base64').toString().split(':')
            const username = credentials[0];
            const password = credentials[1];  //Check the authentication

            if( username == u.username){   //Check if the Username is matching the ID


    bcrypt.compare(password, u.password, (err, result) => { //Check if the Password is matching

        if(result){

    bcrypt.hash(req.body.password, 10).then(hash => {
        
        if(u.username == req.body.username){ //Check if they are trying to update the username
//Check if all the values entered are unique or not
            if(u.first_name==req.body.first_name && u.last_name==req.body.last_name && req.body.password==password){

                res.status(203).send("No Update necessary"); //If all the values are the same no updation is required
            }

            else{

    info ={
        first_name: req.body.first_name,
        last_name: req.body.last_name,
        password: hash,
        account_updated: date.toISOString()
    }
    const user = User.update(info, {where: {id: id}} ) //Update the User
    res.status(204).send()}}  
    else{res.status(401).send("Forbidden");}//Send Forbidden if the Username is trying to be updated

   

})


}
    else{res.status(401).send("Unauthorized")} //Send Unauthorized if the Password is not matching
})
        }
        else{res.status(401).send("Unauthorized")} //Send Unauthorized if the username is not matching

}

else{res.status(403).send("Forbidden")} //Send Forbidden if there is no Authorization

}}

    else{res.status(400).send("Bad Request");} //Send Bad Request if the validations are not passing

}else{res.status(403).send("Forbidden")} 
}

const validateOne = (req) => {
    const regex =  "^\\s*$";
    const re =  '^[A-Za-z ]+';
    if(!req.body.first_name.match(regex)&&!req.body.last_name.match(regex)&&!req.body.password.match(regex) &&
    req.body.first_name.match(re) && req.body.last_name.match(re)) {
        
        return true
    }
    return false
}
// Function to check if the required fields is present or not in the payload 
const validateTwo = (req) => {
    const regex =  "^\\s*$";
    if(!(req.body.username===undefined) && !(req.body.password===undefined )&&!(req.body.first_name===undefined) &&!(req.body.last_name===undefined)) {

        return true
    }
    return false
}
// Function to check if the entered email is in the right format or not
const validateThree = (req) => {
    const regex =  "^\\s*$";
    const emailFormat = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/; 
    if(req.body.username?.match(emailFormat)) {
        return true
    }
    return false
}

module.exports = {
    addUsers,
    getAllUsers,
    getUser,
    updateUsers
}