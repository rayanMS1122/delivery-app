import express from "express";
import cors from "cors";
import mongoose from "mongoose";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import authRoutes from "./routes/auth.js";
import Product from "./product.js";
import Order from "./orders.js";
import Cart from "./carts.js";

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI;

// Get directory name in ES module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (for profile images)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use("/auth", authRoutes);

// Connect to MongoDB
mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("MongoDB connection error:", err));

// Product Routes
app.post("/api/add_product", async (req, res) => {
  try {
    const newProduct = new Product(req.body);
    const savedProduct = await newProduct.save();
    res.status(201).json(savedProduct);
  } catch (error) {
    res.status(400).json({ status: error.message });
  }
});

app.get("/api/get_product", async (req, res) => {
  try {
    const data = await Product.find();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.put("/api/update/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const updatedData = req.body;
    const options = { new: true };
    const data = await Product.findByIdAndUpdate(id, updatedData, options);
    
    if (!data) {
      return res.status(404).json({ error: "Product not found" });
    }
    
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.delete("/api/delete/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const data = await Product.findByIdAndDelete(id);
    
    if (!data) {
      return res.status(404).json({ error: "Product not found" });
    }
    
    res.status(204).json({ status: `Deleted the product ${data?.pname} from database` });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Order Routes
app.get("/api/get_orders", async (req, res) => {
  try {
    const data = await Order.find();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Create new order
app.post("/api/create_order", async (req, res) => {
  try {
    const newOrder = new Order(req.body);
    const savedOrder = await newOrder.save();
    res.status(201).json(savedOrder);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Cart Routes
app.get("/api/get_carts", async (req, res) => {
  try {
    const data = await Cart.find();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Add to cart
app.post("/api/add_to_cart", async (req, res) => {
  try {
    const newCartItem = new Cart(req.body);
    const savedCartItem = await newCartItem.save();
    res.status(201).json(savedCartItem);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Remove from cart
app.delete("/api/remove_from_cart/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const data = await Cart.findByIdAndDelete(id);
    
    if (!data) {
      return res.status(404).json({ error: "Cart item not found" });
    }
    
    res.status(200).json({ status: "Item removed from cart" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({ status: "Server is running" });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
