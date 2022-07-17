import { Request, Response } from "express";


export async function test(req: Request, res: Response) {
    const { body } = req;
    res.status(200).send({
        data: {
            message: 'test'
        }
    })
}