from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import json, pickle, numpy as np, random
from datetime import timedelta
from tensorflow.keras.models import load_model  # type: ignore
import sqlite3

app = Flask(__name__)
CORS(app)
bcrypt = Bcrypt(app)
app.config["JWT_SECRET_KEY"]           = "growmate-secret-key-2025"
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(days=30)
jwt = JWTManager(app)

DB_PATH      = "growmate.db"
INTENTS_PATH = r"model/merged_intents.json"

# ─── DATABASE ─────────────────────────────────────────────────────────────────
import sqlite3

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

conn = sqlite3.connect("growmate.db")
c = conn.cursor()
c.execute("SELECT name FROM sqlite_master WHERE type='table';")
print(c.fetchall())
conn.close() 

def init_db():
    conn = get_db()
    c = conn.cursor()

    c.execute('''CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        password TEXT NOT NULL,
        crop_type TEXT DEFAULT "Paddy",
        region TEXT DEFAULT "Central",
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )''')

    c.execute('''CREATE TABLE IF NOT EXISTS reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        reminder_type TEXT NOT NULL,
        crop_type TEXT NOT NULL,
        field_name TEXT NOT NULL,
        date_time TEXT NOT NULL,
        notes TEXT,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )''')

    c.execute('''CREATE TABLE IF NOT EXISTS market_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        unit TEXT NOT NULL,
        weight TEXT,
        category TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT,
        stock TEXT DEFAULT "In Stock",
        badge TEXT DEFAULT "New",
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )''')

    c.execute('''CREATE TABLE IF NOT EXISTS machines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        machine_type TEXT NOT NULL,
        price_per_day REAL NOT NULL,
        location TEXT NOT NULL,
        description TEXT,
        availability INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )''')

    conn.commit()
    conn.close()
    print("✅ Database ready")

# ─── CHATBOT ──────────────────────────────────────────────────────────────────
ml_model   = load_model("model/model.h5")
words      = pickle.load(open("model/words.pkl",   "rb"))
classes    = pickle.load(open("model/classes.pkl", "rb"))
intents_db = json.load(open(INTENTS_PATH, encoding="utf-8"))
LANG_INDEX = {'english':0, 'sinhala':1, 'tamil':2}

def detect_lang(text):
    s = sum(1 for c in text if '\u0D80'<=c<='\u0DFF')
    t = sum(1 for c in text if '\u0B80'<=c<='\u0BFF')
    if s>0 and s>=t: return 'sinhala'
    if t>0:          return 'tamil'
    return 'english'

def bow(sentence):
    ws = [w for w in sentence.lower().replace('?','').replace('!','').replace('.','').replace(',','').split()]
    return np.array([1 if w in ws else 0 for w in words])

def predict(sentence):
    res = ml_model.predict(np.array([bow(sentence)]), verbose=0)[0]
    return sorted([{"intent":classes[i],"prob":float(r)} for i,r in enumerate(res) if r>0.25],
                  key=lambda x:x["prob"], reverse=True)

def get_reply(preds, lang):
    fb = {
        'english': "Sorry, I didn't understand. Please ask about paddy or corn farming.",
        'sinhala': "සමාවෙන්න, මට තේරුණේ නැහැ. කරුණාකර වී හෝ ඇලිගැට්ටු ගොවිතැන ගැන අහන්න.",
        'tamil':   "மன்னிக்கவும், எனக்கு புரியவில்லை. நெல் அல்லது மக்காச்சோள விவசாயம் பற்றி கேளுங்கள்.",
    }
    if not preds: return fb.get(lang, fb['english'])
    tag = preds[0]["intent"]; idx = LANG_INDEX.get(lang,0)
    for i in intents_db["intents"]:
        if i["tag"]==tag:
            r=i["responses"]; return r[idx] if idx<len(r) else r[0]
    return fb.get(lang, fb['english'])

