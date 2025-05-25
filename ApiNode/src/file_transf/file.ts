import { getStorage, ref, getDownloadURL } from 'firebase/storage';
import { Request, Response } from 'express';

export async function getFirebaseFileURL(req: Request, res: Response): Promise<Response> {
  const filePath = req.body.filePath;

  if (!filePath) {
    return res.status(400).json({
      success: false,
      message: "File path is missing in the request body"
    });
  }

  try {
    const storage = getStorage();
    const storageRef = ref(storage, filePath);

    const downloadURL = await getDownloadURL(storageRef);

    return res.status(200).json({
      success: true,
      message: "File download URL fetched successfully",
      downloadURL: downloadURL
    });
  } catch (error) {
    console.error("Erreur lors de la récupération de l'URL: ", error);

    return res.status(404).json({
      success: false,
      message: "File not found in Firebase Storage",
      error: error
    });
  }
}
