from typing import List, Dict, Any
from langchain_core.agents import AgentFinish
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langchain.agents import AgentExecutor
from langchain.agents.format_scratchpad import format_to_openai_functions
from langchain.agents.output_parsers import OpenAIFunctionsAgentOutputParser

from config import OPENAI_API_KEY, MODEL_NAME, WRITER_PROMPT, TEMPERATURE
from utils.tools import write_tool

class WriterAgent:
    """Агент-писатель, который создает контент на основе исследований."""

    def __init__(self):
        self.llm = ChatOpenAI(
            model=MODEL_NAME,
            temperature=TEMPERATURE,
            api_key=OPENAI_API_KEY
        )
        self.tools = [write_tool()]
        self.agent_executor = self._create_agent()

    def _create_agent(self) -> AgentExecutor:
        """Создает исполнителя агента с необходимыми инструментами и промптами."""
        
        def _create_agent_prompt() -> List[BaseMessage]:
            return [
                HumanMessage(content=WRITER_PROMPT),
                AIMessage(content="Я готов помочь с созданием контента. Какую тему нужно раскрыть?")
            ]

        prompt = _create_agent_prompt()

        agent = (
            {
                "input": lambda x: x["input"],
                "chat_history": lambda x: x["chat_history"],
                "agent_scratchpad": lambda x: format_to_openai_functions(x["intermediate_steps"])
            }
            | prompt
            | self.llm
            | OpenAIFunctionsAgentOutputParser()
        )

        return AgentExecutor(
            agent=agent,
            tools=self.tools,
            verbose=True,
            handle_parsing_errors=True
        )

    async def write(self, 
                   topic: str, 
                   research_results: Dict[str, Any],
                   chat_history: List[BaseMessage] = None) -> Dict[str, Any]:
        """
        Создает контент на основе результатов исследования.
        
        Args:
            topic: Тема для написания
            research_results: Результаты исследования
            chat_history: История чата (опционально)
            
        Returns:
            Dict с созданным контентом
        """
        if chat_history is None:
            chat_history = []

        # Подготовка ключевых моментов из исследования
        key_points = []
        if isinstance(research_results.get("findings"), str):
            key_points = research_results["findings"].split(". ")
        elif isinstance(research_results.get("findings"), list):
            key_points = research_results["findings"]

        result = await self.agent_executor.ainvoke({
            "input": {
                "topic": topic,
                "key_points": key_points
            },
            "chat_history": chat_history
        })

        if isinstance(result, AgentFinish):
            return {
                "topic": topic,
                "content": result.return_values.get("output", "Контент не создан"),
                "status": "completed"
            }
        
        return {
            "topic": topic,
            "content": "Произошла ошибка при создании контента",
            "status": "error"
        } 