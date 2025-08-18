from typing import List, Dict, Any
from langchain_core.agents import AgentFinish
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langchain.agents import AgentExecutor
from langchain.agents.format_scratchpad import format_to_openai_functions
from langchain.agents.output_parsers import OpenAIFunctionsAgentOutputParser
from langchain_core.tools import BaseTool

from config import OPENAI_API_KEY, MODEL_NAME, RESEARCHER_PROMPT, TEMPERATURE
from utils.tools import search_tool

class ResearcherAgent:
    """Агент-исследователь, который ищет и анализирует информацию."""

    def __init__(self):
        # Инициализация языковой модели с заданными параметрами
        self.llm = ChatOpenAI(
            model=MODEL_NAME,  # Имя модели из конфигурации
            temperature=TEMPERATURE,  # Температура генерации
            api_key=OPENAI_API_KEY  # API ключ
        )
        # Установка доступных инструментов
        self.tools = [search_tool()]
        # Создание исполнителя агента
        self.agent_executor = self._create_agent()

    def _create_agent(self) -> AgentExecutor:
        """Создает исполнителя агента с необходимыми инструментами и промптами."""
        
        def _create_agent_prompt() -> List[BaseMessage]:
            # Создание начального промпта для агента
            return [
                HumanMessage(content=RESEARCHER_PROMPT),  # Системный промпт
                AIMessage(content="Я готов помочь с исследованием. Какую тему нужно изучить?")  # Начальное сообщение
            ]

        # Получаем промпт
        prompt = _create_agent_prompt()

        # Создаем цепочку обработки для агента
        agent = (
            {
                # Функции для извлечения данных из входного состояния
                "input": lambda x: x["input"],  # Входные данные
                "chat_history": lambda x: x["chat_history"],  # История чата
                "agent_scratchpad": lambda x: format_to_openai_functions(x["intermediate_steps"])  # Промежуточные шаги
            }
            | prompt  # Добавляем промпт
            | self.llm  # Передаем в языковую модель
            | OpenAIFunctionsAgentOutputParser()  # Парсим результат
        )

        # Создаем и возвращаем исполнителя агента
        return AgentExecutor(
            agent=agent,  # Агент
            tools=self.tools,  # Инструменты
            verbose=True,  # Включаем подробный вывод
            handle_parsing_errors=True  # Обработка ошибок парсинга
        )

    async def research(self, topic: str, chat_history: List[BaseMessage] = None) -> Dict[str, Any]:
        """
        Проводит исследование по заданной теме.
        
        Args:
            topic: Тема для исследования
            chat_history: История чата (опционально)
            
        Returns:
            Dict с результатами исследования
        """
        # Инициализация истории чата, если не предоставлена
        if chat_history is None:
            chat_history = []

        # Запуск исследования через агента
        result = await self.agent_executor.ainvoke({
            "input": f"Исследуй тему: {topic}",
            "chat_history": chat_history
        })

        # Обработка результата
        if isinstance(result, AgentFinish):
            # Если исследование завершено успешно
            return {
                "topic": topic,
                "findings": result.return_values.get("output", "Нет результатов"),
                "status": "completed"
            }
        
        # Если произошла ошибка
        return {
            "topic": topic,
            "findings": "Произошла ошибка при исследовании",
            "status": "error"
        } 