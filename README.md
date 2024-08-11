# Trigger Surround Cache (TSC) Module

## Overview
This project implements a Trigger Surround Cache (TSC) module using Verilog. The TSC module is designed as part of a transient trigger detection system, which is used to detect environmental changes or signals from other parts of a system. The project follows a top-down design approach, starting with high-level design and progressing through low-level design and gate-level simulation.

## Authors
- Bonga Njamela
- Karan Abraham (https://github.com/karanimaan/Prac-5--Verilog)

## Institution
University of Cape Town, South Africa  
EEE4120F, May 1, 2024

## Table of Contents
1. [Introduction](#introduction)
2. [Design and Implementation](#design-and-implementation)
    - [High-Level Design](#high-level-design)
    - [Low-Level Design](#low-level-design)
    - [Register Transfer Level Coding](#register-transfer-level-coding)
3. [Testing and Validation](#testing-and-validation)
4. [Usage](#usage)
5. [File Structure](#file-structure)
6. [Conclusion](#conclusion)

## Introduction
The TSC module is designed to detect and respond to trigger events by monitoring changes in the environment, such as variations in electromagnetic properties. The module consists of several key components, including a 32-bit timer, a 32-byte ring buffer, and a flash ADC. The design is verified through simulation using a test bench that simulates clock, reset, and test vectors to ensure proper functionality.

## Design and Implementation

### High-Level Design
The TSC module is composed of several internal blocks, including a clock, a 32-bit timer, a 32-byte ring buffer, and a flash ADC. The module operates as follows:
1. **Idle State**: The TSC continuously reads 8-bit values from the ADC while in an idle state.
2. **Trigger Detection**: A trigger event is detected when the ADC value exceeds a configured threshold. The current timer value is stored in a 32-bit register.
3. **Buffering**: The TSC reads 16 values from the ADC and stores them in the ring buffer.
4. **Data Transmission**: Upon a request, the TSC transmits the buffered data through a serial data line.

### Low-Level Design
The TSC module is modeled using a clock-triggered Finite State Machine (FSM) with four primary states: IDLE, RUNNING, TRIGGERED, and BUFFER_SEND. The FSM handles state transitions based on external events and clock edges, ensuring accurate detection and data transmission.

### Register Transfer Level Coding
The Verilog implementation includes modules for the ADC and TSC. The ADC module reads 16 8-bit values from a CSV file, simulating analog-to-digital conversion. The TSC module interfaces with the ADC and handles trigger detection, data buffering, and transmission.

#### Example Code Snippets
- **MATLAB Code for ADC Data Generation**
  ```matlab
  num_values = 16;
  adc_values = randi([0, 255], 1, num_values);
  csvwrite('adc_values.csv', adc_values');

### Verilog Code for TSC Module Instantiation

`timescale 1ns / 1ps
module TriggerSurroundCache (
    input wire reset,
    input wire start,
    input wire clk,
    input wire [7:0] adc_data,
    input wire req,
    input wire sbf,
    input wire rdy,
    output reg trd,
    output reg cd,
    output reg [31:0] trigtm,
    output reg sd
);

## Testing and Validation

The TSC module was tested using a test bench to verify that it meets the functional requirements. The test bench simulated various scenarios to validate the reset logic, clock generator, and overall behavior of the TSC module.

### Functional Verification of ADC
The ADC module was tested to ensure that it correctly reads and stores values from the input CSV file. The uniform distribution of ADC values was verified through repeated simulation runs, confirming the accuracy of the ADC model.

### Usage

#### Simulation: 
Use a Verilog simulator (e.g., ModelSim) to run the provided test bench and verify the TSC module's functionality.

#### Synthesis: 
The Verilog code can be synthesized for implementation on an FPGA.

### File Structure

#### README.md: 
This file, providing an overview and instructions.

#### TriggerSurroundCache.v: 
Verilog code for the TSC module.

#### ADC.v: 
Verilog code for the ADC module.

#### testbench.v: 
Test bench for verifying the TSC and ADC modules.

#### adc_values.csv: 
Input file containing ADC values.

## Conclusion
This project successfully implements a Trigger Surround Cache (TSC) module in Verilog, capable of detecting trigger events and transmitting buffered data. The design was validated through simulation, ensuring that the module meets the specified functional requirements.
