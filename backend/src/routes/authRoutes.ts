import * as express from "express";
import { getAdmin, loginUser, refreshToken } from "../controllers/authController";
import { registerUser } from "../controllers/authController";
import { authMiddleware } from "../middlewares/middleware";
const authRouter = express.Router();


authRouter.post("/login",loginUser);
authRouter.post("/register",registerUser);
authRouter.post("/me",authMiddleware,getAdmin);

authRouter.post("/refresh",refreshToken);

export default authRouter;