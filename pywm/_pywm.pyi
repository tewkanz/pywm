from typing import Any, Callable

def run(**kwargs: dict[str, Any]) -> None: ...
def register(func: str, call: Callable[..., Any]) -> None: ...
def damage(code: int) -> None: ...
def debug_performance(key: str) -> None: ...
