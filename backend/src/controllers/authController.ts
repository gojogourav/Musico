import { Request, Response } from "express"
import * as jwt from "jsonwebtoken"
import * as z from "zod";
import { prisma } from "../prisma";
import bcrypt from "bcryptjs";
import { AuthRequest } from "../middlewares/middleware";



type Tokens = {
    access_token: string;
    refresh_token: string;
};


const generateToken = (res: Response, userId: string): Tokens => {
    try {
        if (!process.env.JWT_SECRET) {
            throw new Error("JWT_SECRET is not defined in environment variables");
        }

        const access_token = jwt.sign({ id: userId }, process.env.JWT_SECRET as string, { expiresIn: '1h' });
        const refresh_token = jwt.sign({ id: userId }, process.env.JWT_SECRET as string, { expiresIn: '7d' });
        // const cookieOptions = {
        //     httpOnly: true,
        //     secure: process.env.NODE_ENV !== 'development',
        //     maxAge: 7 * 24 * 60 * 60 * 1000,
        //     sameSite: 'strict' as const,
        //     path: '/',
        // };
        // res.cookie('access_token', access_token, { ...cookieOptions, maxAge: 60 * 60 * 1000 });
        // res.cookie('refresh_token', refresh_token, cookieOptions);

        return { access_token, refresh_token }; // 👈 NEW: return them

    } catch (error) {
        console.error("Error generating tokens:", error);
        throw new Error("Failed to generate authentication tokens.");
    }
};

export const loginUserSchema = z.object({
    username: z.string().nonempty().optional(),
    email: z.string().email("Invalid email format").optional(),
    password: z.string().min(6, "Password must be at least 6 characters"),
}).refine((data) => data.username || data.email, {
    message: "Either username or email is required",

});

export const registerUserSchema = z.object({
    name: z.string(),
    username: z.string().max(20),
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
        const { username, email, password } = parseResult.data;

        const orConditions: any[] = [];
        if (username) orConditions.push({ username });
        if (email) orConditions.push({ email });

        const user = await prisma.user.findFirst({
            where: {
                OR: orConditions

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
        const tokens = generateToken(res, user.id);
        res.status(200).json({
            message: "Login successful.", ok: true, user: {
                email: user.email
            },
            ...tokens
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

        const { email, password, username, name } = parseResult.data;

        const existingUser = await prisma.user.findFirst({
            where: {
                OR: [
                    { username },
                    { email }
                ]
            },
        });

        if (existingUser) {
            res.status(400).json({ message: "User already exists", ok: false });
            return;
        }

        const salt = await bcrypt.genSalt(12);

        const hashedPassword = await bcrypt.hash(password, salt);

        const newUser = await prisma.user.create({
            data: {
                name: name,
                username,
                email,
                password: hashedPassword,
            }
        });

        const tokens = generateToken(res, newUser.id);

        res.status(201).json({
            message: "User registered successfully",
            ok: true,
            user: {
                email: newUser.email,
            },
            ...tokens
        });
    } catch (error) {
        console.error("Error registering user:", error);
        res.status(500).json({ message: "Internal server error", ok: false });
    }
};


export const refreshToken = async (req: Request, res: Response) => {
    const { token: refreshToken } = req.body;

    if (!refreshToken) {
        res.status(401).json({ message: "Refresh token not provided." });
        return;
    }

    if (!process.env.JWT_SECRET) {
        console.error("JWT_REFRESH_SECRET is not defined.");
        return res.status(500).json({ message: "Server configuration error." });
    }

    
    try {
        const decoded = await jwt.verify(refreshToken, process.env.JWT_SECRET) as { id: string };

        // Ensure the user still exists in the database
        const user = await prisma.user.findUnique({
            where: { id: decoded.id },
            select: { id: true }
        });

        if (!user) {
            return res.status(404).json({ message: "User not found." });
        }

        const newTokens = generateToken(res,decoded.id);

        return res.status(200).json({
            message: "Tokens refreshed successfully.",
            ok: true,
            tokens: newTokens
        });

    } catch (error) {
        console.error("Refresh token error:", error);
        if (error instanceof jwt.TokenExpiredError) {
            return res.status(403).json({ message: "Refresh token has expired. Please log in again." });
        }
        if (error instanceof jwt.JsonWebTokenError) {
            return res.status(403).json({ message: "Invalid refresh token." });
        }
        return res.status(500).json({ message: "Could not refresh token due to an internal error." });
    }

}

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
