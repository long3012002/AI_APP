# backend/app/model.py
from ultralytics import YOLO
from pathlib import Path
import os

class YOLOModel:
    def __init__(self, model_path="yolov8n.pt", out_dir="backend/results"):
        self.model = YOLO(model_path)
        self.out_dir = Path(out_dir)
        self.out_dir.mkdir(parents=True, exist_ok=True)

    def predict_and_save(self, img_path: str):
        # Run inference
        results = self.model(img_path)  # returns list-like Results
        # Save annotated image (ultralytics save default into runs/predict; use results.save())
        # We'll save the first annotated image to our out_dir with same filename
        save_path = self.out_dir / Path(img_path).name
        results[0].save(self.out_dir)  # this writes file under out_dir/<imagename>
        # Build detections
        detections = []
        for box in results[0].boxes:
            xyxy = box.xyxy[0].tolist()  # [x1, y1, x2, y2]
            conf = float(box.conf[0]) if hasattr(box.conf, 'tolist') else float(box.conf)
            cls = int(box.cls[0]) if hasattr(box.cls, 'tolist') else int(box.cls)
            name = self.model.names.get(cls, str(cls))
            detections.append({
                "class": name,
                "confidence": conf,
                "bbox": [float(x) for x in xyxy]
            })
        return str(save_path), detections
