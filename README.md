
# Tactical Graph Network Simulator

A military-themed, casual tactical simulation game built with **Godot 4** and **.NET / C#**. This project serves as an interactive playground for graph theory concepts, disguised as a war room planning board where users deploy military bases and establish secure, optimized supply lines.

## Project Objective
The main goal of this simulator is to bridge game design with computer science fundamentals—specifically **Graph Theory**. By placing nodes (military bases) and connecting them via edges (supply routes), the game intuitively visualizes network connectivity, optimization constraints, and layout boundaries, making complex algorithmic concepts tangible and highly interactive.

---

## Features & Core Mechanics

* **Dynamic Node Placement:** Left-click to deploy tactical bases on the grid.
* **Targeted Node Removal:** Right-click directly on an existing base to safely deconstruct it from the network.
* **Intuitive Camera Controls:** Seamlessly zoom in and out using the mouse wheel to inspect massive networks or focus on fine layout details.
* **Interactive Constraints Menu:** A clean, responsive UI panel featuring granular sliders to adjust limit thresholds on the fly.
* **Audio Polish (Game Juice):** Dynamic, pitch-shifted sound effects for UI interaction, node deployment, destruction, and a continuous military-themed background ambient track.
* **Robust Input Handling:** Advanced input filtering ensures UI sliders and scrollbars absorb mouse events perfectly without leaking commands to the underlying camera layer.

## 🛠️ Technical Stack
* **Engine:** Godot Engine 4+
* **Language:** GDScript
* **Architecture:** Singleton pattern for global audio state handling (`AudioManager`), and Unhandled Input decoupling to separate interface actions from world mechanics.

---

## 📦 How to Play / Run

### Download Pre-built Binaries
You can find standalone executables for **Windows (.exe)** and **Linux (x86)** under the **Releases** tab of this repository. Just extract the `.zip` archive for your platform and run the executable!

### Running from Source
1. Clone this repository:
   ```bash
   git clone https://github.com/seu-usuario/nome-do-repositorio.git
2. Open Godot Engine 4 
3. Import the project.godot file.
4. Press F5 to run.

### Controls
- **InputActionLeft Click**: Place a base / interact with UI
- **InputActionRight Click**: Delete a base
- **InputActionMouse Wheel Up/Down**: Zoom camera in / out
- **InputActionUI Scrollbar Drag**: Navigate the Limit Options menu