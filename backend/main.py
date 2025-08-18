# main.py
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from typing import List
import json

from models import Character, User, get_db, CharacterCreate, CharacterResponse, CharacterUpdate

app = FastAPI(title="Anime Characters Admin", version="1.0.0")

# Статические файлы (если нужны)
# app.mount("/static", StaticFiles(directory="static"), name="static")

# Главная страница админки
@app.get("/", response_class=HTMLResponse)
def admin_dashboard():
    return """
    <html>
        <head>
            <title>Anime Characters Admin</title>
            <style>
                body { font-family: Arial; margin: 40px; }
                .container { max-width: 1200px; margin: 0 auto; }
                .btn { padding: 10px 20px; margin: 5px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; }
                .btn:hover { background: #0056b3; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🎌 Anime Characters Admin Panel</h1>
                <p>API для управления персонажами аниме</p>
                
                <h3>📋 Основные эндпоинты:</h3>
                <ul>
                    <li><a href="/docs" class="btn">📖 API Документация (Swagger)</a></li>
                    <li><a href="/characters" class="btn">👥 Все персонажи</a></li>
                    <li><a href="/redoc" class="btn">📚 ReDoc</a></li>
                </ul>
                
                <h3>🔧 Быстрые действия:</h3>
                <p>Используйте <strong>/docs</strong> для тестирования API через интерфейс</p>
            </div>
        </body>
    </html>
    """

# CRUD операции для персонажей
@app.post("/characters/", response_model=CharacterResponse, status_code=status.HTTP_201_CREATED)
def create_character(character: CharacterCreate, db: Session = Depends(get_db)):
    """Создать нового персонажа"""
    
    # Конвертируем список тегов в JSON
    tags_json = json.dumps(character.tag) if character.tag else json.dumps([])
    
    db_character = Character(
        name=character.name,
        age=character.age,
        description=character.description,
        avatar_url=character.avatar_url,
        cost=character.cost,
        likes_count=character.likes_count,
        tag=tags_json,
        recom=character.recom,
        backstory=character.backstory
    )
    
    db.add(db_character)
    db.commit()
    db.refresh(db_character)
    
    # Преобразуем теги для возврата
    if db_character.tag:
        try:
            db_character.tag = json.loads(db_character.tag)
        except (json.JSONDecodeError, TypeError):
            db_character.tag = []
    else:
        db_character.tag = []
    
    return db_character

@app.get("/characters/", response_model=List[CharacterResponse])
def get_all_characters(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить всех персонажей"""
    characters = db.query(Character).offset(skip).limit(limit).all()
    
    # Конвертируем JSON теги обратно в список для каждого персонажа
    for char in characters:
        if char.tag:
            try:
                char.tag = json.loads(char.tag) if isinstance(char.tag, str) else char.tag
            except (json.JSONDecodeError, TypeError):
                char.tag = []
        else:
            char.tag = []
    
    return characters

@app.get("/characters/{character_id}", response_model=CharacterResponse)
def get_character(character_id: int, db: Session = Depends(get_db)):
    """Получить персонажа по ID"""
    character = db.query(Character).filter(Character.id == character_id).first()
    
    if not character:
        raise HTTPException(status_code=404, detail="Персонаж не найден")
    
    # Конвертируем JSON теги
    if character.tag:
        try:
            character.tag = json.loads(character.tag) if isinstance(character.tag, str) else character.tag
        except (json.JSONDecodeError, TypeError):
            character.tag = []
    else:
        character.tag = []
    
    return character

@app.put("/characters/{character_id}", response_model=CharacterResponse)
def update_character(character_id: int, character_update: CharacterUpdate, db: Session = Depends(get_db)):
    """Обновить персонажа"""
    character = db.query(Character).filter(Character.id == character_id).first()
    
    if not character:
        raise HTTPException(status_code=404, detail="Персонаж не найден")
    
    # Обновляем только переданные поля
    update_data = character_update.dict(exclude_unset=True)
    
    # Конвертируем теги в JSON если они есть
    if 'tag' in update_data:
        update_data['tag'] = json.dumps(update_data['tag'])
    
    for field, value in update_data.items():
        setattr(character, field, value)
    
    db.commit()
    db.refresh(character)
    
    # Конвертируем теги обратно для ответа
    if character.tag:
        try:
            character.tag = json.loads(character.tag) if isinstance(character.tag, str) else character.tag
        except (json.JSONDecodeError, TypeError):
            character.tag = []
    else:
        character.tag = []
    
    return character

@app.delete("/characters/{character_id}")
def delete_character(character_id: int, db: Session = Depends(get_db)):
    """Удалить персонажа"""
    character = db.query(Character).filter(Character.id == character_id).first()
    
    if not character:
        raise HTTPException(status_code=404, detail="Персонаж не найден")
    
    db.delete(character)
    db.commit()
    
    return {"message": f"Персонаж {character.name} успешно удален"}

# Дополнительные эндпоинты
@app.get("/characters/search/{name}")
def search_characters(name: str, db: Session = Depends(get_db)):
    """Поиск персонажей по имени"""
    characters = db.query(Character).filter(Character.name.contains(name)).all()
    return characters

@app.post("/characters/{character_id}/like")
def like_character(character_id: int, db: Session = Depends(get_db)):
    """Увеличить количество лайков"""
    character = db.query(Character).filter(Character.id == character_id).first()
    
    if not character:
        raise HTTPException(status_code=404, detail="Персонаж не найден")
    
    character.likes_count += 1
    db.commit()
    
    return {"message": f"Лайк добавлен! Всего лайков: {character.likes_count}"}

# CRUD для пользователей
@app.get("/users/", response_model=List[dict])
def get_all_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Получить всех пользователей"""
    users = db.query(User).offset(skip).limit(limit).all()
    return [{"id": u.id, "name": u.name, "login": u.login, "email": u.email, "coins": u.coins, "sex": u.sex} for u in users]

@app.get("/users/{user_id}")
def get_user(user_id: int, db: Session = Depends(get_db)):
    """Получить пользователя по ID"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Пользователь не найден")
    return {"id": user.id, "name": user.name, "login": user.login, "email": user.email, "coins": user.coins, "sex": user.sex}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)