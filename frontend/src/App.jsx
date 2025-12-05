// frontend/src/App.jsx
import { useState } from "react";

const BACKEND = "http://127.0.0.1:8000";

function App() {
  const [file, setFile] = useState(null);
  const [result, setResult] = useState(null);
  const [imgUrl, setImgUrl] = useState(null);

  const onFileChange = (e) => {
    if (e.target.files.length > 0) {
      setFile(e.target.files[0]);
    }
  };

  const upload = async () => {
    if (!file) return alert("Chọn ảnh trước");
    const form = new FormData();
    form.append("file", file);
    const res = await fetch(`${BACKEND}/predict`, {
      method: "POST",
      body: form
    });
    const data = await res.json();
    setResult(data);
    // build URL to annotated image
    const imgPath = encodeURIComponent(data.image);
    setImgUrl(`${BACKEND}/image?path=${imgPath}`);
  };

  return (
    <div style={{padding:20}}>
      <h2>YOLOv8 Demo</h2>
      <input type="file" onChange={onFileChange} />
      <button onClick={upload} style={{marginLeft:10}}>Upload & Infer</button>

      {imgUrl && (
        <div style={{marginTop:20}}>
          <h3>Kết quả (ảnh chú thích)</h3>
          <img src={imgUrl} alt="result" style={{maxWidth:'100%'}} />
        </div>
      )}

      {result && (
        <div style={{marginTop:20}}>
          <h3>Detections</h3>
          <pre>{JSON.stringify(result.detections, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
