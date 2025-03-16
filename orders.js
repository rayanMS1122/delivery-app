import mongoose from "mongoose";

let dataschem=new mongoose.Schema({
    "porder_id": {
        required: true,
        type: String,
    }, 
    "porder_date": {
        required: true,
        type: String,
    }, 
    "pstatus": {
        required: true,
        type: String,
    }, 
    "pitems_count": {
        required: true,
        type: String,
    }, 
    "total_price": {
        required: true,
        type: String,
    }, 
});

 
export default mongoose.model("orders", dataschem);