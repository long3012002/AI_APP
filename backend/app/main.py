# backend/app/main.py
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse, FileResponse
from fastapi.middleware.cors import CORSMiddleware
from pathlib import Path
import shutil, os
from .model import YOLOModel

app = FastAPI(title="YOLOv8 FastAPI")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # dev: allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = Path(__file__).resolve().parents[1]  # backend/
UPLOAD_DIR = BASE_DIR / "uploads"
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

# load model once
model = YOLOModel(model_path="yolov8n.pt", out_dir=str(BASE_DIR / "results"))

@app.get("/")
def read_root():
    return {"message": "YOLOv8 FastAPI running"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    # validate filename
    if not file.filename:
        raise HTTPException(status_code=400, detail="No file uploaded")

    # save upload
    save_path = UPLOAD_DIR / file.filename
    with open(save_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # run model
    try:
        annotated_path, detections = model.predict_and_save(str(save_path))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Inference error: {e}")

    return JSONResponse({
        "image": annotated_path,   # path on backend filesystem
        "detections": detections
    })

@app.get("/image")
def get_image(path: str):
    p = Path(path)
    if not p.exists():
        raise HTTPException(status_code=404, detail="Image not found")
    return FileResponse(p)
