from kitty.fast_data_types import Screen
from kitty.boss import get_boss
from kitty.tab_bar import (
    DrawData,
    TabBarData,
    TabAccessor,
    ExtraData,
    draw_tab_with_powerline,
    draw_tab_with_separator,
    as_rgb,
)

icons = {
    "nvim": " ",
    "vim": " ",
    "zsh": " ",
    "~": " ",
    "docker": "󰡨 ",
    "kubectl": " ",
    "git": " ",
}

def _rewrite_title(title: str) -> str:
    print(title)
    proc_icon = ""

    if icons.get(title) is not None:
        proc_icon = icons.get(title)

    return proc_icon

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

    new_title = _rewrite_title(tab.title)
    tab = tab._replace(title=new_title)

    active_id = get_boss().active_tab.id
    active_tab = TabAccessor(active_id)


    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg

    if index == 1:
        # title = active_tab.active_oldest_exe
        title = tab.layout_name
        screen.cursor.italic = False
        screen.cursor.bold = True
        screen.cursor.fg = as_rgb(0x81C8BE)
        screen.cursor.bg = as_rgb(0x232634)
        cell = f"  {title}"
        screen.draw(cell + " " )

    active_separator_fg = 0xFFC777
    active_separator_bg = 0x0B0D11

    inactive_separator_fg = 0x606060
    inactive_separator_bg = 0x16161E

    if tab.is_active:
        screen.cursor.fg = as_rgb(int(active_separator_fg))
        screen.cursor.bg = as_rgb(int(active_separator_bg))
        screen.draw("▎",)
    elif extra_data.prev_tab is None or extra_data.prev_tab.tab_id != active_id:
        screen.cursor.fg = as_rgb(int(inactive_separator_fg))
        screen.cursor.bg = as_rgb(int(inactive_separator_bg))
        screen.cursor.bold = False
        screen.draw("▎",)

    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg

    # Tab title: <tab index> -> <application>
    draw_tab_with_separator(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    if tab.is_active and extra_data.next_tab is not None:
        screen.cursor.fg = as_rgb(int(inactive_separator_fg))
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        screen.draw("▎")

    return screen.cursor.x
    # new_draw_data = draw_data._replace(
    #     title_template="{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}"
    #     + "{index} "
    #     + layout_icon
    #     + "{tab.last_focused_progress_percent}"
    #     + proc_icon
    #     + "{title}"
    #     + " "
    #     # active_title_template inherits title_template if nil
    # )
    # retun draw_tab_with_separator(
    #     new_draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    # )
