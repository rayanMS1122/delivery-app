import { Router } from "express";
import { hash, compare } from "bcrypt";
import pkg from "jsonwebtoken";
import multer from "multer";
import path from "path";
import fs from "fs";
const { sign, verify } = pkg;
import User from "../User.js";

const router = Router();

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadDir = 'uploads/profile_images';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    cb(null, `profile-${uniqueSuffix}${ext}`);
  }
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const mimetype = allowedTypes.test(file.mimetype);
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error("Only image files are allowed"));
  }
});

// Middleware to authenticate token
const authenticateToken = (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Access denied. No token provided." });
    }

    const token = authHeader.split(" ")[1];
    const verified = verify(token, process.env.JWT_SECRET);
    req.userId = verified.userId;
    next();
  } catch (err) {
    res.status(401).json({ message: "Invalid token" });
  }
};

// Sign Up
router.post("/register", async (req, res) => {
  try {
    const { email, password, name } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Hash the password
    const hashedPassword = await hash(password, 10);

    // Create a new user
    const newUser = new User({ 
      email, 
      password: hashedPassword, 
      name,
      profile_image: null,
      address: null,
      phone: null
    });
    
    await newUser.save();

    // Respond with success message
    res.status(201).json({ message: "User created successfully" });
  } catch (err) {
    res.status(500).json({ error: "Error creating user: " + err.message });
  }
});

// Login
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Verify password
    const isMatch = await compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate JWT Token
    const token = sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d", // Extended token expiration to 7 days
    });

    // Respond with token and user data (excluding the password)
    const userData = {
      _id: user._id,
      email: user.email,
      name: user.name,
      profile_image: user.profile_image,
      address: user.address,
      phone: user.phone
    };

    res.status(200).json({ token, user: userData });
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get user profile
router.get("/profile", authenticateToken, async (req, res) => {
  try {
    // Find the user by ID and exclude the password field
    const user = await User.findById(req.userId).select("-password");
    
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Respond with the user profile
    res.status(200).json(user);
  } catch (err) {
    console.error("Error in profile route:", err.message);
    res.status(500).json({ message: "Server error: " + err.message });
  }
});

// Update user profile
router.put("/update-profile", authenticateToken, async (req, res) => {
  try {
    const { name, email, phone, address } = req.body;
    
    // Find user and update fields
    const updatedUser = await User.findByIdAndUpdate(
      req.userId,
      { 
        name, 
        email,
        phone,
        address
      },
      { new: true }
    ).select("-password");
    
    if (!updatedUser) {
      return res.status(404).json({ message: "User not found" });
    }
    
    res.status(200).json({ 
      message: "Profile updated successfully", 
      user: updatedUser
    });
  } catch (err) {
    res.status(500).json({ message: "Error updating profile: " + err.message });
  }
});

// Upload profile image
router.post("/upload-profile-image", authenticateToken, upload.single('profile_image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No image file provided" });
    }
    
    // Generate URL for the image
    const serverUrl = `${req.protocol}://${req.get('host')}`;
    const imageUrl = `${serverUrl}/${req.file.path}`;
    
    // Update user profile with image URL
    const updatedUser = await User.findByIdAndUpdate(
      req.userId,
      { profile_image: imageUrl },
      { new: true }
    ).select("-password");
    
    if (!updatedUser) {
      return res.status(404).json({ message: "User not found" });
    }
    
    res.status(200).json({ 
      message: "Profile image uploaded successfully", 
      imageUrl: imageUrl,
      user: updatedUser
    });
  } catch (err) {
    res.status(500).json({ message: "Error uploading image: " + err.message });
  }
});

// Change password
router.put("/change-password", authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    
    // Find the user
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    
    // Verify current password
    const isMatch = await compare(currentPassword, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Current password is incorrect" });
    }
    
    // Hash the new password
    const hashedPassword = await hash(newPassword, 10);
    
    // Update the password
    user.password = hashedPassword;
    await user.save();
    
    res.status(200).json({ message: "Password changed successfully" });
  } catch (err) {
    res.status(500).json({ message: "Error changing password: " + err.message });
  }
});

// Logout
router.post("/logout", authenticateToken, (req, res) => {
  // In a stateless JWT auth system, the server doesn't need to do anything for logout
  // The client is responsible for removing the token
  res.status(200).json({ message: "Logged out successfully" });
});

export default router;