from typing import List, Dict, Any
from langchain_core.agents import AgentFinish
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langchain.agents import AgentExecutor
from langchain.agents.format_scratchpad import format_to_openai_functions
from langchain.agents.output_parsers import OpenAIFunctionsAgentOutputParser

from config import OPENAI_API_KEY, MODEL_NAME, REVIEWER_PROMPT, TEMPERATURE
from utils.tools import review_tool

class ReviewerAgent:
    """Агент-рецензент, который проверяет и улучшает контент."""

    def __init__(self):
        self.llm = ChatOpenAI(
            model=MODEL_NAME,
            temperature=TEMPERATURE,
            api_key=OPENAI_API_KEY
        )
        self.tools = [review_tool()]
        self.agent_executor = self._create_agent()

    def _create_agent(self) -> AgentExecutor:
        """Создает исполнителя агента с необходимыми инструментами и промптами."""
        
        def _create_agent_prompt() -> List[BaseMessage]:
            return [
                HumanMessage(content=REVIEWER_PROMPT),
                AIMessage(content="Я готов помочь с проверкой контента. Что нужно проанализировать?")
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

    async def review(self, 
                    content: Dict[str, Any],
                    criteria: List[str] = None,
                    chat_history: List[BaseMessage] = None) -> Dict[str, Any]:
        """
        Проверяет и улучшает контент.
        
        Args:
            content: Контент для проверки
            criteria: Критерии проверки (опционально)
            chat_history: История чата (опционально)
            
        Returns:
            Dict с результатами проверки
        """
        if chat_history is None:
            chat_history = []

        if criteria is None:
            criteria = ["accuracy", "clarity", "completeness"]

        result = await self.agent_executor.ainvoke({
            "input": {
                "content": content.get("content", ""),
                "criteria": criteria
            },
            "chat_history": chat_history
        })

        if isinstance(result, AgentFinish):
            review_result = result.return_values.get("output", {})
            if isinstance(review_result, str):
                review_result = {"feedback": review_result}

            return {
                "topic": content.get("topic", "Unknown"),
                "review": review_result,
                "status": "completed"
            }
        
        return {
            "topic": content.get("topic", "Unknown"),
            "review": "Произошла ошибка при проверке контента",
            "status": "error"
        } 