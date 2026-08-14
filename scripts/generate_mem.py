from pathlib import Path

import cv2 as cv
import numpy as np

# Project root
ROOT = Path(__file__).resolve().parents[1]

# Destination folder for .mem files
DEST = ROOT / "src" / "mem"


def generate_background() -> None:
    """
    Generates a memory initialization file for the background bitmask.
    """

    # Screen resolution
    WIDTH = 640
    HEIGHT = 480

    # Create black background
    bg = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)

    # Add top and bottom boundary lines
    bg[100:110, 40:600] = 1
    bg[440:450, 40:600] = 1

    # Add center dotted line
    for i in range(16):
        center_width = WIDTH // 2
        height = 120 + 20*i
        bg[height:height+10, center_width-5:center_width+5] = 1

    # Add title
    font = cv.FONT_HERSHEY_PLAIN
    scale = 4
    thickness = 2
    (w, h), _ = cv.getTextSize("PONG", font, scale, thickness)
    pos = (WIDTH // 2 - w // 2, 100 // 2 + int(h / 2.5))
    bg = cv.putText(bg, "PONG", pos, font, scale, 1, thickness)

    # Create directory if it doesn't exist
    filename = DEST / "backgrounds" / "background.mem"
    filename.parent.mkdir(parents=True, exist_ok=True)

    # Write to .mem file
    with open(filename, "w") as file:
        for row in bg:
            for bit in row:
                file.write(f"{bool(bit):X} ")
            
            file.write("\n")


def generate_scores() -> None:
    """
    Generates memory initialization files for each score bitmask.
    """

    # Image size
    WIDTH = 100
    HEIGHT = 60
    N = 16

    # Create black backgrounds
    scores = np.zeros((N, HEIGHT, WIDTH), dtype=np.uint8)

    # Create .mem file for each score
    for num in range(N):
        # Create bitmask
        font = cv.FONT_HERSHEY_PLAIN
        scale = 3
        thickness = 2
        (w, h), _ = cv.getTextSize(str(num), font, scale, thickness)
        pos = (WIDTH // 2 - w // 2, HEIGHT // 2 + int(h / 2.5))
        scores[num] = cv.putText(scores[num], str(num), pos, font, scale, 1, thickness)

        # Create directory if it doesn't exist
        filename = DEST / "scores" / f"{num}.mem"
        filename.parent.mkdir(parents=True, exist_ok=True)
        
        # Write to .mem file
        with open(filename, "w") as file:
            for h in range(HEIGHT):
                for w in range(WIDTH):
                    bit = scores[num, h, w]
                    file.write(f"{bool(bit):X} ")

                file.write("\n")


if __name__ == "__main__":
    generate_background()
    generate_scores()
