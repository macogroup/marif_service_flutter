from typing import Dict, Any, List, Annotated
from langgraph.graph import Graph, StateGraph
from langgraph.prebuilt import ToolExecutor

from agents.researcher import ResearcherAgent
from agents.writer import WriterAgent
from agents.reviewer import ReviewerAgent

class ResearchWorkflow:
    """Рабочий процесс исследования с использованием нескольких агентов."""

    def __init__(self):
        # Инициализация всех необходимых агентов
        self.researcher = ResearcherAgent()  # Агент для исследования
        self.writer = WriterAgent()          # Агент для написания
        self.reviewer = ReviewerAgent()      # Агент для проверки

    def create_workflow(self) -> Graph:
        """
        Создает граф рабочего процесса, объединяющий агентов.
        
        Returns:
            Graph: Граф рабочего процесса
        """
        # Создаем граф состояний с определенными узлами
        workflow = StateGraph(nodes=["research", "write", "review", "end"])

        # Определяем функции для каждого узла
        async def research(state: Dict[str, Any]) -> Dict[str, Any]:
            """Выполняет исследование темы."""
            # Получаем тему из состояния
            topic = state["topic"]
            # Получаем историю чата (если есть)
            chat_history = state.get("chat_history", [])
            
            # Запускаем исследование
            result = await self.researcher.research(topic, chat_history)
            # Сохраняем результаты в состоянии
            state["research_results"] = result
            return state

        async def write(state: Dict[str, Any]) -> Dict[str, Any]:
            """Создает контент на основе исследования."""
            # Получаем необходимые данные из состояния
            topic = state["topic"]
            research_results = state["research_results"]
            chat_history = state.get("chat_history", [])
            
            # Создаем контент
            result = await self.writer.write(topic, research_results, chat_history)
            # Сохраняем результат в состоянии
            state["content"] = result
            return state

        async def review(state: Dict[str, Any]) -> Dict[str, Any]:
            """Проверяет созданный контент."""
            # Получаем контент из состояния
            content = state["content"]
            chat_history = state.get("chat_history", [])
            
            # Проверяем контент
            result = await self.reviewer.review(content, chat_history=chat_history)
            # Сохраняем результаты проверки
            state["review"] = result
            return state

        # Добавляем узлы в граф
        workflow.add_node("research", research)  # Узел исследования
        workflow.add_node("write", write)        # Узел написания
        workflow.add_node("review", review)      # Узел проверки

        # Определяем последовательность выполнения (переходы между узлами)
        workflow.add_edge("research", "write")   # От исследования к написанию
        workflow.add_edge("write", "review")     # От написания к проверке
        workflow.add_edge("review", "end")       # От проверки к завершению

        # Устанавливаем начальный узел
        workflow.set_entry_point("research")

        # Компилируем и возвращаем граф
        return workflow.compile()

    async def run(self, topic: str, chat_history: List[Any] = None) -> Dict[str, Any]:
        """
        Запускает рабочий процесс для заданной темы.
        
        Args:
            topic: Тема для исследования
            chat_history: История чата (опционально)
            
        Returns:
            Dict с результатами всего процесса
        """
        # Инициализация истории чата
        if chat_history is None:
            chat_history = []

        # Создаем граф рабочего процесса
        workflow = self.create_workflow()

        # Запускаем процесс с начальным состоянием
        result = await workflow.ainvoke({
            "topic": topic,
            "chat_history": chat_history
        })

        return result 