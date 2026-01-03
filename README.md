# PA2: ARM Assembly Up/Down Counter (DE1-SoC)

This repository contains the solution for Programming Assignment 2 (PA2), implementing a 2-digit decimal counter (00-59) on the DE1-SoC board using ARMv7 assembly. The project features a fully debounced Start/Stop toggle, a synchronous Reset, and Direction control.

## Project Overview

* **Platform:** DE1-SoC (Cyclone V SoC) / CPUlator Simulator
* **Language:** ARMv7 Assembly
* **Features:**
    * 2-Digit 7-Segment Display (00-59)
    * Debounced Start/Stop Toggle (KEY0)
    * Asynchronous Reset (KEY1)
    * Direction Control (SW0)

---

## Part 1: Debouncing Research & Concepts

### 1. What is Mechanical Switch Bounce?
Mechanical switch bounce is a phenomenon where the metal contacts inside a pushbutton do not close instantly. Due to the elasticity of the materials, the contacts physically "bounce" apart and reconnect several times over a few milliseconds before settling. To a high-speed processor, this looks like a rapid series of On-Off signals (10–20 clicks) rather than a single press.

### 2. Active-Low Logic on DE1-SoC
"Active-Low" means that the device is considered "Active" (ON) when the signal is **0** (Low Voltage) and "Inactive" (OFF) when the signal is **1** (High Voltage). On the DE1-SoC, keys are pulled up to 3.3V by default. Pressing a key connects the circuit to the ground (0V), registering a Logic 0.

### 3. Software Debouncing Methods
To ensure stable operation, software must filter out these false signals. Common methods include:
* **Time Delays:** Pausing execution for 10–20ms after detecting a change to let the signal settle.
* **Confirm-after-Delay:** Checking the input, waiting, and checking again to confirm the state is stable.
* **Wait-for-Release (Blocking):** Pausing the program entirely until the user releases the button.
* **Edge Detection (Non-Blocking):** Comparing the current state to the previous state to trigger an action only on the specific transition (e.g., 0 to 1), allowing the program to continue running in the background.

---

## Part 2: Implementation Summary

### Why Debouncing is Essential
In embedded systems, debouncing is critical because processors run significantly faster than physical mechanical switches. Without debouncing, a single button press is interpreted as multiple inputs, causing counters to skip numbers or control states (e.g., Start/Stop) to flip rapidly.

### Method Implemented: State-Based Edge Detection
For this project, I implemented **Non-Blocking State-Based Edge Detection** rather than a simple delay loop.

* **Mechanism:** The program utilizes a specific register (`R7`) to store the "Last State" of the KEY0 input.
* **Logic:** On every loop cycle, the code compares the *Current State* against the *Last State*.
* **Trigger:** The toggle action executes **only** when the state transitions from **0 (Unpressed)** to **1 (Pressed)**.
* **Reasoning:** This approach is non-blocking, meaning the processor can effectively debounce the switch while simultaneously updating the timer and checking other inputs (Reset/Direction). This ensures the stopwatch maintains accurate timing even if the button is held down.

---

## Part 3: Video Demonstration & Explanations

**Research Questions:**
https://youtu.be/2q7wghQKbKk

**Demonstration (Simulation):**
https://youtu.be/luXIReXM1TE

**Code Explanation (Part 1):**
https://youtu.be/BhmEFMUTBi0

**Code Explanation (Part 2):**
https://youtu.be/eRAhS7D3K20

---

## Note on Requirement 5 (Display Encoding)
*Per the assignment instructions regarding Active-Low encoding:*
The DE1-SoC hardware requires Active-Low inputs for LEDs (0 = ON). However, the CPUlator simulator used for verification treats LEDs as Active-High (1 = ON). To ensure correct visualization in the simulator, this program uses Active-High bit patterns (e.g., `0x3F` for '0') and writes them directly to the display address.
