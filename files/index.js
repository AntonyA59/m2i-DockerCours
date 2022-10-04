const EXPRESS = require('express');

const APP = EXPRESS();
APP.get('/',(req,res) =>{
    res.send("Bonjour depuis mon serveur node.js")
})

APP.listen(80, ()=>{
    console.log("App is running")
})
