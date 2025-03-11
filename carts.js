import mongoose from "mongoose";

let dataschem=new mongoose.Schema({

    "_id": {
        required: true,
        type: String,
    }, 

    "pname": {
        required: true,
        type: String,
    }, 
    "pprice": {
        required: true,
        type: String,
    }, 
    "pimage": {
        required: true,
        type: String,
    }, 
    "pamount": {
        required: true,
        type: String,
    }, 
});

 
export default mongoose.model("carts", dataschem);