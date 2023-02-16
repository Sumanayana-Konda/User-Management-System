const express = require('express')
const cors = require('cors')

const app = express()

var corOptions = {
    origin:'https://localhost:3000'
}

const router = require('./routes/userRoutes.js')
const ro = require('./routes/productRoutes.js');
//middleware
app.use(cors(corOptions))
app.use(express.json())

app.use(express.urlencoded({extended:true}))
//testing api

app.get('/healthz', (req, res)=>{
    res.status(200).send("Its healthy");
})

const PORT = process.env.PORT || 3000

app.use('/v1/user', router);
app.use('/v1/product', ro);
app.listen(PORT, () =>{
    console.log(`server is running on port ${PORT}`)
})

module.exports = app;