# ─── AUTH ─────────────────────────────────────────────────────────────────────
@app.route("/auth/register", methods=["POST"])
def register():
    d=request.get_json(force=True)
    name=d.get("name","").strip(); email=d.get("email","").strip().lower()
    phone=d.get("phone","").strip(); password=d.get("password","").strip()
    crop_type=d.get("crop_type","Paddy"); region=d.get("region","Central")
    if not all([name,email,password]):
        return jsonify({"error":"Name, email and password required"}),400
    hashed=bcrypt.generate_password_hash(password).decode("utf-8")
    try:
        conn=get_db()
        conn.execute("INSERT INTO users(name,email,phone,password,crop_type,region) VALUES(?,?,?,?,?,?)",
                     (name,email,phone,hashed,crop_type,region))
        conn.commit()
        uid=conn.execute("SELECT last_insert_rowid()").fetchone()[0]; conn.close()
        token=create_access_token(identity=str(uid))
        return jsonify({"token":token,"user":{"id":uid,"name":name,"email":email,"phone":phone,"crop_type":crop_type,"region":region}}),201
    except sqlite3.IntegrityError:
        return jsonify({"error":"Email already registered"}),409

@app.route("/auth/login", methods=["POST"])
def login():
    d=request.get_json(force=True)
    email=d.get("email","").strip().lower(); password=d.get("password","").strip()
    if not email or not password: return jsonify({"error":"Email and password required"}),400
    conn=get_db(); user=conn.execute("SELECT * FROM users WHERE email=?",(email,)).fetchone(); conn.close()
    if not user or not bcrypt.check_password_hash(user["password"],password):
        return jsonify({"error":"Invalid email or password"}),401
    token=create_access_token(identity=str(user["id"]))
    return jsonify({"token":token,"user":{"id":user["id"],"name":user["name"],"email":user["email"],
                                          "phone":user["phone"],"crop_type":user["crop_type"],"region":user["region"]}})

@app.route("/auth/forgot-password", methods=["POST"])
def forgot_password():
    return jsonify({"message":"If that email exists, a reset link has been sent."})

@app.route("/auth/profile", methods=["GET"])
@jwt_required()
def get_profile():
    uid=int(get_jwt_identity()); conn=get_db()
    u=conn.execute("SELECT id,name,email,phone,crop_type,region FROM users WHERE id=?",(uid,)).fetchone()
    conn.close()
    if not u: return jsonify({"error":"Not found"}),404
    return jsonify(dict(u))

@app.route("/auth/profile", methods=["PUT"])
@jwt_required()
def update_profile():
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("UPDATE users SET name=?,phone=?,crop_type=?,region=? WHERE id=?",
                 (d.get("name"),d.get("phone"),d.get("crop_type"),d.get("region"),uid))
    conn.commit(); conn.close()
    return jsonify({"message":"Profile updated"})

# ─── CHATBOT ──────────────────────────────────────────────────────────────────
@app.route("/chat", methods=["POST"])
def chat():
    d=request.get_json(force=True); msg=d.get("message","").strip()
    cl=d.get("lang","").strip().lower()
    if not msg: return jsonify({"reply":"Please send a message.","language":"english"}),400
    lang=cl if cl in LANG_INDEX else detect_lang(msg)
    return jsonify({"reply":get_reply(predict(msg),lang),"language":lang})

# ─── REMINDERS ────────────────────────────────────────────────────────────────
@app.route("/reminders", methods=["GET"])
@jwt_required()
def get_reminders():
    uid=int(get_jwt_identity()); conn=get_db()
    rows=conn.execute("SELECT * FROM reminders WHERE user_id=? ORDER BY date_time ASC",(uid,)).fetchall()
    conn.close(); return jsonify([dict(r) for r in rows])

@app.route("/reminders", methods=["POST"])
@jwt_required()
def create_reminder():
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("INSERT INTO reminders(user_id,title,reminder_type,crop_type,field_name,date_time,notes) VALUES(?,?,?,?,?,?,?)",
                 (uid,d.get("title",""),d.get("reminder_type",""),d.get("crop_type",""),
                  d.get("field_name",""),d.get("date_time",""),d.get("notes","")))
    conn.commit(); rid=conn.execute("SELECT last_insert_rowid()").fetchone()[0]; conn.close()
    return jsonify({"id":rid,"message":"Reminder created"}),201

@app.route("/reminders/<int:rid>", methods=["PUT"])
@jwt_required()
def update_reminder(rid):
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("UPDATE reminders SET title=?,reminder_type=?,crop_type=?,field_name=?,date_time=?,notes=?,is_completed=? WHERE id=? AND user_id=?",
                 (d.get("title"),d.get("reminder_type"),d.get("crop_type"),
                  d.get("field_name"),d.get("date_time"),d.get("notes",""),d.get("is_completed",0),rid,uid))
    conn.commit(); conn.close(); return jsonify({"message":"Updated"})

