import * as express from "express";
import { authMiddleware } from "../middlewares/middleware";
import { searchMusic } from "../controllers/musicController";

const musicRouter = express.Router();

musicRouter.post("/search",authMiddleware,searchMusic);
// musicRouter.post("/song/:vedioId",videoId);
// musicRouter.post("/home",home)

 export default musicRouter;