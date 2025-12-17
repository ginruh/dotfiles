from ignis import widgets


class Clock(widgets.Window):
    __gtype_name__ = "MyClock"

    def __init__(self, monitor: int):
        super().__init__(
            namespace=f"some-clock-{monitor}", monitor=monitor, anchor=[""]
        )


class Bar(widgets.Window):
    __gtype_name__ = "MyBar"

    def __init__(self, monitor: int):
        button1 = widgets.Button(
            child=widgets.Label(label="Click me!"),
            on_click=lambda x: print("you clicked the button 1"),
        )
        button2 = widgets.Button(
            child=widgets.Label(label="Close window"),
            on_click=lambda x: self.set_visible(False),
        )
        button3 = widgets.Button(
            child=widgets.Label(label="Custom function on self"),
            on_click=lambda x: self.some_func(),
        )
        super().__init__(
            namespace=f"some-window-{monitor}",
            monitor=monitor,
            anchor=["left", "top", "right"],
            child=widgets.Box(
                spacing=10,
                child=[
                    widgets.Label(label="This window created using a custom class"),
                    button1,
                    button2,
                    button3,
                ],
            ),
        )

    def some_func(self) -> None:
        print("Custom function on self!")


Bar(0)
