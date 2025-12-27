"""
Blueberry: The minimal full-stack ChatGPT clone

A clean, hackable codebase for learning LLM fundamentals that can be trained
end-to-end for ~$100 on 8xH100 GPUs.
"""

__version__ = "0.1.0"
__author__ = "Blueberry Team"

from . import nanochat
from . import scripts
from . import tasks

__all__ = ["nanochat", "scripts", "tasks"]
