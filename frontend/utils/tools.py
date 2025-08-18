from typing import List, Dict, Any
from langchain_core.tools import Tool
from langchain_core.pydantic_v1 import BaseModel, Field

class SearchInput(BaseModel):
    """Класс для валидации входных данных поискового инструмента."""
    query: str = Field(..., description="The search query")

class WriteInput(BaseModel):
    """Класс для валидации входных данных инструмента для написания контента."""
    topic: str = Field(..., description="The topic to write about")
    key_points: List[str] = Field(..., description="Key points to include")

class ReviewInput(BaseModel):
    """Класс для валидации входных данных инструмента для проверки контента."""
    content: str = Field(..., description="The content to review")
    criteria: List[str] = Field(default=["accuracy", "clarity", "completeness"], 
                              description="Review criteria")

def search_tool() -> Tool:
    """Создает инструмент для поиска информации."""
    def search(query: str) -> Dict[str, Any]:
        # В реальном приложении здесь был бы код для поиска информации
        # Например, использование DuckDuckGo, Google Custom Search или других API
        return {
            "results": [
                {"title": "Example result 1", "snippet": "Example content..."},
                {"title": "Example result 2", "snippet": "More content..."}
            ],
            "query": query
        }

    return Tool.from_function(
        func=search,
        name="search",
        description="Search for information on a given topic",
        args_schema=SearchInput
    )

def write_tool() -> Tool:
    """Создает инструмент для написания контента."""
    def write(topic: str, key_points: List[str]) -> str:
        # В реальном приложении здесь была бы логика генерации контента
        return f"Generated content about {topic} including points: {', '.join(key_points)}"

    return Tool.from_function(
        func=write,
        name="write",
        description="Write content on a given topic",
        args_schema=WriteInput
    )

def review_tool() -> Tool:
    """Создает инструмент для проверки контента."""
    def review(content: str, criteria: List[str]) -> Dict[str, Any]:
        # В реальном приложении здесь была бы логика проверки контента
        return {
            "score": 0.85,
            "feedback": "Content is good but could be improved...",
            "suggestions": ["Add more examples", "Clarify the main point"]
        }

    return Tool.from_function(
        func=review,
        name="review",
        description="Review and provide feedback on content",
        args_schema=ReviewInput
    )

# Список всех доступных инструментов для использования в агентах
available_tools = [
    search_tool(),
    write_tool(),
    review_tool()
] 