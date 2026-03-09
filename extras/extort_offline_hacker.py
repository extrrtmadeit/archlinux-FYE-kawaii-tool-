import tkinter as tk
import math
import time


class HackerOfflineScreen:
    def __init__(self, root):
        self.root = root
        self.root.title("EXTORT OFFLINE")
        self.root.configure(bg="#05070d")
        self.root.geometry("1400x850")

        self.canvas = tk.Canvas(root, bg="#05070d", highlightthickness=0)
        self.canvas.pack(fill="both", expand=True)

        self.t = 0.0
        self.matrix_cols = []
        self.last_resize = (0, 0)

        self.canvas.bind("<Configure>", self.on_resize)
        self.root.bind("<F11>", self.toggle_fullscreen)
        self.root.bind("<Escape>", self.exit_fullscreen)

        self.fullscreen = False

        self.build_matrix()
        self.animate()

    def toggle_fullscreen(self, _=None):
        self.fullscreen = not self.fullscreen
        self.root.attributes("-fullscreen", self.fullscreen)

    def exit_fullscreen(self, _=None):
        self.fullscreen = False
        self.root.attributes("-fullscreen", False)

    def on_resize(self, event):
        size = (event.width, event.height)
        if size != self.last_resize:
            self.last_resize = size
            self.build_matrix()

    def build_matrix(self):
        self.matrix_cols = []
        w = max(self.canvas.winfo_width(), 1)
        h = max(self.canvas.winfo_height(), 1)
        col_w = 18
        cols = max(10, w // col_w)
        for c in range(cols):
            x = c * col_w + 8
            y = -((c * 37) % (h + 300))
            speed = 2 + (c % 5)
            length = 8 + (c % 10)
            self.matrix_cols.append([x, y, speed, length])

    def draw_gradient_text(self, text, x, y, size=120):
        layers = [
            ("#7c3aed", 6),
            ("#22d3ee", 3),
            ("#e2e8f0", 0),
        ]
        for color, off in layers:
            self.canvas.create_text(
                x + off,
                y,
                text=text,
                fill=color,
                font=("Consolas", size, "bold"),
                anchor="center",
            )

    def draw_matrix(self):
        h = self.canvas.winfo_height()
        for col in self.matrix_cols:
            x, y, speed, length = col
            for i in range(length):
                ch = chr(0x30A0 + ((i * 7 + int(self.t * 10)) % 96))
                alpha_color = "#22c55e" if i == 0 else "#15803d"
                self.canvas.create_text(x, y - i * 18, text=ch, fill=alpha_color, font=("Consolas", 12), anchor="n")
            col[1] += speed
            if col[1] - length * 18 > h + 40:
                col[1] = -40

    def draw_scanlines(self):
        w = self.canvas.winfo_width()
        h = self.canvas.winfo_height()
        for yy in range(0, h, 4):
            self.canvas.create_line(0, yy, w, yy, fill="#ffffff08")

    def animate(self):
        self.t += 0.045
        self.canvas.delete("all")

        w = self.canvas.winfo_width()
        h = self.canvas.winfo_height()

        # Background glows
        g1x = int(w * (0.2 + 0.05 * math.sin(self.t)))
        g1y = int(h * (0.25 + 0.04 * math.cos(self.t * 1.2)))
        g2x = int(w * (0.78 + 0.04 * math.cos(self.t * 0.7)))
        g2y = int(h * (0.68 + 0.05 * math.sin(self.t * 0.9)))

        self.canvas.create_oval(g1x - 260, g1y - 260, g1x + 260, g1y + 260, fill="#7c3aed", outline="")
        self.canvas.create_oval(g2x - 220, g2y - 220, g2x + 220, g2y + 220, fill="#0ea5e9", outline="")
        self.canvas.create_rectangle(0, 0, w, h, fill="#05070d", outline="")

        self.draw_matrix()
        self.draw_scanlines()

        # Main title block
        pulse = 1 + 0.02 * math.sin(self.t * 2.4)
        main_size = int(128 * pulse)

        self.draw_gradient_text("EXTORT", w // 2, int(h * 0.42), size=main_size)
        self.draw_gradient_text("OFFLINE", w // 2, int(h * 0.58), size=int(main_size * 0.78))

        # Subtitle + status line
        dot_color = "#ef4444" if int(self.t * 2) % 2 == 0 else "#7f1d1d"
        self.canvas.create_oval(w // 2 - 230, int(h * 0.72) - 8, w // 2 - 214, int(h * 0.72) + 8, fill=dot_color, outline="")
        self.canvas.create_text(
            w // 2 - 100,
            int(h * 0.72),
            text="GAMING MODE ACTIVE",
            fill="#94a3b8",
            font=("Consolas", 24, "bold"),
            anchor="w",
        )

        # Bottom helper text
        self.canvas.create_text(
            w // 2,
            h - 38,
            text="F11 fullscreen • ESC exit fullscreen",
            fill="#64748b",
            font=("Consolas", 12),
            anchor="center",
        )

        self.root.after(33, self.animate)


if __name__ == "__main__":
    root = tk.Tk()
    app = HackerOfflineScreen(root)
    root.mainloop()
