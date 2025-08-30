import { Request, Response } from "express";
import * as jwt from "jsonwebtoken"
import * as z from 'zod';
import { prisma } from "../prisma";
import { AuthRequest } from "../middlewares/middleware";
import path from "path";
import { spawn } from "child_process";

export const searchMusic = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const query = req.query.q as string;

        if (!query) {
            res.status(400).json({ error: "A search query is required" });
            return;
        }

        const pythonExecutable = path.resolve(process.cwd(), "venv/bin/python");
        const pythonScript = path.resolve(process.cwd(), 'search.py');

        const pythonProcess = spawn(pythonExecutable, [pythonScript, query]);


        let searchResults = '';
        let searchError = '';

        pythonProcess.stdout.on('data', (data) => {
            searchResults += data.toString();
        });

        pythonProcess.stderr.on('data', (data) => {
            searchError += data.toString();
        });

        pythonProcess.on('close', (code) => {
            if (code !== 0) {
                console.error(`Python script error: ${searchError}`);
                res.status(500).json({ message: 'Failed to fetch search results.', error: searchError });
                return;
            }

            try {
                // 6. Parse and send the results
                const jsonData = JSON.parse(searchResults);
                res.status(200).json(jsonData);
            } catch (error) {
                console.error('Error parsing JSON from Python script:', error);
                res.status(500).json({ message: 'Failed to parse search results.' });
            }
        });

    } catch (error) {
        console.error('Error in search controller:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
}