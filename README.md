<h1 align="center">PA 2: ARM Assembly Up/Down Counter (DE1-SoC)</h1>

<p align="justify">
This repository contains the solution for Programming Assignment 2 (PA2), implementing a 2-digit decimal counter (00-59) on the DE1-SoC board using ARMv7 assembly. The project features a fully debounced Start/Stop toggle, a synchronous Reset, and Direction control.
</p>

<h2 align="center">Project Overview</h2>

<ul>
    <li><strong>Platform:</strong> DE1-SoC (Cyclone V SoC) / CPUlator Simulator</li>
    <li><strong>Language:</strong> ARMv7 Assembly</li>
    <li><strong>Features:</strong>
        <ul>
            <li>2-Digit 7-Segment Display (00-59)</li>
            <li>Debounced Start/Stop Toggle (KEY0)</li>
            <li>Asynchronous Reset (KEY1)</li>
            <li>Direction Control (SW0)</li>
        </ul>
    </li>
</ul>

<hr>

<h2 align="center">Part 1: Debouncing Research & Concepts</h2>

<h3>1. What is Mechanical Switch Bounce?</h3>
<p align="justify">
Mechanical switch bounce is a phenomenon where the metal contacts inside a pushbutton do not close instantly. Due to the elasticity of the materials, the contacts physically "bounce" apart and reconnect several times over a few milliseconds before settling. To a high-speed processor, this looks like a rapid series of On-Off signals (10–20 clicks) rather than a single press.
</p>

<h3>2. Active-Low Logic on DE1-SoC</h3>
<p align="justify">
"Active-Low" means that the device is considered "Active" (ON) when the signal is <strong>0</strong> (Low Voltage) and "Inactive" (OFF) when the signal is <strong>1</strong> (High Voltage). On the DE1-SoC, keys are pulled up to 3.3V by default. Pressing a key connects the circuit to the ground (0V), registering a Logic 0.
</p>

<h3>3. Software Debouncing Methods</h3>
<p align="justify">
To ensure stable operation, software must filter out these false signals. Common methods include:
</p>
<ul>
    <li><strong>Time Delays:</strong> Pausing execution for 10–20ms after detecting a change to let the signal settle.</li>
    <li><strong>Confirm-after-Delay:</strong> Checking the input, waiting, and checking again to confirm the state is stable.</li>
    <li><strong>Wait-for-Release (Blocking):</strong> Pausing the program entirely until the user releases the button.</li>
    <li><strong>Edge Detection (Non-Blocking):</strong> Comparing the current state to the previous state to trigger an action only on the specific transition (e.g., 0 to 1), allowing the program to continue running in the background.</li>
</ul>

<hr>

<h2 align="center">Part 2: Implementation Summary</h2>

<h3>Why Debouncing is Essential</h3>
<p align="justify">
In embedded systems, debouncing is critical because processors run significantly faster than physical mechanical switches. Without debouncing, a single button press is interpreted as multiple inputs, causing counters to skip numbers or control states (e.g., Start/Stop) to flip rapidly.
</p>

<h3>Method Implemented: State-Based Edge Detection</h3>
<p align="justify">
For this project, I implemented <strong>Non-Blocking State-Based Edge Detection</strong> rather than a simple delay loop.
</p>

<ul>
    <li><strong>Mechanism:</strong> The program utilizes a specific register (<code>R7</code>) to store the "Last State" of the KEY0 input.</li>
    <li><strong>Logic:</strong> On every loop cycle, the code compares the <em>Current State</em> against the <em>Last State</em>.</li>
    <li><strong>Trigger:</strong> The toggle action executes <strong>only</strong> when the state transitions from <strong>0 (Unpressed)</strong> to <strong>1 (Pressed)</strong>.</li>
    <li><strong>Reasoning:</strong> This approach is non-blocking, meaning the processor can effectively debounce the switch while simultaneously updating the timer and checking other inputs (Reset/Direction). This ensures the stopwatch maintains accurate timing even if the button is held down.</li>
</ul>

<hr>

<h2 align="center">Part 3: Video Demonstration & Explanations</h2>

<p><strong>Research Questions:</strong><br>
https://youtu.be/2q7wghQKbKk</p>

<p><strong>Demonstration (Simulation):</strong><br>
https://youtu.be/luXIReXM1TE</p>

<p><strong>Code Explanation (Part 1):</strong><br>
https://youtu.be/BhmEFMUTBi0</p>

<p><strong>Code Explanation (Part 2):</strong><br>
https://youtu.be/eRAhS7D3K20</p>

<hr>
