import { Request, Response } from "express"
import * as jwt from "jsonwebtoken"
import * as z from "zod";
import { prisma } from "../prisma";
import bcrypt from "bcryptjs";
import { AuthRequest } from "../middlewares/middleware";

const generateToken = (res: Response, userId: string): void => {
    try {
        if (!process.env.JWT_SECRET) {
            throw new Error("JWT_SECRET is not defined in environment variables");
        }

        const access_token = jwt.sign({ id: userId }, process.env.JWT_SECRET as string, { expiresIn: '1h' });
        const refresh_token = jwt.sign({ id: userId }, process.env.JWT_SECRET as string, { expiresIn: '7d' });
        const cookieOptions = {
            httpOnly: true,
            secure: process.env.NODE_ENV !== 'development',
            maxAge: 7 * 24 * 60 * 60 * 1000,
            sameSite: 'strict' as const,
            path: '/',
        };
        res.cookie('access_token', access_token, { ...cookieOptions, maxAge: 60 * 60 * 1000 });
        res.cookie('refresh_token', refresh_token, cookieOptions);
    } catch (error) {
        console.error("Error generating tokens:", error);
        throw new Error("Failed to generate authentication tokens.");
    }
};

export const loginUserSchema = z.object({
    email: z.string().email("Invalid email format").nonempty(),
    password: z.string().min(6, "Password must be at least 6 characters").nonempty(),
});

export const registerUserSchema = z.object({
    email: z.string().email("Invalid email").nonempty(),
    password: z.string().min(6, "Password must be at least 6 characters").nonempty(),
})

export type LoginUserPayload = z.infer<typeof loginUserSchema>;


export const loginUser = async (req: Request<{}, {}, LoginUserPayload>, res: Response): Promise<void> => {
    try {
        const parseResult = loginUserSchema.safeParse(req.body);

        if (!parseResult.success) {
            res.status(400).json({ errors: parseResult.error.flatten().fieldErrors });
            return;
        }
        const { email, password } = parseResult.data;

        const user = await prisma.user.findUnique({
            where: {
                email
            },
        });
        if (!user) {
            res.status(401).json({ message: "Invalid credentials.", ok: false });
            return;
        }

        const isPasswordCorrect = await bcrypt.compare(password, user.password);
        if (!isPasswordCorrect) {
            res.status(401).json({ message: "Invalid credentials.", ok: false });
            return;
        }
        generateToken(res, user.id);
        res.status(200).json({
            message: "Login successful.", ok: true, user: {
                email: user.email,
            }
        });


    } catch (error) {
        res.status(401).json({ message: "Invalid credentials", ok: false });

    }
}


export const registerUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const parseResult = registerUserSchema.safeParse(req.body);
        if (!parseResult.success) {
            console.log((parseResult.error.flatten().fieldErrors));
            
            res.status(400).json({ errors: parseResult.error.flatten().fieldErrors });
            return;
        }

        const { email, password } = parseResult.data;

        const existingUser = await prisma.user.findUnique({
            where: { email },
        });

        if (existingUser) {
            res.status(400).json({ message: "User already exists", ok: false });
            return;
        }

        const salt = await bcrypt.genSalt(12);


        const hashedPassword = await bcrypt.hash(password, salt);

        const newUser = await prisma.user.create({
            data: {

                email,
                password: hashedPassword,
            }
        });

        generateToken(res, newUser.id);

        res.status(201).json({
            message: "User registered successfully",
            ok: true,
            user: {
                email: newUser.email,
            },
        });
    } catch (error) {
        console.error("Error registering user:", error);
        res.status(500).json({ message: "Internal server error", ok: false });
    }
};

export const getAdmin = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const userId = req.user?.id
        if (!userId || userId.length == 0) {
            res.status(400).json({ error: "User not authenticated" });
            return;
        }

        const user = await prisma.user.findFirst({
            where: {
                id: userId
            }
        });

        if (!user) {
            res.clearCookie("access_token");
            res.clearCookie("refresh_token");

            res.status(401).json({ message: "User not found, tokens cleared." });
            return;
        }

        res.status(200).json({ email: user?.email });
    } catch (error) {
        console.error("Error fetching user:", error);
        res.status(500).json({ message: "Internal server error", ok: false });

    }
}