@app.route("/reminders/<int:rid>", methods=["DELETE"])
@jwt_required()
def delete_reminder(rid):
    uid=int(get_jwt_identity()); conn=get_db()
    conn.execute("DELETE FROM reminders WHERE id=? AND user_id=?",(rid,uid))
    conn.commit(); conn.close(); return jsonify({"message":"Deleted"})

# ─── MARKET ───────────────────────────────────────────────────────────────────
@app.route("/market/products", methods=["GET"])
def get_products():
    cat=request.args.get("category",""); conn=get_db()
    rows=conn.execute("SELECT * FROM market_products WHERE category=? ORDER BY created_at DESC",(cat,)).fetchall() \
        if cat and cat!="All" else \
        conn.execute("SELECT * FROM market_products ORDER BY created_at DESC").fetchall()
    conn.close(); return jsonify([dict(r) for r in rows])

@app.route("/market/products", methods=["POST"])
@jwt_required()
def create_product():
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("INSERT INTO market_products(user_id,name,price,unit,weight,category,location,description,stock,badge) VALUES(?,?,?,?,?,?,?,?,?,?)",
                 (uid,d["name"],d["price"],d["unit"],d.get("weight",""),d["category"],
                  d["location"],d.get("description",""),d.get("stock","In Stock"),d.get("badge","New")))
    conn.commit(); pid=conn.execute("SELECT last_insert_rowid()").fetchone()[0]; conn.close()
    return jsonify({"id":pid,"message":"Product listed"}),201

@app.route("/market/products/<int:pid>", methods=["PUT"])
@jwt_required()
def update_product(pid):
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("UPDATE market_products SET name=?,price=?,unit=?,weight=?,category=?,location=?,description=?,stock=?,badge=? WHERE id=? AND user_id=?",
                 (d["name"],d["price"],d["unit"],d.get("weight",""),d["category"],
                  d["location"],d.get("description",""),d.get("stock","In Stock"),d.get("badge","New"),pid,uid))
    conn.commit(); conn.close(); return jsonify({"message":"Updated"})

@app.route("/market/products/<int:pid>", methods=["DELETE"])
@jwt_required()
def delete_product(pid):
    uid=int(get_jwt_identity()); conn=get_db()
    conn.execute("DELETE FROM market_products WHERE id=? AND user_id=?",(pid,uid))
    conn.commit(); conn.close(); return jsonify({"message":"Deleted"})

@app.route("/market/my-products", methods=["GET"])
@jwt_required()
def my_products():
    uid=int(get_jwt_identity()); conn=get_db()
    rows=conn.execute("SELECT * FROM market_products WHERE user_id=? ORDER BY created_at DESC",(uid,)).fetchall()
    conn.close(); return jsonify([dict(r) for r in rows])

# ─── MACHINES ─────────────────────────────────────────────────────────────────
@app.route("/machines", methods=["GET"])
def get_machines():
    conn=get_db()
    rows=conn.execute("SELECT * FROM machines WHERE availability=1 ORDER BY created_at DESC").fetchall()
    conn.close(); return jsonify([dict(r) for r in rows])

@app.route("/machines", methods=["POST"])
@jwt_required()
def create_machine():
    uid=int(get_jwt_identity()); d=request.get_json(force=True); conn=get_db()
    conn.execute("INSERT INTO machines(user_id,name,machine_type,price_per_day,location,description) VALUES(?,?,?,?,?,?)",
                 (uid,d["name"],d["machine_type"],d["price_per_day"],d["location"],d.get("description","")))
    conn.commit(); mid=conn.execute("SELECT last_insert_rowid()").fetchone()[0]; conn.close()
    return jsonify({"id":mid,"message":"Machine listed"}),201

@app.route("/machines/<int:mid>", methods=["DELETE"])
@jwt_required()
def delete_machine(mid):
    uid=int(get_jwt_identity()); conn=get_db()
    conn.execute("DELETE FROM machines WHERE id=? AND user_id=?",(mid,uid))
    conn.commit(); conn.close(); return jsonify({"message":"Deleted"})

# ─── HEALTH ───────────────────────────────────────────────────────────────────
@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status":"ok","version":"2.0",
                    "endpoints":["/auth/register","/auth/login","/chat",
                                 "/reminders","/market/products","/machines"]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)  # turn off debug/reloader
