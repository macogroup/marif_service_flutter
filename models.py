# models.py
from sqlalchemy import Column, Integer, String, Text, JSON, Enum, DECIMAL, TIMESTAMP, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from pydantic import BaseModel
from typing import Optional, List
import json

Base = declarative_base()

# SQLAlchemy модели
class Character(Base):
    __tablename__ = "charact" 
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    age = Column(Integer)
    description = Column(Text)
    avatar_url = Column(String(255))
    cost = Column(DECIMAL(8, 2), nullable=False)  # Исправлено на DECIMAL как в БД
    likes_count = Column(Integer, default=0)
    tag = Column(JSON)
    recom = Column(Enum('male', 'female', 'unisex', name='gender_enum'))
    backstory = Column(Text)
    # created_at убран, так как его нет в вашей таблице

class User(Base):
    __tablename__ = "user"  # Изменено на user (как в вашей БД)
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    login = Column(String(50), unique=True, nullable=False)
    sex = Column(Enum('male', 'female', name='sex_enum'))
    password = Column('pass', String(255), nullable=False)  # Поле называется 'pass' в БД
    coins = Column(Integer, default=50)
    email = Column(String(100), unique=True, nullable=False)

# Pydantic схемы для API
class CharacterCreate(BaseModel):
    name: str
    age: Optional[int] = None
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    cost: float
    likes_count: Optional[int] = 0  # Добавлено поле для инициализации лайков
    tag: Optional[List[str]] = []
    recom: Optional[str] = 'unisex'
    backstory: Optional[str] = None

class CharacterResponse(BaseModel):
    id: int
    name: str
    age: Optional[int]
    description: Optional[str]
    avatar_url: Optional[str]
    cost: float
    likes_count: int
    tag: Optional[List[str]]
    recom: Optional[str]
    backstory: Optional[str]
    created_at: Optional[str] = None  # Убран, так как поля нет в БД

    class Config:
        from_attributes = True

class CharacterUpdate(BaseModel):
    name: Optional[str] = None
    age: Optional[int] = None
    description: Optional[str] = None
    avatar_url: Optional[str] = None
    cost: Optional[float] = None
    likes_count: Optional[int] = None  # Добавлено для обновления лайков
    tag: Optional[List[str]] = None
    recom: Optional[str] = None
    backstory: Optional[str] = None

# Настройка подключения к БД
DATABASE_URL = "mysql+pymysql://root:root@localhost:3306/app_anime"  # Исправлено на app_anime

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Создание таблиц (НЕ НУЖНО - таблицы уже существуют)
def create_tables():
    print("⚠️ Таблицы уже существуют в БД app_anime")
    # Base.metadata.create_all(bind=engine)  # Закомментировано