"""
Пакет с агентами для обработки различных задач.
"""

from .researcher import ResearcherAgent
from .writer import WriterAgent
from .reviewer import ReviewerAgent

__all__ = ['ResearcherAgent', 'WriterAgent', 'ReviewerAgent'] 