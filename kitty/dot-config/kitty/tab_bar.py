from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    TabBarData,
    ExtraData,
    draw_tab_with_powerline,
)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """
    Kitty's DrawData is defined here:
    https://github.com/kovidgoyal/kitty/blob/master/kitty/tab_bar.py#L58

    Strat is to edit title_template and active_title_template
    and call the original draw_tab_with_* function.
    """

    layout_icon = ""
    if tab.layout_name == "stack":
        layout_icon = " "

    proc_icon = ""
    if tab.title == "vim":
        proc_icon = " "
    elif tab.title == "zsh":
        proc_icon = ""

    new_draw_data = draw_data._replace(
        title_template="{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}"
        + "{index} "
        + layout_icon
        + "{tab.last_focused_progress_percent}"
        + proc_icon
        + "{title}"
        # active_title_template inherits title_template if nil
    )

    return draw_tab_with_powerline(
        new_draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
