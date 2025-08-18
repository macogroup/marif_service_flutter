# Импорт для работы с асинхронным кодом
import asyncio
# Импорты для типизации
from typing import Dict, Any
# Импорт для работы с JSON
import json
# Импорт нашего рабочего процесса
from graphs.research_flow import ResearchWorkflow

async def main():
    """
    Основная функция для демонстрации работы агентов.
    """
    # Создаем экземпляр рабочего процесса
    workflow = ResearchWorkflow()
    
    # Задаем тему для исследования
    topic = "Искусственный интеллект в медицине"
    
    # Выводим информацию о начале работы
    print(f"Начинаем исследование темы: {topic}")
    print("-" * 50)
    
    try:
        # Запускаем рабочий процесс и получаем результаты
        result = await workflow.run(topic)
        
        # Выводим результаты исследования
        print("\nРезультаты исследования:")
        print(json.dumps(result["research_results"], indent=2, ensure_ascii=False))
        
        # Выводим созданный контент
        print("\nСозданный контент:")
        print(json.dumps(result["content"], indent=2, ensure_ascii=False))
        
        # Выводим результаты проверки
        print("\nРезультаты проверки:")
        print(json.dumps(result["review"], indent=2, ensure_ascii=False))
        
    except Exception as e:
        # Обработка возможных ошибок
        print(f"Произошла ошибка: {str(e)}")

# Точка входа в программу
if __name__ == "__main__":
    # Запускаем асинхронную функцию main
    asyncio.run(main()) 