import cors from "cors";
import express, { json, urlencoded } from "express";
import mongoose from "mongoose";
import Product from "./product.js"; // Import the Product model

const app = express();
const uri = "mongodb+srv://raean1122:raean1122@cluster0.uzrek.mongodb.net/flutter";



// Middleware should be set up before defining routes
app.use(json());
app.use(cors());
app.use(urlencoded({ extended: true }));
 

 
// Connect to MongoDB using Mongoose
mongoose.connect(uri, {
    
}).then(() => console.log("Connected to MongoDB"))
    .catch(err => console.error("MongoDB connection error:", err));

// POST: Add a new product
app.post("/api/add_product", async (req, res) => {
    console.log("Received data:", req.body);

    try {
        let newProduct = new Product(req.body);
        let savedProduct = await newProduct.save();
        res.status(201).json(savedProduct);
    } catch (error) {
        res.status(400).json({ "status": error.message });
    }
});

// GET: Retrieve all products
app.get("/api/get_product", async (req, res) => {
    try {
        let data = await Product.find();

        res.status(200).json(data);
    } catch (e) {
        console.log(e.message);
        res.status(500).json(e.message);
    }
});

app.patch("/api/update/:id", async (req, res) => {
    let id = req.params.id;
    let updatedData = req.body;
    let options = { new: true };
    try {


        const data = await Product.findByIdAndUpdate(id, updatedData, options);
        res.send(data);
    } catch (e) {
        console.log(e.message);
        res.status(500).json(e.message);
    }
})

// DELETE: Remove a product by ID
app.delete("/api/delete/:id", async (req, res) => {
    let id = req.params.id;
    try{
        const data = await Product.findByIdAndDelete(id);
        res.json({
            "status": "Deleted the producted ${data.pname} from database"
        });
    }catch(e){
        console.log(e.message);
        res.json(e.message);
    }
});

// Start the server
app.listen(2000, "0.0.0.0", () => {
    console.log("Server running on port 2000");
});
