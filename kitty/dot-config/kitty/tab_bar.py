import os
from pathlib import Path

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
    "sh": " ",
    "bash": " ",
    "docker": "󰡨 ",
    "kubectl": " ",
    "git": " ",
    "claude": " ",
    "ssh": "󰣀 ",
}

# ssh options that take a value as the next argument
SSH_OPTS_WITH_ARG = set("BbcDEeFIiJLlmOoPpQRSWw")

HOME = str(Path.home())


def _format_cwd(cwd: str) -> str:
    if not cwd or cwd == HOME:
        return "~"

    parts = [p for p in cwd.split(os.sep) if p]
    if not parts:
        return os.sep

    short = "/".join(parts[-2:])
    if len(short) > 20:
        return parts[-1]
    return short


def _is_ssh_cmdline(cmdline: list) -> bool:
    if not cmdline:
        return False
    exe = os.path.basename(cmdline[0])
    if exe == "ssh":
        return True
    return exe == "kitten" and len(cmdline) > 1 and cmdline[1] == "ssh"


def _ssh_host(cmdline: list) -> str:
    args = cmdline[1:]
    if args and os.path.basename(cmdline[0]) == "kitten" and args[0] == "ssh":
        args = args[1:]

    skip_next = False
    for arg in args:
        if skip_next:
            skip_next = False
            continue
        if arg == "--":
            continue
        if arg.startswith("-") and len(arg) > 1:
            # Value-taking option without attached value, e.g. "-p 22"
            if len(arg) == 2 and arg[1] in SSH_OPTS_WITH_ARG:
                skip_next = True
            continue
        dest = arg
        if dest.startswith("ssh://"):
            dest = dest[len("ssh://"):]
        dest = dest.rsplit("@", 1)[-1]
        if not dest.startswith("["):
            dest = dest.split(":", 1)[0]
        return dest or "ssh"
    return "ssh"


def _ssh_cmdline(window) -> list:
    try:
        for proc in window.child.foreground_processes:
            cmdline = proc.get("cmdline") or []
            if _is_ssh_cmdline(cmdline):
                return cmdline
    except Exception:
        pass
    return []


def _tab_label(tab_id: int) -> str:
    tab_obj = get_boss().tab_for_id(tab_id)
    if tab_obj is None:
        return ""

    window = tab_obj.active_window
    if window is None or window.at_prompt:
        return _format_cwd(tab_obj.get_cwd_of_active_window() or "")

    exe = os.path.basename(tab_obj.get_exe_of_active_window(oldest=True) or "")

    if exe in ("nvim", "vim"):
        cwd = (tab_obj.get_cwd_of_active_window() or "").rstrip(os.sep)
        project = "~" if not cwd or cwd == HOME else os.path.basename(cwd)
        return f"{icons[exe]}{project}"

    if exe in ("ssh", "kitten"):
        cmdline = _ssh_cmdline(window)
        if cmdline:
            return f"{icons['ssh']}{_ssh_host(cmdline)}"

    icon = icons.get(exe)
    if icon is not None:
        return f"{icon}{exe}"
    return exe

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

    new_title = _tab_label(tab.tab_id)
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
