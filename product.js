import mongoose from "mongoose";

let dataschem=new mongoose.Schema({
    "pname": {
        required: true,
        type: String,
    }, 
    "pprice": {
        required: true,
        type: String,
    }, 
    "pdes": {
        required: true,
        type: String,
    }, 
    
});

export default mongoose.model("products", dataschem);