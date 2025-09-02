import express, { Request, Response } from 'express';
import cors from "cors"
import cookieParser from "cookie-parser"

import dotenv from "dotenv"
import authRouter from './routes/authRoutes';
import musicRouter from './routes/musicRoutes';

const app = express();
const PORT = process.env.PORT ? parseInt(process.env.PORT) : 5000;
dotenv.config();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors(
    {
        origin:"*",
        credentials: true,
    }
))

app.use(cookieParser());

app.use("/auth", authRouter);
app.use("/music",musicRouter);

app.get('/', (req: Request, res: Response) => {
  res.send('Hello, TypeScript Backend!');
});

app.listen(PORT, "0.0.0.0",() => {
  console.log(`Server is running at http://localhost:${PORT}`);
});

